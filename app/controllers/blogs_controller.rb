class BlogsController < ApplicationController

  before_filter :find_blog, :only => [:comment, :show, :authorize]
  before_filter :find_page, :except => [:captcha, :authorize]
  before_filter :load_blogs, :except => [:captcha, :authorize, :tag, :category, :author, :show]

  def index
    present(@page)

    respond_to do |format|
      format.html
      format.rss
    end
  end

  def tag
    @blogs = Blog.tagged_with(params[:tag], :on => :tags).published    
    present(@page)
    render_or_404(@blogs)
  end
  
  def category
    @blogs = Blog.tagged_with(params[:category], :on => :categories).published
    present(@page)
    render_or_404(@blogs)
  end

  def author
    @blogs = Blog.tagged_with(params[:author], :on => :authors).published
    present(@page)
    render_or_404(@blogs)
  end

  def show
    if @blog.present? and @blog.published?
      @comment = @blog.comments.new
      present(@page)
    else
      error_404
    end
  end

  def comment
    @comment = @blog.comments.new(params[:comment])

    if Raptcha.valid?(params) || BlogSetting.enable_captcha == false
      @comment.approved = true unless BlogSetting.manual_moderation
      if @comment.save
        if BlogSetting.manual_moderation
          flash[:notice] = "Thank you for your comment. It will appear once it has been approved by our moderators."
        elsif BlogSetting.enable_approve_comment_by_email
          flash[:notice] = "Thank you for your comment. You have been emailed to approve this comment before it will appear."
        else
          flash[:notice] = @page[:successful_comment]
        end
        
        if BlogSetting.enable_email_notification
          begin
            BlogMailer.deliver_notification(@comment, request)
          rescue
            logger.warn "There was an error delivering a blog notification.\n#{$!}\n"
          end
        end
        if BlogSetting.enable_approve_comment_by_email && BlogSetting.manual_moderation
          begin
            BlogMailer.deliver_confirmation(@comment, request)
          rescue
            logger.warn "There was an error delivering a blog confirmation.\n#{$!}\n"
          end
        end
        @comment = @blog.comments.new
      end
    else
      @comment.valid?
      @comment.errors.add_to_base "Captcha is incorrect"
    end

    present(@page)
    render 'show'
  end

  def captcha
    Raptcha.render(controller=self, params)
  end

  def authorize
    if params[:token] && BlogSetting.enable_approve_comment_by_email && BlogSetting.manual_moderation
      @comment = Comment.find_by_token(params[:token])
      @comment.approved = true
      redirect_to blog_post_url(@comment.blog.permalink) if @comment.save
    else
      redirect_to blog_url
    end
  end

protected
  def load_blogs
    @blogs = Blog.published
  end

  def find_blog
    if (@blog = Blog.find_by_permalink(params[:permalink], :conditions => ["publishing_date < ? and draft != ?", Time.now, true]))
      if BlogSetting.enable_related_tags
        @related_tags_blogs = @blog.find_related_tags.reject {|blog| !blog.published? && !@blog }
      end

      if BlogSetting.enable_related_categories
        @related_categories_blogs = @blog.find_related_categories.reject {|blog| !blog.published? && !@blog }
      end

      if BlogSetting.enable_related_authors
        @related_authors_blogs = @blog.find_related_authors.reject {|blog| !blog.published? && !@blog }
      end
    end
  end

  def find_page
    @page = Page.find_by_link_url("/blog")
  end

  def render_or_404(blogs)
    if blogs.empty?
      error_404
    else
      render :action => 'index'
    end
  end
end
