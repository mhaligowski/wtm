class WorkTime < ActiveRecord::Base
	belongs_to :user
	
	def start(time)
		puts "start"
	end

	def stop(time)
		puts "stop"
	end
end
