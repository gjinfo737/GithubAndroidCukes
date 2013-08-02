class FormPage
  include CoPilot, Drawing, DrawbleTags

  activity(:ViewFormActivity)

  button(:seekbar_form, :id => '-100')
  button(:save_form, :id => '-101')
  button(:palette, :id => '-102')
  button(:mail_form, :id => '-103')
  button(:print_form, :id => '-104')
  button(:delete_form, :id => '-106')

  button(:pen, :id => :pen_palette_ctrl_pen)
  button(:girth, :id => :pen_palette_ctrl_girth)
  button(:eraser, :id => :pen_palette_ctrl_erase)

  button(:sync_options, :id => :sync_state_spinner)

  button(:confirm_delete, :text => 'Yes')
  button(:cancel_delete, :text => 'No')

  alias_method :orig_palette, :palette

  #
  # There is a delay on the palette button. This waits until
  # the SignatureView is either shown or hidden depending
  # on the current state.
  #
  def palette
    the_original_state  = signature_view?
    orig_palette
    wait_until { signature_view? != the_original_state }
  end

  def set_to_sync_state? expected_sync_state
    platform.get_view_by_id(:sync_state_spinner) do |spinner|
      spinner.to_string == expected_sync_state
    end
  end

  def sync_options=(which)
    unless sync_is?(which)
      sync_options
      platform.click_on_text "^#{which}$"
    end
  end

  def able_to_save?
    enabled? '-101'
  end

  def able_to_change_sync_property?
    sync_options_view.enabled?
  end

  def able_to_delete?
    enabled? '-106'
  end

  def in_the_diverted_state?
    enabled? '-100' and
    not enabled? '-101' and
    enabled? '-102' and
    enabled? '-103' and
    enabled? '-104' and
    not enabled? '-106' and
    not able_to_change_sync_property?
  end

  def in_pen_mode?
    enabled? '-100' and
    not enabled? '-101' and
    enabled? '-102' and
    not enabled? '-103' and
    not enabled? '-104' and
    not enabled? '-106' and
    not able_to_change_sync_property?
  end

  def enter_annotation_text(index, text_to_enter)
    platform.scroll_to_top
    platform.clear_edit_text index
    platform.get_view_by_index('android.widget.EditText', index) do |device|
      device.enter_text '@@the_view@@', text_to_enter, :target => "Robotium"
    end
  end

  def get_annotation_text(index)
    platform.chain_calls do |app|
      app.get_edit_text index
      app.get_text
      app.to_string
    end
    platform.last_json
  end

  def slide_seekbar_form_to_end()
    #info = scrubber_info
    padding = 34.0
    view_info = JSON.parse(platform.get_view_by_id('-100').body)
    view_x = view_info["screenLocation"][0]
    view_y = view_info["screenLocation"][1]
    #view_step = (view_info["width"] / info[:total_notes]).to_f
    #position_x = (view_step * 10) + view_x
    position_x = view_x + view_info["width"]-10
    sleep 2
    platform.click_on_screen position_x.to_f, view_y.to_f
  end

  def penning?
    tag_for_view(:pen_palette_ctrl_pen) == drawable_id(:forms_sign_icon_selected)
  end

  def erasing?
    tag_for_view(:pen_palette_ctrl_erase) == drawable_id(:forms_eraser_selected)
  end

  def able_to_pen?
    (tag_for_view(:pen_palette_ctrl_pen) == drawable_id(:forms_sign_icon) or
    tag_for_view(:pen_palette_ctrl_pen) == drawable_id(:forms_sign_icon_selected)) and
    enabled? :pen_palette_ctrl_pen
  end

  def able_to_erase?
    ( tag_for_view(:pen_palette_ctrl_girth) == drawable_id(:forms_pen_weight_icon)  or
    tag_for_view(:pen_palette_ctrl_erase) == drawable_id(:forms_eraser_selected) ) and
    enabled? :pen_palette_ctrl_erase
  end

  def able_to_change_girth?
    tag_for_view(:pen_palette_ctrl_girth) == drawable_id(:forms_pen_weight_icon) and
    enabled? :pen_palette_ctrl_girth
  end

  def signature_view?
    has_view_class? /SignatureView/
  end

  private
  def sync_is?(which)
    sync_options_value.match /^#{which}$/i
  end

  def sync_options_value
    platform.get_view_by_id(:sync_state_spinner) do |device|
      device.get_selected_item
      device.get_sync_state
    end
    platform.last_json
  end

end
