class SuperfutureParser < BaseParser
  def items
    # remove pinned items
    parsed.css(".ipsBadge").each do |pinned|
      pinned.parent.parent.remove
    end

    parsed.css("a.topic_title").map do |link|
      url = link['href']
      details = BaseParser.new(fetch(url).read).parsed
      description = htmlify(details.css(".entry-content").text)
      price = description.match(/\$\s*\d+/)[0] rescue "[?]"

      {
        :title => htmlify(link.text),
        :url => url,
        :description => description.truncate(DESCRIPTION_SIZE),
        :images => details.css("img.bbc_img").map {|img| img["src"]},
        :price => price
      }
    end
  end
end
