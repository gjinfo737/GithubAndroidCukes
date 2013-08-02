module CoPilot
  module Views
    class CurrentOldNoteBody < CurrentNote
      BODY_ID = 'noteview_text'

      def initialize(platform)
        super(platform, BODY_ID)
      end

      def text
        the_current_view do |device|
          device.get_text
          device.to_string
        end
        platform.last_response.body.chomp("\"").sub(/^"/,"")
      end

      def text=(value)
        the_current_view do |device|
          device.enter_text '@@note_child_view@@', value, :target => 'Robotium'
        end
      end
    end
  end
end