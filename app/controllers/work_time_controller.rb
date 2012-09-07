class WorkTimeController < ApplicationController
  unloadable

  before_filter :require_login

  def index
    # filter by dates
    if params[:date].nil?
      @work_items = WorkTime.where(nil)
    else
      @work_items = WorkTime.find_all_by_month_and_year(Integer(params[:date][:month]), Integer(params[:date][:year]))
    end

    # filter by user
    if not params[:user].nil? 
      @work_items = @work_items.where(:user_id => Integer(params[:user][:id]))
    elsif not User.current.admin?
      @work_items = @work_items.where(:user_id => User.current)
    end

    @work_items
  end

  def toggle
  	user = User.current

  	wt = WorkTime.current(user)

  	# not started
  	if wt.nil?
  		wt = WorkTime.create(
  		  :user_id => user,
  			:start => DateTime.current(),
        :remoteip =>  request.remote_ip
      )

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
