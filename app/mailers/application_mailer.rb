class ApplicationMailer < ActionMailer::Base

  default from: "benjamin19890721@gmail.com"
  layout 'mailer'

  EVERNOTE_EMAIL = 'benjamin19890721.64fd093@m.evernote.com'

  def send_youtube_digest_to_evernote(options = {})
    @youtube_vidoe = options[:youtube_vidoe]
    uri = URI(@youtube_vidoe.thumbnails.first['url'].gsub('https', 'http'))
    attachments['thumbnails'] = Net::HTTP.get(uri)
    mail(to: 'benjamin19890721+forward2evernote@gmail.com, benjamin19890721.64fd093@m.evernote.com', subject: "#{options[:subject]} @Youtube #Youtube")
  end

end
