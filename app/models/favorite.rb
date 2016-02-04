class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  default_scope { order(updated_at: :desc) }
end
