class Admin::CommentsController < Admin::BaseController
  crudify :comment, :title_attribute => "name", :order => "created_at DESC"

  before_filter :find_comment, :only => [:show, :toggle_status, :unmoderated, :destroy]
  before_filter :find_all_comments, :only => [:index]

  def toggle_status
    @comment.toggle!(:approved)

    flash[:notice] = "Comment from '#{@comment.name}' in '#{@comment.blog.title}' blog post has been #{@comment.is_approved? ? "approved" : "refused"}"

    redirect_to :action => 'index'
  end

  def unmoderated
    if @comment.update_attribute(:approved, nil)
      flash[:notice] = "You sent a comment from '#{@comment.name}' back to unmoderated comments"
    end

    redirect_to :action => 'index'
  end
protected

  def find_all_comments
    @comments_history = Comment.history.paginate :page => params[:page]
    @unmoderated_comments = Comment.unmoderated
  end
end