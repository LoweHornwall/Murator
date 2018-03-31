class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.text :content
      t.integer :rating, default: 10
      t.references :curation_page, foreign_key: true

      t.timestamps
    end
  end
end
