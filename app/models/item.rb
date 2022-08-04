class Item < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many_attached :images
  validate :image_type
  
  def thumbnail input
    return self.images[input].variant(resize: '300x300!').processed
  end
  private
  def image_type
    if images.attached? == false
      errors.add(:images, 'are missing!')
    end
    images.each do |image|
      if !image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:images,' format must be JPEG or PNG')
      end
    end
  end
end
