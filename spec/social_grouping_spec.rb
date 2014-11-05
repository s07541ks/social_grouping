require 'spec_helper'

describe SocialGrouping do
  it 'version number' do
    expect(SocialGrouping::VERSION).to eq "1.0.7"
  end

#  it 'account' do
#    params = Hash.new
#    params[:oauth_token] = ENV['TW_AC_TOKEN']
#    params[:oauth_token_secret] = ENV['TW_AC_SECRET']
#    expect(SocialGrouping::Main.new('twitter', params).account()).to eq({"error"=>"", "account"=>"webgrp"})
#  end
  
  it 'grouping' do
    json = {"data"=>{"target"=>{"id"=>"113221667", "name"=>"jaredacurtis"}, 
        "friends"=>{
          "0"=>{"id"=>"250969887", "name"=>"4lilcutiepies"}, "1"=>{"id"=>"519930935", "name"=>"MannyDontTweat"}, 
          "2"=>{"id"=>"41685248", "name"=>"nickpfeiffer"}, "3"=>{"id"=>"28542356", "name"=>"marcelmeth"}, 
          "4"=>{"id"=>"265528247", "name"=>"levigritton"}, "5"=>{"id"=>"14462956", "name"=>"slylenser"}, 
          "6"=>{"id"=>"83674018", "name"=>"thrufatherseyes"}, "7"=>{"id"=>"493616101", "name"=>"ThisIsDocDrea"}, 
          "8"=>{"id"=>"102285656", "name"=>"muechin55"}, "9"=>{"id"=>"1633744945", "name"=>"AmyVonachen1"}, 
          "10"=>{"id"=>"14315641", "name"=>"brianjdenicola"}, "11"=>{"id"=>"558168469", "name"=>"CodiEliana"}, 
          "12"=>{"id"=>"154542116", "name"=>"ccoobs"}, "13"=>{"id"=>"374747141", "name"=>"MeganRecruitsIT"}, 
          "14"=>{"id"=>"38007808", "name"=>"sdltalent"}, "15"=>{"id"=>"29496795", "name"=>"swadebaker"}, 
          "16"=>{"id"=>"55395050", "name"=>"MAUREMONTEREY"}, "17"=>{"id"=>"21733230", "name"=>"peterhallen"}, 
          "18"=>{"id"=>"22967574", "name"=>"IRowley"}, "19"=>{"id"=>"2599938840", "name"=>"BridgetHinchman"}, 
          "20"=>{"id"=>"65044084", "name"=>"solomonarnold"}, "21"=>{"id"=>"1240841", "name"=>"koolio"}, 
          "22"=>{"id"=>"14379230", "name"=>"SDStorey"}, "23"=>{"id"=>"2591945112", "name"=>"meaggmoore"}, 
          "24"=>{"id"=>"123331832", "name"=>"Vangent_Inc"}, "25"=>{"id"=>"2513363036", "name"=>"Cort_Norman"}, 
          "26"=>{"id"=>"119526430", "name"=>"pkraper"}, "27"=>{"id"=>"16041028", "name"=>"TheMattPool"}, 
          "28"=>{"id"=>"29214623", "name"=>"JeriLK"}, "29"=>{"id"=>"20573876", "name"=>"adamberlin"}, 
          "30"=>{"id"=>"156729273", "name"=>"jmelloy72"}, "31"=>{"id"=>"172985746", "name"=>"jpwickl"}, 
          "32"=>{"id"=>"19935080", "name"=>"juswil95"}, "33"=>{"id"=>"1403699113", "name"=>"jan5347"}, 
          "34"=>{"id"=>"241325108", "name"=>"PaulMcManusLB"}, "35"=>{"id"=>"861869419", "name"=>"twardphoto"}, 
          "36"=>{"id"=>"201925351", "name"=>"atka1971"}, "37"=>{"id"=>"2709638929", "name"=>"syntaxdrknessJB"}, 
          "38"=>{"id"=>"75366547", "name"=>"RustyZimmerman"}, "39"=>{"id"=>"50051879", "name"=>"DrexFitz"}, 
          "40"=>{"id"=>"247449412", "name"=>"DYakish"}, "41"=>{"id"=>"234470268", "name"=>"InnovateUrBiz"}, 
          "42"=>{"id"=>"2581227411", "name"=>"TOCbanquets"}, "43"=>{"id"=>"398185209", "name"=>"TriciaC3"},
          "44"=>{"id"=>"17448716", "name"=>"eileencrivera"}, "45"=>{"id"=>"121637687", "name"=>"potomacpen"}, 
          "46"=>{"id"=>"1505300755", "name"=>"ChrisWhitenack"}, "47"=>{"id"=>"2726765317", "name"=>"SethWear"}, 
          "48"=>{"id"=>"2605444453", "name"=>"CScherrman"}, "49"=>{"id"=>"863647922", "name"=>"hanson_zoe"}, 
          "50"=>{"id"=>"881265674", "name"=>"arturnerus1"}}}, 
      "key_name"=>"jaredacurtis", "oauth_token"=>"", "oauth_token_secret"=>""}
    params = Hash.new
    params[:oauth_token] = ENV['TW_AC_TOKEN']
    params[:oauth_token_secret] = ENV['TW_AC_SECRET']
    expect(SocialGrouping::Main.new('twitter', params).grouping( json.to_json, Array.new )).to eq({"error"=>"", "account"=>"webgrp"})        
  end
  
  
#  it 'mining' do
#    data = ["siamcats", "jaredacurtis"]
#    params = Hash.new
#    params[:oauth_token] = ENV['TW_AC_TOKEN']
#    params[:oauth_token_secret] = ENV['TW_AC_SECRET']
#    expect(SocialGrouping::Main.new('twitter', params).mining("0", "4", data, "webgrp")).to eq({"error"=>"", "account"=>"webgrp"})    
#  end

end
