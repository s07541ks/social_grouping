require 'active_support'
require 'active_support/core_ext'

require "social_grouping/version"
require "social_grouping/test_user"
require "social_grouping/twitter_client"
require "social_grouping/yahoo_client"

module SocialGrouping
  
  class Main

    def initialize( social, params )
      if social == 'twitter'
        @client = TwitterClient.new( params )
      end
    end

    def init()
      result = Hash.new
      result['error'] = ''
      return result
    end

    def account()
      result = init()
      begin
        result['account'] = @client.get_account()
      rescue StandardError => e
        result['error'] = e.message
      end
      return result
    end

    def narrowing( key_name )
      result = init()
      begin
        narrow = Hash.new
        narrow['target'] = @client.get_target( key_name )
        unless narrow['target'].blank?
          narrow['friends'] = @client.get_friends_narrow( key_name )
          result['success'] = narrow
        else
          result['error'] = 'please retry'
        end
      rescue StandardError => e
        result['error'] = e.message
      end
      return result
    end

    def grouping( json, groups )
      result = init()
      tmp_grouplist = Array.new
      begin
        target_id = json['target']['id'].to_i
        target_friends = @client.get_friends( target_id )
        json['friends'].each do | i, user |
          user_id = user['id'].to_i
          unless is_include( tmp_grouplist, user_id )
            fws = @client.get_friends( user_id )
            group = Hash.new
            group[user_id] = user['name']
            group = group.merge( webgrouping( target_friends, fws ) )
            if group.count > 2
              tmp_grouplist = push_group( tmp_grouplist, group )
            end
          end
        end
      rescue StandardError => e
        result['error'] = e.message
      end
      if !groups.blank?
        groups.each do | key, value |
          group = Hash.new
          value.each do | id, user |
            group[id.to_i] = user
          end
          tmp_grouplist = push_group( tmp_grouplist, group )
        end
      end
      result['success'] = tmp_grouplist
      return result
    end

    def mining( count, max, data, name )
      result = init()
      begin
        mining = Hash.new
        mining['count'] = count
        mining['max'] = max
        data.push( name )
        profiles = @client.get_profiles( data )
        nhash = Hash.new
        profiles.each do | profile |
          nhash = YahooClient.new.get_noun( profile, nhash )
        end

        nhash.each do | key, val |
          nhash.each do | key2, val2 |
            if key != key2 && key.include?(key2)
              nhash[key] += val2 
            end
          end
        end

        nhash = nhash.sort{ |a,b|  (b[1]==a[1]) ? b[0].to_s.length<=>a[0].to_s.length : b[1]<=>a[1] }

        tmp_result = Hash.new
        group_name = ''
        nhash.each do | key, value |
          if tmp_result.length > 2 || value < 2
            break
          end
          tmp_result[key] = value
          group_name += key + ' '
        end
        if group_name.blank?
          group_name = 'None'
        end
        mining['name'] = group_name
        mining['values'] = tmp_result
        result['success'] = mining
      rescue StandardError => e
        result['error'] = e.message
      end
      return result
    end

    def addlist( key_id, name, data )
      result = init()
      begin
        list_id = @client.create_list( name )
        @client.add_list_members( list_id, data )
        result['success'] = key_id
      rescue StandardError => e
        result['error'] = e.message
      end
      return result    
    end
    
    def corpusing( word )
      data = @client.get_search( word )
      count = YahooClient.new.get_count( data )
      result = Hash.new
      count.each do | key, value |
        result[key] = value.to_f / data.length
      end
      return result
    end
    
    def probing( users )
      data = @client.get_timeline( users, 1 )
      count = YahooClient.new.get_count( data )
      return count
    end

    private
    def json_to_friends( json )
      friends = Array.new
      json.each do | key, user |
        friends.push( TestUser.new( user['id'], user['name'] ) )
      end
      return friends
    end

    def json_to_group( json )
      friends = Hash.new
      json.each do | user |
        friends[user[0].to_i] = user[1]
      end
      return friends
    end

    def is_include( grouplist, id )
      grouplist.each do | group |
        if group.key?( id )
          return true
        end
      end
      return false
    end

    def webgrouping( user, follower )
      tmp = Hash.new
      user.each do | fw |
        tmp[fw.id.to_i] = fw.name
      end
      grp = Hash.new
      follower.each do | fw |
        if tmp.key?( fw.id.to_i )
          grp[fw.id.to_i] = tmp[fw.id.to_i]
        end
      end
      return grp
    end

    def push_group( grouplist, group )
      result = Array.new
      is_push = true
      grouplist.each do | grp |
        cnt = 0
        group.each do | id, val |
          if grp.key?( id.to_i )
            cnt += 1          
          end
        end
        if is_match_group( group, grp, cnt )
          grp = grp.merge( group )
          is_push = false
        end
        result.push( grp )
      end
      if is_push
        result.push( group )
      end
      return result
    end

    def is_match_group( grp1, grp2, cnt )
      if grp1.count > grp2.count
        num = grp2.count
      else
        num = grp1.count
      end
      if num * 0.6 < cnt
        return true
      end
      return false
    end

  end

end
