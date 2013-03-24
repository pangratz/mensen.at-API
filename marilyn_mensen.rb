# -*- encoding : utf-8 -*-
require "nokogiri"

class MarilynMensen

  def parse(doc)
    {
      "description" => doc.css("#header span span").first.text.gsub(/\s+/, " ").strip,
      "Menü Classic 1" => menu_entries(doc, "Menü Classic 1"),
      "Menü Classic 2" => menu_entries(doc, "Menü Classic 2"),
      "Choice" => menu_item(doc, "Choice")
    } unless doc == nil
  end

  private

  def menu_item(doc, menu)
    begin
      menu_item = doc.xpath("//*[@class = 'menu-item']//h2[text() = '#{menu}']").first
      menu_item.parent.text.split("\n").map(&:strip).reject!(&:empty?)
    rescue
      nil
    end
  end

  def menu_entries(doc, menu)
    result = []

    weekdays = []
    week = doc.css("#week ul li").each do |weekday|
      day = weekday.css(".day").text
      date = weekday.text.gsub(day, "")
      weekdays.push "#{day}, #{date}"
    end

    menu = doc.xpath("//*[@class = 'menu-item']//h2[contains(text(),'#{menu}')]").first.parent
    menu.css(".menu-item-text").each_with_index do |menu_on_day, index|
      result.push({
        "date" => weekdays[index],
        "text" => menu_on_day.content.gsub(/\s+/, " ").strip
      })
    end

    result
  end

end
