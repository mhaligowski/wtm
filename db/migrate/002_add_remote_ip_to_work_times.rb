class AddRemoteIpToWorkTimes < ActiveRecord::Migration
  def self.up
  	add_column :work_times, :remoteip, :string, :default => "0.0.0.0"
  end

  def self.down
  	remove_column :work_times, :remoteip
  end
end
