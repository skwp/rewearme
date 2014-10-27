require 'nokogiri'
require 'htmlentities'
require 'active_support/core_ext/string'
require 'active_support/core_ext/hash'
require 'json'

require_relative '../../app/parsers/base_parser'
require_relative '../../app/parsers/styleguise_parser'


dir = File.dirname(__FILE__)

module Rails; def self.logger; end; end; 

describe StyleguiseParser do
  before do
    Rails.stub_chain(:logger, :debug)
  end

  context "index page" do
    let(:parser) { StyleguiseParser.new(page) }
    let(:page) { File.read(File.join(dir, "fixtures/styleguise/index.html")) }

    it "returns a list of items for sale" do
      parser.items.should be
      parser.items.first[:title].should be
      parser.items.first[:url].should be
      parser.items.first[:description].should be
      parser.items.first[:price].should be
      parser.items.first[:images].should be
      parser.items.first[:category].should be
      parser.items.first[:brand].should be
    end
  end
end
