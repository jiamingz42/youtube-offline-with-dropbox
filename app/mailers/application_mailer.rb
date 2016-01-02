class ApplicationMailer < ActionMailer::Base

  default from: "benjamin19890721@gmail.com"
  layout 'mailer'

  EVERNOTE_EMAIL = 'benjamin19890721.64fd093@m.evernote.com'

  def send_youtube_digest_to_evernote(options = {})
    @youtube_vidoe = options[:youtube_vidoe]
    mail(to: 'benjamin19890721.64fd093@m.evernote.com', subject: "#{@youtube_vidoe.title} @Youtube #Youtube")
  end

end
