# Must use ruby 1.9 to get proper unicode
require 'open-uri'

class BaseParser
  DESCRIPTION_SIZE = 200

  attr_reader :parsed, :source_data

  # You can override the way this class fetches data by overloading its fetcher method
  attr_writer :fetcher

  def fetch(url)
    @fetcher && @fetcher.call(url) || open(url)
  end

  def initialize(source_data)
    @source_data = source_data
    @parsed = Nokogiri::HTML(@source_data, nil, 'utf-8')
    @parsed.encoding = 'utf-8'
  end

  protected
  def htmlify(string)
    string.strip.gsub(/\n+/, '<br/>')
  end
end
