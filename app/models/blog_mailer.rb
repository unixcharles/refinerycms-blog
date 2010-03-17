class BlogMailer < ActionMailer::Base

  def notification(comment, request)
    subject     "New comment on #{comment.blog.title}"
    recipients  BlogSetting.notification_email
    from        "\"#{RefinerySetting[:site_name]}\" <no-reply@#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}>"
    sent_on     Time.now
    body        :comment => comment
  end

  def confirmation(comment, request)
    site_domain = request.domain(RefinerySetting.find_or_set(:tld_length, 1))
    subject       "#{RefinerySetting[:site_name]} - comment confirmation"
    recipients    comment.email
    from          "\"#{RefinerySetting[:site_name]}\" <no-reply@#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}>"
    sent_on       Time.now
    content_type  "text/html"
    body          :comment => comment,
                  :site_domain => request.domain(RefinerySetting.find_or_set(:tld_length, 1))
  end

end
