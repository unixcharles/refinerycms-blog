namespace :refinery do
  namespace :blog do
	  desc "Install blog plugin"
 
  	task :install do
  		puts `ruby #{File.expand_path(File.dirname(__FILE__) << '/../..')}/bin/refinerycms-blog-install #{Rails.root.to_s}`
  	end
	end
end