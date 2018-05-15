class CreateJoinTableCurationPageCategory < ActiveRecord::Migration[5.1]
  def change
    create_join_table :curation_pages, :categories do |t|
      t.index [:curation_page_id, :category_id], name: :curation_page_category_id, unique: true
    end
  end
end
