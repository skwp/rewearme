# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require "#{Rails.root}/app/parsers/styleforum_parser"

def load_local_data(class_name, dir, category=nil)
  fixture_dir = "#{Rails.root}/spec/unit/fixtures/#{dir}"
  source_site = dir.titleize
  parser = class_name.new(File.read(File.join(fixture_dir, "index.html")))
  parser.fetcher = lambda {|url| File.open(File.join(fixture_dir, "detail.html"))}

  parser.items[0..1].each do |item|
    SaleItem.create({:category => category, :source_site => source_site}.merge(item))
  end
end

def load_remote_data(clazz, url, source_site, category=nil)
  trapping_errors do
    clazz.new(open(url).read).items.each do |item|
      next if item[:title] =~ /WTB/
      next if item[:title] =~ /Want\w* To Buy/i
      next if item[:price] !~ /^\W?\d+/ # Skip items whose price is strangely formatted
      puts item.inspect
      SaleItem.create({:category => category, :source_site => source_site}.merge(item)) rescue nil
    end
  end
end

def trapping_errors(&block)
  begin
    block.call
  rescue
    puts $!
  rescue Timeout::ERROR
    puts $!
    retry
  end
end


SaleItem.transaction do

  SaleItem.delete_all

  # For Local Development
  if ENV['OFFLINE']
    puts "Seeding with local fixture because OFFLINE=true. If internet connection is present, change this to use remote data in db/seeds.rb."

    load_local_data StyleforumParser, "styleforum", "formal"
    load_local_data SuperfutureParser, "superfuture", "streetwear"
    load_local_data SolecollectorParser, "solecollector", "shoes"
    load_local_data StyleguiseParser, "styleguise"
  else
    puts "Loading data from Styleforum streetwear...For offline data, use OFFLINE=true rake db:seed"
    load_remote_data StyleforumParser, "http://www.styleforum.net/f/6875/streetwear-denim-classifieds", "Styleforum", "streetwear"

    puts "Loading data from Styleforum mens forum..."
    load_remote_data StyleforumParser, "http://www.styleforum.net/f/6714/mens-clothing-classifieds", "Styleforum", "formal"

    puts "Loading data from Superfuture..."
    load_remote_data SuperfutureParser, "http://supertalk.superfuture.com/index.php?/forum/21-supermarket/", "Superfuture", "streetwear"

    puts "Loading data from Solecollector..."
    load_remote_data SolecollectorParser, "http://solecollector.com/Sneakers/Marketplace/", "Sole Collector", "shoes"

    puts "Loading data from Styleguise (page 1 only)..."
    load_remote_data StyleguiseParser, "http://marketplace.styleguise.net/api/v1/item/list", "StyleGuise"

    puts "Done."
  end

end
