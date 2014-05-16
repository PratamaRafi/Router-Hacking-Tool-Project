require './airmon_parser.rb'
require './monitoring_starter.rb'
require './monitoring_stopper.rb'
# Test injection, sends probe requests to all visible APs

def injection_test_parser interface = "wlan0"

	routers = Array.new
	
	for channel in 1..11
	
		start(interface, 0, 1, channel)
	
		possibility = []
		essid = []
		poss_new = []
	
		system("aireplay-ng -9 mon0 > inj_test.txt")

		file = File.foreach("inj_test.txt") do |line| 
	
			if line =~ /.\d\/30:\s.\d/
				possibility << line	
			end	

			if line =~ /- channel: #{channel}/
				essid << line.split('\'')[1]
			end

		 end

		 for i in 0..possibility.length-1
		 	if possibility[i].length < 25 
		 		poss_new << possibility[i][10..20]
		 		
		 	end
		 end
	
		for i in 0..essid.length - 1
		
			ap = Hash.new
			ap["essid"] = essid[i]
			ap["probes"] = poss_new[i]
		
			routers << ap
		end
	
		monitoring_stopper(airmon_parser)
	end
	
	puts 
	puts routers.length
	puts routers
	puts
		
	return routers

end

#injection_test_parser

def supports_injection?

	inj_works = false
	
	system("aireplay-ng -9 mon0 > inj_test.txt")
	
	file = File.foreach("inj_test.txt") do |line| 
	
		if line =~ /Injection is working!/
			inj_works = true
		end
		
	end
	
	return inj_works
end
