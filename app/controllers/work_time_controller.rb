class WorkTimeController < ApplicationController
  unloadable

  before_filter :require_login

  def index
  	@work_items = WorkTime.all
  end

  def toggle
  	puts "toggle"

  	respond_to do |format|
  		format.js { render :layout => false }
  	end
  end
end
