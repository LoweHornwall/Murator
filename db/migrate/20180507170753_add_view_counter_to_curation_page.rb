class AddViewCounterToCurationPage < ActiveRecord::Migration[5.1]
  def change
    add_column :curation_pages, :view_count, :integer, default: 0
  end
end
