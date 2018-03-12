module SocialGrouping
  module Concern
    module Groupings
      def grouping(target_id, narrow_friends, groups=nil)
        groups ||= []
        target_friends = @client.friends(target_id)
        narrow_friends.each do |friend|
          friend_fws = @client.friends(friend['id'].to_i)
          target_group = friend_fws & target_friends
          push_flg = false
          groups.each do |group|
            next unless match?(group, target_group)
            group += target_group
            group.uniq!
            push_flg = true
          end
          groups << target_group unless push_flg
        end
        groups
      end

      private

      def match?(group1, group2, ratio=0.6)
        all_num = (group1 < group2 ? group2 : group1).size
        match_num = (group1 & group2).size
        (all_num * ratio) < match_num
      end
    end
  end
end