class CreateBlogs < ActiveRecord::Migration

  def self.up
    create_table :blogs do |t|
      t.string :title
      t.string :permalink, :nil => false
      t.text :excerpt
      t.text :body
      t.boolean :draft, :default => false
      t.boolean :allow_comment, :default => true
      t.datetime :publishing_date
      t.integer :position
      
      t.timestamps
    end

    add_index :blogs, :id
    add_index :blogs, :permalink

    User.find(:all).each do |user|
      user.plugins.create(:title => "Blog", :position => (user.plugins.maximum(:position) || -1) +1)
    end

    create_table :comments do |t|
      t.string :title
      t.text :body
      t.boolean :approved
      t.string :name
      t.string :email
      t.string :token

      t.integer :blog_id

      t.timestamps
    end

    add_index :comments, :blog_id

    create_table :blog_settings do |t|
      t.string   :name
      t.boolean  :value
      t.string   :entry
      t.string   :description
      t.datetime :created_at
      t.datetime :updated_at
    end

    manual_moderation = BlogSetting.create(:name => "Manual Moderation", :value => false, :description => "Set this setting to true to review manually approve comments before they appear on the blog post or confirmed by the poster with email confirmation when Approve by comment is enabled. This setting need to be enabled if you use email confirmation.")
    enable_approve_comment_by_email = BlogSetting.create(:name => "Enable Approve Comment by email", :value => false, :description => "Set this setting to true to enable comment confirmation by email, commenter will recieve an email with a confirmation link.")
    enable_captcha = BlogSetting.create(:name => "Enable Captcha", :value => false, :description => "Set this setting to true to protect your commect with Captcha question.")

    enable_categories = BlogSetting.create(:name => "Enable Categories", :value => true, :description => "Set this setting to true to enable 'Category' tags.")
    enable_tags = BlogSetting.create(:name => "Enable Tags", :value => true, :description => "Set this setting to true to enable 'Tags' tags.")
    enable_authors = BlogSetting.create(:name => "Enable Authors", :value => true, :description => "Set this setting to true to enable 'Authors' tags.")
    enable_recent_blogs = BlogSetting.create(:name => "Enable Recent Blog", :value => true, :description => "Set this setting to true to enable 'Recent blogs'.")
    
    enable_related_categories = BlogSetting.create(:name => "Enable Related Categories", :value => true, :description => "Set this setting to true to enable 'Category' tags related list.")
    enable_related_tags = BlogSetting.create(:name => "Enable Related Tags", :value => true, :description => "Set this setting to true to enable 'Tags' tags related list.")
    enable_related_authors = BlogSetting.create(:name => "Enable Related Authors", :value => true, :description => "Set this setting to true to enable 'Authors' tags related list.")

    enable_email_notification = BlogSetting.create(:name => "Enable email notification", :value => true, :description => "Set this setting to true to recieve email notification when new comment are posted.")
    notification_email = BlogSetting.create(:name => "Notification email", :entry => "your@address.com", :description => "If email notification is set to true, email will be sent to this address.")
    
    
    page = Page.create(
      :title => "Blog",
      :link_url => "/blog",
      :deletable => false,
      :position => ((Page.maximum(:position, :conditions => "parent_id IS NULL") || -1)+1),
      :menu_match => "^/blog(\/|\/.+?|)$"
    )
    default_page_parts = RefinerySetting.find_or_set(:default_page_parts, ["Body", "Side Body"]) 
    
    default_page_parts.each do |part|
      page.parts.create(:title => part, :body => nil)
    end
    
    page.parts.create(:title => "Invalid comment", :body => "<p>Your comment was invalid!</p>")
    page.parts.create(:title => "Successful comment", :body => "<p>Your comment was posted successfully!</p>")
    
  end

  def self.down
    UserPlugin.destroy_all({:title => "Blog"})

    Page.find_all_by_link_url("/blog").each do |page|
      page.link_url, page.menu_match = nil
      page.deletable = true
      page.destroy
    end
    Page.destroy_all({:link_url => "/blog"})
    
    drop_table :blogs
    drop_table :comments
    drop_table :blog_settings
  end

end
