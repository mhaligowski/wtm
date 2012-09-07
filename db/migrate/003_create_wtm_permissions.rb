class CreateWtmPermissions < ActiveRecord::Migration
  def change
    create_table :wtm_permissions do |t|
      t.integer :user_id
      t.boolean :can_work_remotely
      t.boolean :can_see_wtm_button
    end
  end
end
