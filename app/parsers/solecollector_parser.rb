class SolecollectorParser < BaseParser

  def items
    parsed.css(".mp-title a,.mp-sma-title a").map do |item|

      url = item_url(item['href'])
      details = BaseParser.new(fetch(url).read)
      description = details.parsed.css(".mp-wrap").last.text
      price = details.parsed.css(".mp-s-right").detect{ |field| field.text =~ /\$/}.text
      images = details.parsed.css("#call-change img").map {|img| item_url(img['src'])}

      {
        :title => htmlify(item.text).titleize,
        :url => url,
        :description => htmlify(description.truncate(DESCRIPTION_SIZE)),
        :price => price,
        :images => images
      }
    end
  end

  def item_url(item)
    URI.join("http://solecollector.com/", item).to_s
  end

end
