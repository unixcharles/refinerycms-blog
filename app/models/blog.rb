class Blog < ActiveRecord::Base
  
  acts_as_taggable_on :categories, :tags, :authors
  
  has_many :comments

  named_scope :published, lambda {{:conditions => ["publishing_date < '#{Time.now.to_formatted_s(:db)}' and draft != ?", true],
                                  :order => "publishing_date DESC"}}


  acts_as_indexed :fields => [:title, :permalink, :excerpt, :body],
                  :index_file => [Rails.root.to_s, "tmp", "index"]

  validates_presence_of :excerpt, :body
  validates_uniqueness_of :title, :permalink, :case_sensitive => true

  validates_format_of :permalink, :with => /^(([-_]|[a-z]|\d){1,100})$/, :message => " is invalid, only lowercase alphanumeric character and _-"
  validates_length_of :permalink, :within => 4..99
  validates_length_of :title, :within => 2..95
  
  NUM_RECENT_POSTS = 5
  
  def before_validation
    self.permalink = title.parameterize if permalink.blank?
  end

  def published?
    # A blog post should be published? if:
    # the publishing date is before now and it is not a draft blog post.
    publishing_date <= Time.now && !draft
  end
  
  def approved_comment_count
    comments.approved.size
  end
  
  def self.grouped_by_date
    all.group_by { |blog| blog.publishing_date.to_date }.sort {|a,b| b[0] <=> a[0]}
  end
  
  def self.tags
    Blog.published.tag_counts.collect(&:name)
  end

  def self.categories
    Blog.published.category_counts.collect(&:name)
  end

  def self.authors
    Blog.published.author_counts.collect(&:name)
  end
  
  def self.recent_posts
    Blog.published.first(NUM_RECENT_POSTS)
  end
  
  def recent_posts
    recent_posts = Blog.published(:limit => (NUM_RECENT_POSTS+1))
    recent_posts.delete(self)
    recent_posts.first(NUM_RECENT_POSTS)
  end
  
end
