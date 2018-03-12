require 'spec_helper'

describe SocialGrouping do
  let(:target_class) { ::SocialGrouping::Twitters.new }
  let(:account) { target_class.account }
  let(:account_name) { 'dummy' }
  
  context 'twitter' do
    let!(:rest_client) do
      allow_any_instance_of(::Twitter::REST::Client).to receive(:verify_credentials).and_return(verify_credentials)
      allow_any_instance_of(::Twitter::REST::Client).to receive(:friends).and_return(friend)
      values = [followers1, followers2]
      allow_any_instance_of(::Twitter::REST::Client).to receive(:followers){ values.shift }
    end
    let(:verify_credentials) do
      mock = double('verify_credentials')
      allow(mock).to receive(:screen_name).and_return(account_name)
      mock
    end
    let(:friend) do
      mock = double('friend')
      allow(mock).to receive(:attrs).and_return({
        next_cursor: 0,
        users: [{
          id: 0,
          protected: false,
          verified: false,
          screen_name: 'dummy',
          followers_count: 100,
          friends_count: 100
        }]
      })
      mock
    end
    let(:followers1) do
      mock = double('friend')
      allow(mock).to receive(:attrs).and_return({
        next_cursor: 0,
        users: [
          {
            id: 1,
            protected: false,
            verified: false,
            screen_name: 'dummy1',
            followers_count: 100,
            friends_count: 100
          },
          {
            id: 2,
            protected: false,
            verified: false,
            screen_name: 'dummy2',
            followers_count: 100,
            friends_count: 100
          },
          {
            id: 3,
            protected: false,
            verified: false,
            screen_name: 'dummy3',
            followers_count: 100,
            friends_count: 100
          }        ]
      })
      mock
    end
    let(:followers2) do
      mock = double('friend')
      allow(mock).to receive(:attrs).and_return({
        next_cursor: 0,
        users: [
          {
            id: 1,
            protected: false,
            verified: false,
            screen_name: 'dummy1',
            followers_count: 100,
            friends_count: 100
          },
          {
            id: 2,
            protected: false,
            verified: false,
            screen_name: 'dummy2',
            followers_count: 100,
            friends_count: 100
          }
         ]
      })
      mock
    end
    context 'account' do
      it "account" do
        expect(account).to eq(account_name)
      end
    end
    context 'narrowing' do
      it "narrowing" do
        expect(target_class.narrowing(account).size).to eq(1)
      end
    end
    context 'grouping' do
      it "grouping" do
        expect(target_class.grouping(account, target_class.narrowing(account)).size).to eq(1)
      end
    end
  end
end
