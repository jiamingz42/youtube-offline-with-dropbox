class CloudMailinMessage

  attr_accessor :subject, :sender, :recipient, :plain_body

  def initialize(options = {})
    [:subject, :sender, :recipient, :plain_body].each do |attr_name|
      self.send("#{attr_name}=", options[attr_name])
    end
  end

  [:subject, :sender, :recipient, :plain_body].each do |attr_name|
    define_method("#{attr_name}_match?") do |pattern|
      self.send(attr_name).match(pattern).present?
    end
  end

  class << self
    def create_from_params(params = {})
      headers = params['headers']||{}
      subject = headers['Subject']
      sender = headers['From']
      recipient = headers['To']
      plain_body = params['plain']
      new({
        :subject    => subject,
        :sender     => sender,
        :recipient  => recipient,
        :plain_body => plain_body
      })
    end
  end
end
