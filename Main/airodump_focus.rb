require_relative 'router'
require_relative 'airodump_runner'
#Focuses airodump-ng's scan on one specific router


def airodump_focus routers = Array.new
	
	puts "\nChoose which router to crack:"
	puts "---------------------------"

	i = 1
	routers.each do |el|
		if el.privacy =~ /WPA/
			el.set_id(i)
			puts "#{el.id}) #{el.essid}   ->   #{el.privacy}"
			i += 1
		end
	end

	puts "---------------------------"
	puts "Example: 5"
	printf "\n-> "
	
	input = gets.chomp
	input = input.to_i

	if input > 0 && input < routers.length
		routers.each do |el|
			if el.id.to_i == input
				airodump_runner(1,el)
			end
		end
	else
		puts "Error: No such router id found!"
	end

end
