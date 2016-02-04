class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # This does not allow user.save to return true when the name is blank.
  validates :name, presence: true
  mount_uploader :avatar, AvatarUploader
  has_many :my_threads, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  default_scope { order(updated_at: :desc) }

  after_destroy do
    Follow.where(followee_id: self.id).destroy_all
    Follow.where(follower_id: self.id).destroy_all
  end
end
