class WorkTimeController < ApplicationController
  unloadable

  before_filter :require_login

  helper :sort
  include SortHelper

  def index
    sort_init [ %w( user_id remoteip start stop ) ]
    sort_update %w(user_id start remoteip stop)

    @month = params[:month].nil? ? Date.today.month : Integer(params[:month])
    @year = params[:year].nil? ? Date.today.year : Integer(params[:year])

    if not User.current.admin?
      @user_id = User.current.id
    else
      @user_id = params[:user_id]
    end

    @work_items = WorkTime.find_all_by_month_and_year(@month, @year)
    @work_items = @work_items.order sort_clause

    if not @user_id.nil? and not @user_id.blank?
      @work_items = @work_items.where("user_id = ?", @user_id)
    end

    @work_items
  end

  def toggle
  	user = User.current

  	wt = WorkTime.current(user)

  	# not started
  	if wt.nil?
  		wt = WorkTime.create(
  		  :user_id => user.id,
  			:start => DateTime.current(),
        :remoteip => request.remote_ip
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
