require 'netaddr'
require 'date'

class WorkTimeController < ApplicationController
  unloadable

  before_filter :require_login, :get_settings

  helper :sort
  include SortHelper

  def get_settings
    @settings = Setting.plugin_wtm
  end

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
    sort_init [ %w( lastname ) ]
    sort_update %w( lastname )

    @from = params[:from].nil? ? Date.today.at_beginning_of_month : params[:from]
    @to = params[:to].nil? ? Date.today.at_end_of_month : params[:to]

    # time entries
    @time_entries = TimeEntry.select("user_id, issues.subject, hours, spent_on")
    @time_entries = @time_entries.where(:created_on => @from..@to)
    if !params[:user_id].nil? and !params[:user_id].blank?
      @work_items = @time_entries.where(:user_id => params[:user_id])
    end
    @time_entries = @time_entries.joins(:issue)

    # work items
    if ActiveRecord::Base.connection.adapter_name == 'MySQL'
      @work_items = WorkTime.select("user_id, users.firstname, users.lastname lastname, sum(unix_timestamp(end) - unix_timestamp(start) ) diff")
    else 
      @work_items = WorkTime.select("user_id, users.firstname, users.lastname lastname, sum(strftime('%s', end) - strftime('%s', start)) diff")
    end

    @work_items = @work_items.where("end is not null")
    @work_items = @work_items.where(:start => @from..@to)
    if !params[:user_id].nil? and !params[:user_id].blank?
      @work_items = @work_items.where(:user_id => params[:user_id])
    end
    @work_items = @work_items.group("user_id")
    @work_items = @work_items.joins(:user)
    @work_items = @work_items.order sort_clause

    @work_items
  end

  def toggle
  	user = User.current

  	@wt = WorkTime.current(user)

    # list of IPs that are allowed
    ips = NetAddr.merge(
      @settings['local_ip_pattern'].split(",").map { |ip|  NetAddr::CIDR.create(ip) },
      :Objectify => true
    )

    # the current IP is on the list?
    is_ip_allowed = false
    ips.each do |ip| 
      if 
        ip.contains? request.remote_ip 
      then
        is_ip_allowed = true
        break
      end
    end

    # check if user can work remotely
    if !user.can_work_remotely? && !is_ip_allowed
      respond_to do |format|
        format.js {
          render 'work_time/error', :layout => false
        }
      end
      return
    end

  	# not started
  	if @wt.nil?
  		@wt = WorkTime.create(
  		  :user_id => user.id,
  			:start => DateTime.current(),
        :remoteip => request.remote_ip
      )
  	else
  		# if started, just set the end date
  		@wt.end = DateTime.current()
  		@wt.save!
  	end 

  	respond_to do |format|
  		format.js { render :layout => false }
  	end
  end

  def update
    Time.zone = User.current.time_zone

    begin
      @work_time = WorkTime.find(params[:id])
      @work_time.start = Time.parse(params[:start]) if params[:start]
      @work_time.end = Time.parse(params[:end]) if params[:end]
      @work_time.save!
    rescue
      @error = "Nieprawidłowa wartość!"
    end
  end

  def english_toggle
    @wt = WorkTime.find(params[:id])
    if User.current.can_see_english_button?
      @wt.has_english = true
      @wt.save!
    end

    respond_to do |format|
      format.js { render "toggle", :layout => false}
    end
  end
end
