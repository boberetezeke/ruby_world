require "ftools"

# Fix up system call for Windows
if RUBY_PLATFORM == "i386-mswin32" then
  require 'Win32API' 

  def system(command)
    Win32API.new("crtdll", "system", ['P'], 'L').Call(command)
  end  
end

# copy public files
def copy_public_files
  %w{javascripts stylesheets images}.each do |subdir|
    Dir["vendor/plugins/ruby_world/public/#{subdir}/*"].each do |fn| 
      dest_fn = "public/#{subdir}/#{File.basename(fn)}"
      puts "copying #{File.basename(fn)} to #{dest_fn}"
      begin
        File.copy(fn, dest_fn)
      rescue Exception => e
        puts "ERROR: #{e.message}"
      end
    end
  end
end

ORDERED_PLUGINS = ":acts_as_tree, :has_many_polymorphs, :acts_with_metadata, :acts_as_database_object, "

# modify environment.rb
def modify_environment_rb
  lines = File.readlines("config/environment.rb")

  engine_boot_index = nil
  boot_index = nil
  config_plugins_index = nil
  config_plugins = nil
  lines.each_with_index do |line, index|
    case line
    when /^require .*vendor\/plugins\/engines\/boot'\)$/
      engine_boot_index = index
    when /^require .*'boot'\)$/
      boot_index = index
    when /config.plugins\s*=\s*\[(.*)\]/
      config_plugins_index = index
      config_plugins = $1
    end
  end

  if config_plugins_index then
    if config_plugins =~ /#{ORDERED_PLUGINS}/ then
      puts "WARNING: ordered plugins already added"
    else
      config_changed = true
      # if the config.plugins is commented out
      if lines[config_plugins_index] =~ /#.*config\.plugins/ then
        # replace the line
        lines[config_plugins_index] = "  config.plugins = [#{ORDERED_PLUGINS}, :all]"
      else
        # insert the plugins at the beginning and all at the end
        lines[config_plugins_index].sub!(/config.plugins\s*=\s*\[/, "config.plugins = [#{ORDERED_PLUGINS}")
        lines[config_plugins_index].sub!(/\]/, ", :all]")
      end
    end
  else
    puts "ERROR: config.plugins line not found"
  end

  if boot_index && engine_boot_index then
    puts "WARNING: engine boot line already added"
  elsif boot_index && !engine_boot_index then
    config_changed = true
    lines.insert(boot_index, 
      "require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')")
  end

  if config_changed then
    puts "STATUS: re-writing config/environement.rb"
    File.open("config/environment.rb", "w") {|f| lines.each {|line| f.puts line}}
  end
end

def remove_controller_application_rb
  File.unlink("app/controllers/application.rb")
end

# main steps
copy_public_files
modify_environment_rb
remove_controller_application_rb

system "rake ruby_world:setup"
system "rake backgroundrb:setup"

#puts "*************************************************"
#puts "do rake ruby_world:setup to install plugins      "
#puts "*************************************************"

