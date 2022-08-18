# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :description, presence: true
end
