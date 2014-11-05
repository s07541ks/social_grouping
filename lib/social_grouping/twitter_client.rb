require 'twitter'

class TwitterClient
  attr_accessor :client

  @@client

  def initialize( session )
    @@client = Twitter::REST::Client.new do |config|
      
      if session[:oauth_token].blank?
        session[:oauth_token] = ENV['TW_AC_TOKEN']
        session[:oauth_token_secret] = ENV['TW_AC_SECRET']
      end
      
      config.consumer_key        = ENV['TW_API_KEY']
      config.consumer_secret     = ENV['TW_API_SECRET']
      config.access_token        = session[:oauth_token]
      config.access_token_secret = session[:oauth_token_secret]
    end
  end

  def get_account
    target = nil
    begin
      target = @@client.verify_credentials.screen_name
    rescue Twitter::Error::TooManyRequests => e
      limit = e.rate_limit
      raise StandardError, 'wait until ' + limit.reset_at.to_s
    end
    return target
  end

  def get_target( key_name )
    user = nil
    target = nil
    begin
      target = @@client.user( key_name )
    rescue Twitter::Error::TooManyRequests => e
      limit = e.rate_limit
      raise StandardError, 'wait until ' + limit.reset_at.to_s
    end
    unless target.blank?
      user = TestUser.new( target.id, target.screen_name )        
    end
    return user
  end

  def get_friends_narrow( key_name )
    begin
      tmp_friends = Array.new
      cursor = -1
      count = 1
      while cursor != 0 do
        if count > 15
          break
        end
        count += 1
        tmp = @@client.friends( key_name, { :count => 200, :cursor => cursor } )
        cursor = tmp.attrs[:next_cursor].to_i
        tmp.attrs[:users].each do | fw |
          if fw[:protected] == false && fw[:verified] == false
            if !fw[:screen_name].include?('_bot') && !fw[:screen_name].include?('_PR')
              if fw[:followers_count].to_i < 500 && fw[:friends_count].to_i > 30 && fw[:friends_count].to_i < 300 
                user = TestUser.new( fw[:id], fw[:screen_name] )
                tmp_friends.push( user )
              end
            end
          end
        end
      end
      tmp_friends.shuffle!
      friends = Array.new
      tmp_friends.each do | user |
        if friends.length > 50
          break
        end
        friends.push( user )
      end
    rescue Twitter::Error::TooManyRequests => e
      limit = e.rate_limit
      raise StandardError, 'wait until ' + limit.reset_at.to_s
    end
    return friends
  end

  def get_friends( key_name )
    begin
      tmp = @@client.followers( key_name, { :count => 200 } )
      friends = Array.new
      tmp.attrs[:users].each do | fw |
        if fw[:verified] == false
          if !fw[:screen_name].include?('_bot') && !fw[:screen_name].include?('_PR')
            if fw[:followers_count].to_i < 1000 && fw[:friends_count].to_i < 1000
              user = TestUser.new( fw[:id], fw[:screen_name] )
              friends.push( user )
            end
          end
        end
      end
    rescue Twitter::Error::TooManyRequests => e
      limit = e.rate_limit
      raise StandardError, 'wait until ' + limit.reset_at.to_s
    end
    return friends      
  end
    
  def get_profiles( keys )
    profiles = Array.new
    target = nil
    begin
      target = @@client.users( keys )
    rescue Twitter::Error::TooManyRequests => e
      limit = e.rate_limit
      raise StandardError, 'wait until ' + limit.reset_at.to_s
    end
    unless target.blank?
      target.each do | profile |
        values = Hash.new
        values['lang'] = profile.lang
        values['profile'] = profile.description.to_s.encode('utf-8') + " "
        profiles.push( values )          
      end
    end
    return profiles
  end
  
  def create_list( name, mode = "private")
    list_id = nil
    target = nil
    begin
      target = @@client.create_list( name, { :mode => mode } )
    rescue Twitter::Error::TooManyRequests => e
      limit = e.rate_limit
      raise StandardError, 'wait until ' + limit.reset_at.to_s
    end
    unless target.blank?
      list_id = target.id
    end
    return list_id
  end
  
  def add_list_members( id, members )
    begin
      @@client.add_list_members( id, members )
    rescue Twitter::Error::TooManyRequests => e
      limit = e.rate_limit
      raise StandardError, 'wait until ' + limit.reset_at.to_s
    end
  end
end
