require "json"
require "sinatra"
require "sinatra/json"
require "sinatra/cross_origin"
require "nokogiri"
require "open-uri"

BASE_URL = "http://menu.mensen.at/index/index/locid/"

def menu_item(doc, menu)
  begin
    menu_item = doc.xpath("//*[@class = 'menu-item']//h2[contains(text(),'#{menu}')]").first
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
      :date => weekdays[index],
      :text => menu_on_day.content.gsub(/\s+/, " ").strip
    })
  end
  result
end

get '/:mensa_id' do
  cross_origin
  content_type :json

  doc = Nokogiri::HTML(open(BASE_URL + params[:mensa_id]))

  {
    :description => doc.css("#header").text.gsub(/\s+/, " ").strip,
    :classic_1 => menu_entries(doc, "Classic 1"),
    :classic_2 => menu_entries(doc, "Classic 2"),
    :choice => menu_item(doc, "Choice")
  }.to_json
end