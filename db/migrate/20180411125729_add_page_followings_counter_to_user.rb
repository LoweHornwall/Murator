class AddPageFollowingsCounterToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :page_followings_count, :integer
  end
end
