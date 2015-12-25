class ApplicationMailer < ActionMailer::Base
  default from: "benjamin19890721@gmail.com"
  layout 'mailer'

  def send_mail(options = {})
    @options = options
    mail(to: 'benjamin19890721@gmail.com', subject: options[:subject])
  end


end
