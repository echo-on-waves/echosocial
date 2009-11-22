module Admin::AllHelper

  def tab_link(title, view=nil, options={})
    view ||= title
    obj_type = options[:obj_type] || 'pages'
    controller_path = 'admin/pages' if obj_type == 'pages'
    controller_path = 'admin/discussion_posts' if obj_type == 'posts'
    link_to_active( title, :controller => controller_path, :action => 'index', :view => view)
  end

  def actions_for(tab)
    if tab== 'new'
      ['approve', 'trash']
    elsif tab=='vetted'
      ['trash']
    elsif tab=='deleted'
      ['undelete']
    end
  end

  def button_to_action(action, params)
    button_to(action.capitalize, :action => action, :params => params)
  end

  def flags_for_details(foreign_id, type)
    ModeratedFlag.find_all_by_type_and_foreign_id(type, foreign_id)
  end

  def link_to_see_all_flags_by_type(obj_type)
    if obj_type == "pages"
      icon = 'page_white_copy_16'
      title = 'See All Pages'
      controller = 'pages'
    elsif obj_type == "posts"
      icon = 'page_discussion_16'
      title = 'See All Posts'
      controller = 'discussion_posts'
    elsif obj_type == "chats"
      icon = 'chat_16'
      title = 'See All Chat Messages'
      controller = 'chat_messages'
    end
    link = "<span class='small_icon #{icon}'>" + link_to_active( title, { :controller => "admin/#{controller}", :action => 'index', :view => 'all' }, @current_view == 'all' ) + "</span>"
  end

  def display_public_pages_links(obj_type)
    return unless obj_type == 'pages'
    render :partial => '/admin/pages/public_links'
  end

  def listing_custom_column_header(obj_type, view)
    return "Type" if obj_type == 'pages'
    return "Comment" if obj_type == 'posts'
  end

  def listing_custom_column_content(foreign_obj, view)
    if foreign_obj.is_a?(Post)
      post_link(foreign_obj)
    elsif foreign_obj.is_a?(Page)
      h(foreign_obj.type)
    else
      "n/a"
    end
  end

  def flagged_page_link(foreign_obj)
    if foreign_obj.is_a?(Page)
       link_to foreign_obj.title, page_url(foreign_obj), {:target =>  '_blank'}
    elsif foreign_obj.is_a?(Post)
       page_link(foreign_obj)
    else
      "n/a"
    end
  end

  def list_created_by(foreign_obj)
    h(foreign_obj.created_by.try.login) || "Unknown"
  end

  def show_flag_details(flag)
    flag_type = flag.class.to_s
    return unless flag_type =~ /^Moderated/
    render :partial => '/admin/show_details', :locals => {:foreign_id => flag.foreign_id, :obj_type => flag_type }
  end

end
