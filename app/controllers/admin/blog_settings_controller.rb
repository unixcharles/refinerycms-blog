class Admin::BlogSettingsController < Admin::BaseController

  crudify :blog_setting, :title_attribute => :name, :order => "id ASC", :searchable => false


  def toggle_setting
    @blog_setting = BlogSetting.find(params[:id])
    @blog_setting.toggle!(:value)
    
    flash[:notice] = "Comment from '#{@blog_setting.name}' has been set to " +
    if @blog_setting.value
      "true"
    else
      "false"
    end

    redirect_to :action => 'index'
  end
end
