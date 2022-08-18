# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :title
      t.string :description
      t.float :price
      t.string :serial_no

      t.timestamps
    end
  end
end
