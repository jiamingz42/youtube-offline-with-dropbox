class ApplicationMailer < ActionMailer::Base
  default from: "benjamin19890721@gmail.com"
  layout 'mailer'

  def send_mail(options = {})
    @youtube_url = options[:youtube_long_url]
    mail(to: 'drops@ukeeper.com', subject: "#{options[:subject]} #Youtube")
  end

end
