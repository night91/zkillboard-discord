module ZkbDiscord
  class Config
    CONFIG_FILES = %w[config application]
    APPLICATIONS_FILES= %w[corp goons pandemic-horde pandemic-legion test nero-corp]

    attr_reader :config

    def self.load_configs!
      @config = {}

      CONFIG_FILES.each do |file|
        @config.merge! YAML.load_file("./configs/#{file}.yml")
      end

      @config['application'] = {}
      APPLICATIONS_FILES.each do |file|
        @config['application'].merge! YAML.load_file("./configs/#{file}.yml")['application']
      end
    end

    def self.config
      @config
    end
  end
end