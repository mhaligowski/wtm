class WtmPermission < ActiveRecord::Base
  unloadable

  belongs_to :user
end
