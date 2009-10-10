namespace :ruby_world do
  def my_system cmd
    puts "running: #{cmd}"
    system cmd
  end

  def install_plugin_task(description, task_name, plugin_dir, plugin_path)
    desc description
    task task_name do
      puts "running task: #{task_name}"
      unless File.exist?("#{RAILS_ROOT}/vendor/plugins/#{plugin_dir}")
        Dir.chdir RAILS_ROOT do
          my_system "ruby #{RAILS_ROOT}/script/plugin install #{plugin_path}"
          m = /\/([^\/]*)\.[^\.]*$/.match(plugin_path)
          if m[1] != plugin_dir then
            Dir.chdir "vendor/plugins" do
              my_system "mv #{m[1]} #{plugin_dir}"
            end
          end
        end
      end
    end
  end

  def install_cloned_plugin_task(description, task_name, plugin_dir, plugin_path, branch_name)
    desc description
    task task_name do
      puts "running task: #{task_name}"
      unless File.exist?("#{RAILS_ROOT}/vendor/plugins/#{plugin_dir}") 
        Dir.chdir "#{RAILS_ROOT}/vendor/plugins" do
          system "git clone #{plugin_path}"
          Dir.chdir plugin_dir do
            my_system "git checkout #{branch_name}"
          end
        end
      end
    end
  end

  install_cloned_plugin_task(
    "setup engines plugin",
    :setup_engines,
    "engines",
    "git://github.com/lazyatom/engines.git",
    "2.1.0")

  install_cloned_plugin_task(
    "setup has_many_polymorphs plugin",
    :setup_has_many_polymorphs,
    "has_many_polymorphs",
    "git://github.com/fauna/has_many_polymorphs.git",
    "fbe21edf4d73fdd42b0e46104419a506168f5adb")

  install_plugin_task(
    "Setup rw_search_command_handler", 
    :setup_rw_search_command_handler, 
    "rw_search_command_handler", 
    "git://github.com/boberetezeke/rw_search_command_handler.git")

  install_plugin_task(
    "Setup rw_backgroundrb", 
    :setup_rw_backgroundrb, 
    "backgroundrb", 
    "git://github.com/boberetezeke/rw_backgroundrb.git")

  install_plugin_task(
    "Setup rw_ruby_command_handler", 
    :setup_rw_ruby_command_handler, 
    "rw_ruby_command_handler", 
    "git://github.com/boberetezeke/rw_ruby_command_handler.git")

  install_plugin_task(
    "Setup acts_as_database_object", 
    :setup_acts_as_database_object, 
    "acts_as_database_object", 
    "git://github.com/boberetezeke/acts_as_database_object.git")

  install_plugin_task(
    "Setup active_record_defaults", 
    :setup_active_record_defaults, 
    "active_record_defaults", 
    "http://svn.viney.net.nz/things/rails/plugins/active_record_defaults")

  install_plugin_task(
    "Setup acts_as_tree", 
    :setup_acts_as_tree, 
    "acts_as_tree", 
    "git://github.com/rails/acts_as_tree.git")

  install_plugin_task(
    "Setup paginator", 
    :setup_pagination, 
    "classic_pagination", 
    "git://github.com/masterkain/classic_pagination.git")

  desc "Setup ruby world plugins"
  task :setup => [
	 :setup_pagination, 
    :setup_acts_as_tree, 
    :setup_active_record_defaults, 
    :setup_acts_as_database_object, 
    :setup_rw_ruby_command_handler, 
    :setup_rw_backgroundrb, 
    :setup_rw_search_command_handler, 
    :setup_has_many_polymorphs,
    :setup_engines]
  desc "Restart BackgrounDRb Server"
  task :restart => [:stop, :start] do
    puts "Restarted BackgrounDRb"
  end  
end