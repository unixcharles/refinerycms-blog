class Admin::CommentsController < Admin::BaseController
  crudify :comment, :title_attribute => "name", :order => "created_at DESC"
  
  before_filter :find_comment, :only => [:show, :status, :unread, :destroy]
  before_filter :find_all_comments, :only => [:index]
  
    def status
      if params[:approved]
         @comment.approved = false unless params[:approved] == "true"
         @comment.save
      else
        @comment.toggle!(:approved)
      end
      
      flash[:notice] = "Comment from '#{@comment.name}' in '#{@comment.blog.title}' blog post has been " +
      if @comment.is_approved
        "approved"
      else
        "refused"
      end

      redirect_to :action => 'index'
    end

    def unread
      @comment.approved = nil

      if @comment.save
        flash[:notice] = "You sent a comment from '#{@comment.name}' back to unread comments"
      end
      
      redirect_to :action => 'index'
    end
  protected

    def find_all_comments
      @comments_history = Comment.history.paginate :page => params[:page]
      @unread_comments = Comment.unread
    end
end