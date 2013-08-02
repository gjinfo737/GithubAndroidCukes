require 'gametel'

Gametel.apk_path = "../app/bin/CoPilot-debug.apk"
Gametel.start "_AppActivity"

@driver = Gametel.default_driver
@platform = @driver.platform

def tag_for(item, list, which_image=0)
	@platform.chain_calls do |d|
		d.list_item_by_index(item, list, :target => :Brazenhead, :variable => '@@the_list_item@@')
		d.get_class
		d.for_name 'android.widget.ImageView', :variable => '@@image_class@@'
		d.get_current_views '@@image_class@@', '@@the_list_item@@', :target => :Robotium
		d.get(which_image)
		d.get_tag
	end
	@platform.last_json
end

def drawable_id(id)
	@platform.chain_calls do |d|
		d.get_current_activity
		d.get_resources :variable => '@@resources@@'
		d.get_identifier id, 'drawable', 'copilot.app'
	end
	@platform.last_json
end
