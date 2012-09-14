class WorkTimeController < ApplicationController
  unloadable

  before_filter :require_login

  helper :sort
  include SortHelper

  def index
    sort_init [ %w( user_id remoteip start stop ) ]
    sort_update %w(user_id start remoteip stop)

    @from = params[:from].nil? ? Date.today.at_beginning_of_month : params[:from]
    @to = params[:to].nil? ? Date.today.at_end_of_month : params[:to]

    if not User.current.admin?
      @user_id = User.current.id
    else
      @user_id = params[:user_id]
    end

    @work_items = WorkTime.where(:start => @from..@to)
    @work_items = @work_items.order sort_clause

    if not @user_id.nil? and not @user_id.blank?
      @work_items = @work_items.where("user_id = ?", @user_id)
    end

    @work_items
  end

  def report_present
    q = "SELECT users.login, work_times.remoteip, work_times.start FROM users
           LEFT OUTER JOIN work_times ON (work_times.user_id = users.id 
                                      AND work_times.end IS NULL) 
          WHERE users.type = 'User'"

    ActiveRecord::Base.establish_connection
    @r = ActiveRecord::Base.connection.execute(q);

    if @r.class == Array
      @r
    elsif @r.class == Mysql::Result
      @result = []
      while row = @r.fetch_row do
        @result << row
      end

      @r = @result
    end
  end

  def report_task_time
    sort_init [ %w( user_id lastname ) ]
    sort_update %w(user_id lastname)

    @time_entries = TimeEntry.select("user_id, issues.subject, hours, spent_on").joins(:issue)
    if ActiveRecord::Base.connection.adapter_name == 'MySQL'
      @work_items = WorkTime.select("user_id, users.firstname, users.lastname, sum(unix_timestamp(end) - unix_timestamp(start) ) diff").where("end is not null").group("user_id").joins(:user)
    else 
      @work_items = WorkTime.select("user_id, users.firstname, users.lastname, sum(strftime('%s', end) - strftime('%s', start)) diff").where("end is not null").group("user_id").joins(:user)
    end
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
