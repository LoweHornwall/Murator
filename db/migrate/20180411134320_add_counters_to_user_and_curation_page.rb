class AddCountersToUserAndCurationPage < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :curation_pages_count, :integer, default: 0
    add_column :curation_pages, :reviews_count, :integer, default: 0
  end
end
