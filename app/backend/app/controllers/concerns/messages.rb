module Messages
  extend ActiveSupport::Concern

  included do
    def messages(message_symbol, options = {})
      defaults = { key: :message, model: :data}
      Messages.send(message_symbol, defaults.merge(options))
    end
  end

  def self.destroyed(options)
    { options[:key] => "Deleted #{options[:model]} successfully" }
  end

  def self.destroy_failed(options)
    { options[:key] => "Failed to delete #{options[:model]}" }
  end
end
