require './libs/application'

module ZkbDiscord
  class KillMailProcessor
    def initialize
      @applications = Config.config['applications']
    end

    def process_kill_mail(data)
      @applications.each do |application_name|
        puts application_name
        puts Config.config['application']
        puts Config.config['application'][application_name]
        application = Application.new(Config.config['application'][application_name])
        next unless application.match_kill_mail?(data)
        application.process_kill_mail(data)
      end
    end
  end
end