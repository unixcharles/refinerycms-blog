class BlogSetting < ActiveRecord::Base
  
  # spam related options
  def self.enable_captcha
    find_or_create_by_name("Enable Captcha").value
  end
  
  def self.manual_moderation
    find_or_create_by_name("Manual Moderation").value
  end

  # Tags & tag relations
  def self.enable_categories 
    find_or_create_by_name("Enable Categories").value
  end
  
  def self.enable_tags
    find_or_create_by_name("Enable Tags").value
  end
  
  def self.enable_authors
    find_or_create_by_name("Enable Authors").value
  end
  
  def self.enable_recent_blogs
    find_or_create_by_name("Enable Recent Blog").value
  end
  
  def self.enable_related_categories 
    find_or_create_by_name("Enable Related Categories").value
  end
  
  def self.enable_related_tags
    find_or_create_by_name("Enable Related Tags").value
  end
  
  def self.enable_related_authors
    find_or_create_by_name("Enable Related Authors").value
  end
  
  # email notification
  
  def self.enable_email_notification 
    find_or_create_by_name("Enable email notification").value
  end

  def self.notification_email
    find_or_create_by_name("Notification email").entry
  end
  
  def self.enable_approve_comment_by_email
    find_or_create_by_name("Enable Approve Comment by email").value    
  end
end
