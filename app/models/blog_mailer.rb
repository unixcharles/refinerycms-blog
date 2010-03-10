class BlogMailer < ActionMailer::Base

  def notification(comment, request)
    subject     "New comment on #{comment.blog.title}"
    recipients  BlogSetting.notification_email
    from        "\"#{RefinerySetting[:site_name]}\" <no-reply@#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}>"
    sent_on     Time.now
    body        "New comment on #{comment.blog.title} blog post.
                 Comment author: #{comment.name}
                 Comment title: #{comment.title}
                 Comment Body: #{comment.body}"
  end
  
  def confirmation(comment, request)
    subject       "#{RefinerySetting[:site_name]} - comment confirmation"
    recipients    comment.email
    from          "\"#{RefinerySetting[:site_name]}\" <no-reply@#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}>"
    sent_on       Time.now
    content_type  "text/html"
    body          "<html>
                   <body>
                   <p>You send a comment '#{comment.blog.title}' blog post at #{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}.
                   <p>Comment author: #{comment.name}</p>
                   <p>Comment title: #{comment.title}</p>
                   <p>Comment Body: #{comment.body}</p>
                   <hr/>
                   <p>You're comment is currently not displayed to public, you need to confirm it first by clicking on the following link:</p>
                   <p><a href='http://#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}/blog/authorize/#{comment.token}'>http://#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}/blog/authorize/#{comment.token}</a></p>
                   <p><i>if can't click on the link, manually copy & paste this URL into a web browser</i></p>
                   </body>
                   </html>"
  end

end
