class AddPageFollowingsCounterToCurationPage < ActiveRecord::Migration[5.1]
  def change
    add_column :curation_pages, :page_followings_count, :integer
  end
end
