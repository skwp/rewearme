require 'nokogiri'
require 'htmlentities'
require 'active_support/core_ext/string'

require_relative '../../app/parsers/base_parser'
require_relative '../../app/parsers/superfuture_parser'

dir = File.dirname(__FILE__)

module Rails; def self.logger; end; end; 

describe SuperfutureParser do
  before do
    Rails.stub_chain(:logger, :debug)
  end

  context "index page" do
    let(:parser) { SuperfutureParser.new(page) }
    let(:page) { File.read(File.join(dir, "fixtures/superfuture/index.html")) }

    before do
      parser.stub(:fetch) { File.open(File.join(dir, "fixtures/superfuture/detail.html")) }
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
