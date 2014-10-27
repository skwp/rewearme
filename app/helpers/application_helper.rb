module ApplicationHelper
  def country_flag(code)
    image_tag("famfamfam_flag_icons/#{code}.png")
  end

  def currency_symbol
    case params[:currency]
    when /gbp/i
      "&#163;"
    else
      "$"
    end
  end
end
