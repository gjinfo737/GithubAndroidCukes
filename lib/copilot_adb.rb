require 'ADB'

class CoPilotADB
  include ADB

  def uninstall_copilot
    begin
      uninstall "copilot.app"
    rescue
    end
  end
end
