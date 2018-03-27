class CreateCurationPages < ActiveRecord::Migration[5.1]
  def change
    create_table :curation_pages do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :curation_pages, :name, unique: true
  end
end
