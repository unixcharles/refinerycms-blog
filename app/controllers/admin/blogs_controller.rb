class Admin::BlogsController < Admin::BaseController
  before_filter :get_count, :only => 'index'
  crudify :blog, :title_attribute => :title, :order => "publishing_date DESC"

  def get_count
    @unread_comments_count = Comment.unread.count
  end
end
