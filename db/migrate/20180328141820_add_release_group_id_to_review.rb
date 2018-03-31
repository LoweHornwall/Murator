class AddReleaseGroupIdToReview < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :release_group_id, :integer
    remove_index :reviews, :curation_page_id
    add_index :reviews, [:curation_page_id, :release_group_id], unique: true
  end
end
