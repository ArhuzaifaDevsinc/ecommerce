class Item < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search, against: :title
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many_attached :images, dependent: :destroy
  validate :image_type
  validates :serial_no, uniqueness: true
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
