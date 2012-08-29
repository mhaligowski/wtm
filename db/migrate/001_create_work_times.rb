class CreateWorkTimes < ActiveRecord::Migration
  def change
    create_table :work_times do |t|
      t.integer :user
      t.datetime :start
      t.datetime :end
    end
  end
end
