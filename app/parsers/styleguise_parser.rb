class StyleguiseParser < BaseParser
  def items
    JSON.parse(source_data).map do |item|
      item = item.with_indifferent_access
      {
        title: "#{item[:brand]} #{item[:name]}",
        description: htmlify(item[:description]).truncate(200),
        url: item[:url],
        price: "#{item[:price]} + #{item[:currency]}",
        images: item[:photoUrls],
        category: item[:category],
        brand: item[:brand]
      }
    end
  end
end
