require 'nokogiri'
require 'htmlentities'

require_relative '../../app/parsers/base_parser'
require_relative '../../app/parsers/styleforum_parser'

dir = File.dirname(__FILE__)

describe StyleforumParser do

  context "index page" do
    let(:parser) { StyleforumParser.new(page) }
    let(:page) { File.read(File.join(dir, "fixtures/styleforum/index.html")) }

    before do
      parser.stub(:fetch) { File.open(File.join(dir, "fixtures/styleforum/detail.html")) }
    end

    it "returns a list of items for sale" do
      parser.items.should be
      parser.items.first[:title].should be
      parser.items.first[:url].should be
      parser.items.first[:description].should be
      parser.items.first[:price].should be
      parser.items.first[:images].should be
    end
  end
end
