class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :participants,  dependent: :destroy
  has_many :tasks, through: :participants,  dependent: :destroy
  has_attached_file :avatar, styles: { medium: '200x200>', thumb: '30x30>' }, default_url: '/images/:attachment/missing_:style.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
end
