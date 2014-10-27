require 'spec_helper'

describe SaleItem do
  examples = [
    "FS: something",
    "FS something",
    "FS:something",
  ]

  examples.each do |ex|
    context "with #{ex}" do
      let(:item) { SaleItem.new(:title => ex) }

      it "strips FS from title" do
        item.save
        item.title.should == "something"
      end
    end
  end
end
