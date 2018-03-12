require "social_grouping/client/twitter_client"
require "social_grouping/concern/accounts"
require "social_grouping/concern/narrowings"
require "social_grouping/concern/groupings"

module SocialGrouping
  class Twitters
    include ::SocialGrouping::Concern::Accounts
    include ::SocialGrouping::Concern::Narrowings
    include ::SocialGrouping::Concern::Groupings

    def initialize(oauth_token=nil, oauth_token_secret=nil)
      @client = ::SocialGrouping::Client::TwitterClient.new(oauth_token, oauth_token_secret)
    end
  end
end
