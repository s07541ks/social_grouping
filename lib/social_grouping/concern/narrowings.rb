module SocialGrouping
  module Concern
    module Narrowings
      # @params [String] key_name 分析対象となるアカウント名
      def narrowing(key_name, limit=nil)
        @client.friends_narrow(key_name, limit)
      end
    end
  end
end
