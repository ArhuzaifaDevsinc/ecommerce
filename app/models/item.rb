# frozen_string_literal: true

class Item < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search, against: :title
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many_attached :images, dependent: :destroy
  validate :image_type
  validates :serial_no, uniqueness: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true

  def thumbnail(input)
    images[input].variant(resize: '300x300!').processed
  end

  private

  def image_type
    errors.add(:images, 'are missing!') if images.attached? == false
    images.each do |image|
      errors.add(:images, ' format must be JPEG or PNG') unless image.content_type.in?(%('image/jpeg image/png'))
    end
  end
end
