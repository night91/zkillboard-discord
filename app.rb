require 'sinatra'

require 'yaml'
require 'rest-client'
require 'json'
require './libs/config'
require './libs/kill_mails_puller'

module ZkbDiscord
  class App
    def self.start
      Config.load_configs!

      @puller = KillMailsPuller.new

      while true
        next if @puller.pull
        sleep 10
      end
    end
  end
end