module CoPilot
  module Views
    class CurrentNote < Gametel::Views::View
      attr_reader :platform, :view_id

      def initialize(platform, view_id)
        @platform = platform
        @view_id = view_id
        build_property_methods
      end

      protected
      def the_current_view(&block)
        platform.chain_calls do |device|
          device.id_from_name view_id, :target => 'Brazenhead', :variable => '@@note_child_id@@'
          device.get_view 8080, :target => 'Robotium'
          device.get_current_view
          device.find_view_by_id '@@note_child_id@@', :variable => '@@note_child_view@@'
          block.call device if block
        end
      end

      def build_property_methods
        metaclass = class << self; self; end

      properties.each do |property|
        metaclass.send(:define_method, "#{property}?".to_sym) do

          the_current_view do |device|
            device.send "is_#{property}"
          end

          platform.last_response.body == 'true'
        end
      end
    end
    end
  end
end
