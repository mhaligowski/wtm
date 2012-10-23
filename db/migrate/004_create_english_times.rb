class CreateEnglishTimes < ActiveRecord::Migration
  def change
    create_table :english_times do |t|
      t.integer :user_id
      t.datetime :start
      t.datetime :end
    end
  end
end
