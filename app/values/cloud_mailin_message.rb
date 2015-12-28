class CloudMailinMessage

  attr_accessor :subject, :sender, :recipient, :plain_body

  def initialize(options = {})
    subject    = options[:subject]
    sender     = options[:sender]
    recipient  = options[:recipient]
    plain_body = options[:plain_body]
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
