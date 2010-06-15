ActionController::Routing::Routes.draw do |map|
  map.blog '/blog.:format', :controller => 'blogs', :action => 'index'

  map.blog_tag '/blog/tag/:tag', :controller => 'blogs', :action => 'tag'
  map.blog_category '/blog/category/:category', :controller => 'blogs', :action => 'category'
  map.blog_author '/blog/author/:author', :controller => 'blogs', :action => 'author'

  map.blog_authorize '/blog/authorize/:token', :controller => 'blogs', :action => 'authorize'

  map.blog_post '/blog/:permalink', :controller => 'blogs', :action => 'show', :conditions => { :method => :get }
  map.comment '/blog/:permalink', :controller => 'blogs', :action => 'comment', :conditions => { :method => [:post, :put] }

  map.raptcha '/raptcha', :controller => 'blogs', :action => 'captcha'

  map.namespace(:admin, :path_prefix => (defined?(REFINERY_GEM_VERSION) ? "admin" : "refinery") ) do |admin|
    admin.resources :blogs, :as => 'blog'
    admin.resources :comments, :member => {:toggle_status => :get, :unmoderated => :get}
    admin.connect 'blog_settings/toggle_setting/:id', :controller => "blog_settings", :action => "toggle_setting"
    admin.resources :blog_settings
  end
end
