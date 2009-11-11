module RootHelper

  def configure_site_network_link
    if current_site.network and may_edit_group?(current_site.network)
      link_to_with_icon 'settings', "Network Settings"[:network_settings], groups_url(:action => 'edit', :id => current_site.network)
    end
  end

  def configure_site_link
    if may_admin_site?
      link_to_with_icon 'wrench', "Administer Site", '/admin'
    end
  end

  def configure_site_appearance_link
    if current_site.custom_appearance and may_admin_site?
      link_to_with_icon 'color_wheel', "Edit Appearance"[:edit_custom_appearance], edit_admin_custom_appearance_url(current_site.custom_appearance)
    end
  end

  def load_panel(panel_name, time_span=nil)
   remote_function(:url => {:controller => 'root', :action => panel_name, :time_span => time_span})
    #, :update => "#{panel_name}_panel")
  end

  def contribute_link
    if may_contribute_to_site?
      link_to_with_icon 'plus', "Contribute to Site"[:contribute_to_site], {:controller => '/pages', :action => 'create', :group => current_site.network}
    end
  end

  def create_group_link
    if may_create_group?
      link_to_with_icon 'membership_add', "Create a Group", '/groups/new'
    end
  end

  def welcome_box_link
    if params[:welcome_box]
      link_to_with_icon 'cancel', "Hide Tips"[:hide_tips], '/'
    else
      link_to_with_icon 'weather_sun', "See Tips to get started"[:see_tips_to_get_started], '/?welcome_box=1'
    end
  end
  
  def titlebox_description_html
    @group.profiles.public.summary_html
  end

  def sidebar_top_partial
    'sidebox_top'
  end
  
end

