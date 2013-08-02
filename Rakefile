#!/usr/bin/env rake
require 'cucumber'
require 'cucumber/rake/task'
require 'launchy'

Cucumber::Rake::Task.new(:features, "Run all features") do |t|
  t.profile = 'all'
end

Cucumber::Rake::Task.new(:sanity_features, "Run all sanity features") do |t|
  t.profile = 'sanity'
end

desc 'Builds the debug apk and runs the features'
task :all => ['debug_apk', 'features']

desc 'Builds the debug apk and runs the sanity features'
task :sanity => ['debug_apk', 'sanity_features']

desc 'Uninstall the current app from the tablet (if connected) and then clean / build the latest apk'
task :debug_apk => :clean_apk do
  `#{ant_app} -f ../app/build.xml clean debug`
end

desc 'Uninstalls the current CoPilot apks (test apk as well as the application)'
task :clean_apk do
  puts `adb get-state | grep device && adb uninstall copilot.app.brazenhead`
  puts `adb get-state | grep device && adb uninstall copilot.app`
end

desc 'deletes tablet existing manifest and pushes the minimal manifest'
task :clean_push => ['clean_manifest', 'push_minimal'] do
  shell_exec("adb push manifests/CoPilot-Minimal /mnt/sdcard/CoPilot")
end

desc 'deletes tablet\'s existing manifest'
task :clean_manifest do
  puts "Cleaning manifest..."
  shell_exec("adb shell rm -r /mnt/sdcard/CoPilot")
end

desc 'pushes the minimal manifest'
task :push_minimal do
  puts "Pushing minimal manifest..."
  shell_exec("adb push manifests/CoPilot-Minimal /mnt/sdcard/CoPilot")
end

desc 'Updates the CoPilot.apk in TFS for Compass Pilot'
task :tfs_update_copilot, :tfs_pilot, :copilot_apk, :build_id do |t, args|
  tfs_pilot = args[:tfs_pilot]
  copilot_apk = args[:copilot_apk]
  raise 'You must provide a directory where the FrameworkUI folder is for git-tf to work' unless tfs_pilot
  raise 'You must provide the path to the CoPilot apk' unless copilot_apk
  copilot_manifest = File.join(File.dirname(copilot_apk),'AndroidManifest.xml')

  tfs_pilot, copilot_apk, copilot_manifest = [tfs_pilot, copilot_apk, copilot_manifest].map(&File.method(:expand_path))
  build_url = "http://jukebox:8080/viewLog.html?buildId=#{args[:build_id]}"

  Dir.chdir(tfs_pilot) do |tfs_dir|
    puts "Pulling the latest from TFS..."
    shell_exec('git tf pull --rebase')
    puts "Copying the latest apk from #{copilot_apk}"
    shell_exec("cp #{copilot_apk} ./CoPilot.apk")
    shell_exec("cp #{copilot_manifest} ./AndroidManifest.xml")
    puts "Committing to git-tf..."
    shell_exec("git add CoPilot.apk AndroidManifest.xml && git commit -m \"Latest CoPilot.apk and AndroidManifest.xml (#{build_url})\"")
    puts "Committing to TFS..."
    shell_exec('git tf checkin --deep --no-lock')
  end
end

task :default => :all

def shell_exec(command)
  puts "Running '#{command}'"
  `#{command}`
  raise "Error running `#{command}`" unless $?.success?
end

def ant_app
  return 'ant.bat' if Launchy::Application.new.host_os_family.windows?
  'ant'
end


