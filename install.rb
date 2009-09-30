require "ftools"

%w{javascripts stylesheets images}.each do |subdir|
	Dir["public/#{subdir}/*"].each do |fn| 
		puts "copying #{File.basename(fn)}"
		File.copy(fn, "../../../public/#{subdir}/#{File.basename(fn)}")
	end
end
