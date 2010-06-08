class Admin::BlogsController < Admin::BaseController
  
  before_filter :get_count, :only => 'index'
  before_filter :group_blogs_by_date, :only => 'index'
  
  crudify :blog, :title_attribute => :title, :order => "publishing_date DESC"

  def get_count
    @unread_comments_count = Comment.unread.count
  end
  
  def group_blogs_by_date
    @grouped_blogs = Blog.grouped_by_date
  end  
  
end
