require 'spec_helper'
require 'capistrano/push'

module Capistrano

  describe Push do
    let(:pusher) { Push.new(pusher_url, pusher_channel) }
    let(:pusher_url) { 'http://abc:123@api.pusherapp.com/apps/0' }
    let(:pusher_channel) { 'capistrano' }

    describe '.new' do
      it 'takes a url and a channel' do
        expect(pusher)
      end
    end

    describe '#trigger' do
      let(:channel) { instance_double('Pusher::Channel') }
      let(:pusher_payload) { double }
      let(:pusher_state) { double }

      it 'delegates to Pusher' do
        expect(Pusher).to receive(:[]).with(pusher_channel).and_return(channel)
        expect(channel).to receive(:trigger).with(pusher_state, pusher_payload)

        pusher.trigger(pusher_state, pusher_payload)
      end
    end

  end
end
