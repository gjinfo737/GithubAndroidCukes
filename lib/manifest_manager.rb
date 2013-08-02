require 'tmpdir'
require 'ADB'

class ManifestManager
  include ADB

  def initialize
    @base_manifests_dir = './manifests'
    @copilot_sdcard_path = '/mnt/sdcard/CoPilot'
  end

  def use(manifest)
    Dir.mktmpdir do |temp_dir|
      puts "Pushing manifest #{manifest}..."
      temp_manifest = temp_manifest(temp_dir, manifest)
      push temp_manifest, @copilot_sdcard_path
    end
  end

  def clean(manifest)
    remove_files_in all_files_for(manifest)
    remove_dirs_in all_dirs_for(manifest)
    clear_new_notes
  end

private
  def manifest_dir(name)
    File.join(@base_manifests_dir, copilot_dir(name))
  end

  def temp_manifest(dir, name)
    temp_manifest = File.join(dir, copilot_dir(name))
    FileUtils.cp_r(minimal_manifest(), temp_manifest)
    temp_manifest
  end

  def minimal_manifest
    manifest_dir(:Minimal)
  end

  def local_to_sdcard(str)
    str.gsub /\.\/manifests\/CoPilot-[^\/]+/, @copilot_sdcard_path
  end

  def remove_files_in(search_pattern)
    Dir.glob(search_pattern) do |file|
      shell "rm #{local_to_sdcard(file)}"
    end
  end

  def remove_dirs_in(search_pattern)
    all_dirs = Dir.glob(search_pattern).to_a.reverse << @copilot_sdcard_path
    all_dirs.each do |file|
      shell "rmdir #{local_to_sdcard(file)}"
    end
  end

  def all_files_for(manifest)
    File.join(manifest_dir(manifest), '/**/*.*')
  end

  def all_dirs_for(manifest)
    File.join(manifest_dir(manifest), '/**/*/')
  end

  def copilot_dir(name)
     "CoPilot-#{name}"
  end

  def clear_new_notes
    new_notes.each do |note_file|
      shell "rm #{note_file}"
    end
  end

  def new_notes
    shell "ls #{notes_dir}/-*"
    last_stdout.split
  end

  def notes_dir
    "#{@copilot_sdcard_path}/Package/Notes"
  end
end
