class WorkTimeController < ApplicationController
  unloadable

  before_filter :require_login

  def index
    if User.current.admin?
      @work_items = WorkTime.all
    else
      @work_items = WorkTime.find_all_by_user_id(User.current)
    end

    @work_items
  end

  def toggle
  	user = User.current

  	wt = WorkTime.current(user)

  	# not started
  	if wt.nil?
  		wt = WorkTime.create(
  			user: user,
  			start: DateTime.current())
  	else
  		# if started, just set the end date
  		wt.end = DateTime.current()
  		wt.save()
  	end 

  	respond_to do |format|
  		format.js { render :layout => false }
  	end
  end
end
