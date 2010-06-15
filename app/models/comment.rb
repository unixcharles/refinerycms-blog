class Comment < ActiveRecord::Base
  belongs_to :blog
  
  named_scope :unmoderated, :conditions => { :approved => nil }
  named_scope :history, :conditions => 'approved IS NOT NULL', :order => "created_at DESC"
  
  named_scope :approved, :conditions => {:approved => true}
      
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                      :message => 'must be valid'

  validates_length_of :name, :email, :title, :within => 3..80
  validates_length_of :body, :within => 3..1000
  
  acts_as_indexed :fields => [:title, :body, :name, :email],
                  :index_file => [Rails.root.to_s, "tmp", "index"]
  
  
  attr_accessible :name, :email, :body, :title

  def is_approved?
    true if approved
  end
  
  def before_create
    self.token ||= ActiveSupport::SecureRandom.hex(24) if BlogSetting.enable_approve_comment_by_email
  end
end
