require 'twitter'
module SocialGrouping
  module Client
    class TwitterClient
      def initialize(oauth_token, oauth_token_secret)
        @client = ::Twitter::REST::Client.new do |config|
          if !oauth_token || !oauth_token_secret
            oauth_token = ENV['TW_AC_TOKEN']
            oauth_token_secret = ENV['TW_AC_SECRET']
          end
          config.consumer_key = ENV['TW_API_KEY']
          config.consumer_secret = ENV['TW_API_SECRET']
          config.access_token = oauth_token
          config.access_token_secret = oauth_token_secret
        end
      end

      def account
        @client.verify_credentials.screen_name
      end

      def friends_narrow(key_name, limit=nil)
        limit ||= 15
        cursor = -1
        limit.times.map do |_|
          next if cursor.zero?
          friends = @client.friends(key_name, {count: 200, cursor: cursor})
          cursor = friends.attrs[:next_cursor].to_i
          friends.attrs[:users].map do |user|
            next if user[:protected] || user[:verified]
            next if user[:screen_name].include?('_bot') || user[:screen_name].include?('_PR')
            next if 500 < user[:followers_count].to_i || user[:friends_count].to_i < 30 || 300 < user[:friends_count].to_i
            build_client_user(user[:id], user[:screen_name])
          end
        end.flatten.compact.shuffle.take(limit)
      end

      def friends( key_name )
        followers = @client.followers(key_name, {count: 200})
        followers.attrs[:users].map do |user|
          next if user[:verified]
          next if user[:screen_name].include?('_bot') || user[:screen_name].include?('_PR')
          next if 1000 < user[:followers_count].to_i || 1000 < user[:friends_count].to_i
          build_client_user(user[:id], user[:screen_name])
        end.compact
      end
      
      private
      
      def build_client_user(id, name)
        {id: id, name: name}
      end
    end
  end
end
