class StyleforumParser < BaseParser
  def items
    @items ||= item_rows.map do |row|
      columns = row.css("td")

      images = BaseParser.new(fetch(item_url(columns)).read).parsed.css("div.post-content-area a.thumb").map {|img| img['data-original']}

      {:title => title(columns),
       :url => item_url(columns),
       :description => description(columns),
       :price => price(columns),
       :images => images}
    end
  end

  private

  def item_rows
    @item_rows ||= parsed.css("table.forum-list-tbl tr")
  end

  def price(columns)
    columns[2].css(".price").text
  end

  def description(columns)
    htmlify(columns[1].css("div.forum-list-sub-txt").text)
  end

  def title(columns)
    htmlify(columns[1].css("a.classified-title").text)
  end

  def item_url(columns)
    "http://styleforum.net/" + columns[1].css("a.thumb").first['href']
  end

end
