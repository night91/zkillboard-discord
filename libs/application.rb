module ZkbDiscord
  class Application
    attr :id, :type, :webhook_url

    def initialize(application)
      @zkb_endpoint = Config.config['zkb_endpoint']

      @id = application['id']
      @type = application['type']
      @webhook_url = application['webhook_url']

      @processing = application['processing']
    end

    def match_kill_mail?(data)
      total_value = data['zkb']['totalValue']

      is_victim = victim_kill_mail?(data)
      is_attacker = attacker_kill_mail(data)

      case @processing['type']
      when 'victim'
        is_victim && total_value >= @processing['min_isk_lost']
      when 'attacker'
        is_attacker
      when 'all'
        is_victim || is_attacker
      end
    end

    def process_kill_mail(data)
      RestClient.post(@webhook_url, create_message(data).to_json, content_type: :json)
    end

    private

    def victim_kill_mail?(data)
      data['killmail']['victim']["#{@type}_id"] == @id
    end

    def attacker_kill_mail(data)
      return false unless %w[all attacker].include?(@processing)
      data['killmail']['attackers'].any? { |attacker| attacker["#{@type}_id"] == @id }
    end

    def create_message(data)
      { content: create_kill_mail_url(data['killID']) }
    end

    def create_kill_mail_url(kill_mail_id)
      "#{@zkb_endpoint}/kill/#{kill_mail_id}"
    end
  end
end