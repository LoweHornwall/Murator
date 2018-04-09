class CreatePageFollowings < ActiveRecord::Migration[5.1]
  def change
    create_table :page_followings do |t|
      t.references :user, foreign_key: true
      t.references :curation_page, foreign_key: true

      t.timestamps
    end
    add_index :page_followings, [:user_id, :curation_page_id], unique: true
  end
end
