require_relative 'kill_mail_processor'
module ZkbDiscord
  class KillMailsPuller
    def initialize
      @processor = KillMailProcessor.new
      @endpoint = Config.config['endpoint']
    end

    def pull
      data = pull_data
      return false unless new_kill_mail?(data)

      @processor.process_kill_mail(data)

      true
    end

    private

    def pull_data
      JSON.parse(RestClient.get(@endpoint))['package']
    end

    def new_kill_mail?(data)
      data != nil
    end
  end
end