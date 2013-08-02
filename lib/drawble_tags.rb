module DrawbleTags
  def tag_for_view(id)
    platform.get_view_by_id(id) do |d|
      d.get_tag
    end
    platform.last_json
  end

  def tag_for(item, list, which_image=0)
    platform.get_view_by_index('android.widget.ListView', list) do |d|
      d.get_child_at item, :variable => '@@the_list_item@@'
      d.get_class
      d.for_name 'android.widget.ImageView', :variable => '@@image_class@@'
      d.get_current_views '@@image_class@@', '@@the_list_item@@', :target => :Robotium
      d.get(which_image)
      d.get_tag
    end
    platform.last_json
  end

  def drawable_id(id)
    platform.chain_calls do |d|
      d.get_current_activity
      d.get_resources :variable => '@@resources@@'
      d.get_identifier id, 'drawable', 'copilot.app'
    end
    platform.last_json
  end
end