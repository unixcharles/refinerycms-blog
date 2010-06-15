class BlogMailer < ActionMailer::Base

  def notification(comment, request)
    subject     "New comment on #{comment.blog.title}"
    recipients  BlogSetting.notification_email
    from        from_address(request)
    sent_on     Time.now
    body        :comment => comment
  end

  def confirmation(comment, request)
    subject       "#{site_name} - comment confirmation"
    recipients    comment.email
    from          from_address(request)
    sent_on       Time.now
    content_type  "text/html"
    body          :comment => comment,
                  :site_domain => site_domain(request)
  end
  
 protected
 
  def from_address(request)
    "\"#{site_name}\" <no-reply@#{site_domain(request)}>"
  end
  
  def site_domain(request)
    @domain ||= request.domain(RefinerySetting.find_or_set(:tld_length, 1))
  end
 
  def site_name
    RefinerySetting[:site_name]
  end

end
