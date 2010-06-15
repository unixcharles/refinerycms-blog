class Admin::BlogsController < Admin::BaseController
  
  before_filter :group_blogs_by_date, :only => 'index'
  
  crudify :blog, :title_attribute => :title, :order => "publishing_date DESC"
  
  def group_blogs_by_date
    @grouped_blogs = Blog.grouped_by_date
  end  
  
end
