module CoPilot
  include Gametel

  def self.included(cls)
    cls.extend Gametel::Accessors
    cls.extend CoPilot
  end

  def radial_item(name, locator)
    radial_list = {:list => 1}
    list_item(name, locator.merge(radial_list))
  end
  
  def grid_item(name, locator)
    grid_list = {:list => 1}
    list_item(name, locator.merge(grid_list))
  end

  def event(name, locator)
    radial_item(name, locator)
  end

  def case_item(name, locator)
    radial_item(name, locator)
  end

  def narrative_item(name, locator)
    grid_item(name, locator)
  end

  def member(name, locator)
    radial_item(name, locator)
  end
  
  def document_item(name, locator)
     radial_item(name, locator)
  end
  
  def hint_text(name, id)
    define_method("#{name}") do
      get_hint_text(id)
    end
  end

  def current_note(name)
    define_method("#{name}_body") do
      CoPilot::Views::CurrentNoteBody.new(platform)
    end
    define_method("#{name}_header") do
      CoPilot::Views::CurrentNoteHeader.new(platform)
    end
  end
  
  def current_narrative(name)
    define_method("#{name}_body") do
      CoPilot::Views::CurrentOldNoteBody.new(platform)
    end
    define_method("#{name}_header") do
      CoPilot::Views::CurrentOldNoteHeader.new(platform)
    end
  end
  
  def current_transcription(name)
    define_method("#{name}_body") do
      CoPilot::Views::CurrentOldNoteBody.new(platform)
    end
    define_method("#{name}_header") do
      CoPilot::Views::CurrentOldNoteHeader.new(platform)
    end
  end

  def click_on_position(x, y)
    performAction('click_on_screen', x, y)
  end

  def get_position(id)
    begin
      result = performAction('get_view_property', id, 'left')['message']
    rescue
      result = nil
    end
    result
  end

  def get_hint_text(id)
    platform.chain_calls do |device|
      device.id_from_name id, :target => 'Brazenhead', :variable => '@@the_id@@'
      device.get_view '@@the_id@@', :target => 'Robotium'
      device.get_hint
      device.to_string
    end

    hint = platform.last_response.body
    raise Exception, last_response.body unless platform.last_response.code.eql? "200"
    JSON.parse("{\"hint\": #{hint}}")["hint"]
  end

  def scroll_slightly_left
    how_far = screen_width / 3.0
    from = horizontal_center
    to = horizontal_center + how_far
    in_how_many_steps = 1

    platform.drag from, to, vertical_center, vertical_center, in_how_many_steps
    platform.last_response.body == 'true'
  end

  def scroll_slightly_right
    how_far = screen_width / 3.0
    from = horizontal_center
    to = horizontal_center - how_far
    in_how_many_steps = 1

    platform.drag from ,to, vertical_center, vertical_center, in_how_many_steps
    platform.last_response.body == 'true'

  end

  def draw_right
    from = 10.0
    to = 400.0
    in_how_many_steps = 3

    platform.drag from ,to, vertical_center, vertical_center + 50, in_how_many_steps
    platform.last_response.body == 'true'

  end
  

  def screen_width
    @screen_width ||= get_screen_width
  end

  def screen_height
    @screen_height ||= get_screen_height
  end

  def vertical_center
    screen_height / 2.0
  end

  def horizontal_center
    screen_width / 2.0
  end

  def remove_preference(name, prefix='copilot.app.preferences')
    edit_preferences {|e| e.remove "#{prefix}.#{name.camelized_s}" }
  end

  def set_preference(name, value, prefix='copilot.app.preferences')
    case value
      when Fixnum
        method = 'put_long'
      else
        method = 'put_string'
    end
    edit_preferences {|e| e.send(method, "#{prefix}.#{name.camelized_s}", value)  }
  end

  private
  def default_display(&block)
    platform.chain_calls do |device|
      device.get_current_activity
      device.get_window_manager
      device.get_default_display
      block.call device if block
    end
  end

  def get_screen_width
    default_display do |display|
      display.get_width
    end
    platform.last_response.body.to_i
  end

  def get_screen_height
    default_display do |display|
      display.get_height
    end
    platform.last_response.body.to_i
  end

  def get_custom_view_by_index(clazz, index, &block)
    platform.chain_calls do |device|
      device.get_current_activity
      device.get_class
      device.get_class_loader :variable => '@@loader@@'
      device.get_class
      device.for_name clazz, true, '@@loader@@', :variable => '@@the_class@@'
      device.get_view '@@the_class@@', index, :target => :Robotium
      block.call device if block
    end
  end

  def edit_preferences(&block)
    shared_preferences_name = "copilot.app.preferences"
    mode_private = 0

    platform.chain_calls do |device|
      device.get_current_activity
      device.get_shared_preferences shared_preferences_name, mode_private
      device.edit
      block.call device
      device.commit
    end
  end
end
