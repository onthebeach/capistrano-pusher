require 'pusher'
module Capistrano
  class Push

    def initialize(url, channel)
      @url, @channel = url, channel
    end

    def trigger(state, payload)
      Pusher.url = @url
      Pusher[@channel].trigger(state, payload)
    end

  end
end
