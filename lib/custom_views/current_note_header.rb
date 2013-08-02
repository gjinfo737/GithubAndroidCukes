module CoPilot
  module Views
    class CurrentNoteHeader < CurrentNote
      HEADER_ID = 'noteview_header_text'
                              
      def initialize(platform)
        super(platform, HEADER_ID)
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

