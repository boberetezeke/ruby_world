require "ftools"

%w{javascripts stylesheets images}.each do |subdir|
	Dir["vendor/plugins/ruby_world/public/#{subdir}/*"].each do |fn| 
		dest_fn = "../../../public/#{subdir}/#{File.basename(fn)}"
		puts "copying #{File.basename(fn)} to #{dest_fn}"
		begin
			File.copy(fn, dest_fn)
		rescue Exception => e
			puts "ERROR: #{e.message}"
		end
	end
end
