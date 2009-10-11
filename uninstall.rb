require "ftools"

%w{javascripts stylesheets images}.each do |subdir|
	Dir["public/#{subdir}/*"].each do |fn| 
		puts "removing #{File.basename(fn)}"
		File.delete("../../../public/#{subdir}/#{File.basename(fn)}")
	end
end
