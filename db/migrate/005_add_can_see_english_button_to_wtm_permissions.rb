class AddCanSeeEnglishButtonToWtmPermissions < ActiveRecord::Migration
  def self.up
  	add_column :wtm_permissions, :can_see_english_button, :boolean, :default => false
  end

  def self.down
  	remove_column :wtm_permission, :can_see_english_button
  end

end
