require 'ADB'

class Screenshots
  extend ADB

  def self.shoot(name='copilot')
    platform.take_screenshot("#{now}.#{name}")
  rescue
    # eat it if it fails
  end

  def self.clear
    shell "rm #{robotium_screenshots}/*"
  end

  def self.dump(directory='screenshots')
    pull robotium_screenshots, directory
  end

  private
  def self.now
    Time.now.to_s.gsub(/\W+/,'.')
  end

  def self.robotium_screenshots
    'sdcard/Robotium-Screenshots'
  end

  def self.platform
    @platform ||= Gametel.default_driver.platform
  end
end

