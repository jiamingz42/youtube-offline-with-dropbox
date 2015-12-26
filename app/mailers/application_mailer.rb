class ApplicationMailer < ActionMailer::Base

  default from: "benjamin19890721@gmail.com"
  layout 'mailer'

  EVERNOTE_EMAIL = 'benjamin19890721.64fd093@m.evernote.com'

  def send_youtube_digest_to_evernote(options = {})
    @youtube_vidoe = options[:youtube_vidoe]
    attachments['thumbnails'] = File.read(Rails.root.join("app/assets/images/panda.jpg"))
    mail(to: EVERNOTE_EMAIL, subject: "#{options[:subject]} @Youtube #Youtube")
  end

end
