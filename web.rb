# -*- encoding : utf-8 -*-
require "json"
require "sinatra"
require "sinatra/json"
require "sinatra/cross_origin"
require "nokogiri"
require "open-uri"
require "./marilyn_mensen"

BASE_URL = "http://menu.mensen.at/index/index/locid/"

get '/:mensa_id' do
  cross_origin
  content_type :json

  doc = Nokogiri::HTML(open(BASE_URL + params[:mensa_id]))
  result = MarilynMensen.new.parse doc

  result.to_json
end
