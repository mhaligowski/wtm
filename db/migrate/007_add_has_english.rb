class AddHasEnglish < ActiveRecord::Migration
  def self.up
  	add_column :work_times, :has_english, :boolean, :default => false
  end

  def self.down
  	remove_column :work_time, :has_english
  end

end
