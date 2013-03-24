# -*- encoding : utf-8 -*-
require "./marilyn_mensen"
require "nokogiri"
require "open-uri"

describe MarilynMensen, "#parse" do
  it "parses the specified document" do
    doc = Nokogiri::HTML(open("spec/mock_1.html"))
    marilyn_mensen = MarilynMensen.new

    result = marilyn_mensen.parse doc
    result["description"].should == "JKU Linz Mensa Markt"

    result["Menü Classic 1"].length.should == 5
    result["Menü Classic 1"][0]["date"].should == "Mo, 25.03."
    result["Menü Classic 1"][0]["text"].should == "Classic #1 geschlossen!"
    result["Menü Classic 1"][3]["date"].should == "Do, 28.03."
    result["Menü Classic 1"][3]["text"].should == "Knoblauchrahmsuppe Cremespinat mit Rührei und Erdäpfelschmarrn"

    result["Menü Classic 2"].length.should == 5
    result["Menü Classic 2"][0]["date"].should == "Mo, 25.03."
    result["Menü Classic 2"][0]["text"].should == "Kohlrabicremesuppe mit Erbsen Marokkanisches Rindsragout mit gedörrten Pfirsichen, Vollkornspirelli und Salat"

    result["Choice"].length.should == 20
  end

  it "returns nil when the passed document is nil" do
    marilyn_mensen = MarilynMensen.new

    result = marilyn_mensen.parse nil
    result.should be_nil
  end
end
