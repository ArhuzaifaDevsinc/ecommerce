class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :items, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image
  after_commit :add_default_image, only: [:create, :update]
  def image_thumbnail
    if image.attached?
      image.variant(resize: "200x200").processed 
    else
      '/default_profile.jpg'
    end
  end
  private
  def add_default_image
    unless image.attached?
      image.attach(
        io: File.open(
          Rails.root.join(
            'app','assets','images','default_profile.jpg'
          )
        ),
        filename: 'default_avatar.jpg',
        content_type: 'image/jpg'
      )
  end
end
end
