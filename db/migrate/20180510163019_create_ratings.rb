class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :vote, default: 0, null: false
      t.references :ratingable, polymorphic: true, index: true
      t.references :user

      t.timestamps
    end
  end
end
