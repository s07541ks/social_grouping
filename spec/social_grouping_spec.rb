require 'spec_helper'

describe SocialGrouping do
  it 'version number' do
    expect(SocialGrouping::VERSION).to eq "1.0.3"
  end

#  it 'account' do
#    params = Hash.new
#    params[:oauth_token] = ENV['TW_AC_TOKEN']
#    params[:oauth_token_secret] = ENV['TW_AC_SECRET']
#    expect(SocialGrouping::Main.new('twitter', params).account()).to eq({"error"=>"", "account"=>"webgrp"})
#  end
  
  it 'mining' do
    data = ["siamcats", "J_frtk"]
    params = Hash.new
    params[:oauth_token] = ENV['TW_AC_TOKEN']
    params[:oauth_token_secret] = ENV['TW_AC_SECRET']
    expect(SocialGrouping::Main.new('twitter', params).mining("0", "4", data, "webgrp")).to eq({"error"=>"", "account"=>"webgrp"})    
  end
end
