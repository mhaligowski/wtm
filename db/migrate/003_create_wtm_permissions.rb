class CreateWtmPermissions < ActiveRecord::Migration
  def change
    create_table :wtm_permissions do |t|
      t.integer :user_id
      t.boolean :can_work_remotely, :default => false
      t.boolean :can_see_wtm_button, :default => false
		end
  end
end
