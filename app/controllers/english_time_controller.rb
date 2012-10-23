class EnglishTimeController < ApplicationController
  unloadable


  def toggle
  	user = User.current
  	@english_time = EnglishTime.current(user)

  	if @english_time.nil?
  		@english_time = EnglishTime.create(
  			:user_id => user.id, 
  			:start => DateTime.current())
  	else
  		@english_time.end = DateTime.current()
  		@english_time.save!
  	end

  	respond_to do |format|
  		format.js { render :layout => false, :template => "work_time/toggle.js.erb" }
  	end
  end
end
