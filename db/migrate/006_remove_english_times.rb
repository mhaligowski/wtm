class RemoveEnglishTimes < ActiveRecord::Migration
  def change
  	drop_table :english_times
  end

end
