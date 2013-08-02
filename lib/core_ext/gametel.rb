module Gametel

  def has_view_class?(clazz)
    platform.get_current_views
    platform.last_json.any? {|v| !!v['classType'].match(clazz) }
  end

  module Views
    class View
      def disabled?
        !enabled?
      end
    end
  end
end
