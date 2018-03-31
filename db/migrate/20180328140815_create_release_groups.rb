class CreateReleaseGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :release_groups do |t|
      t.string :rgid
      t.string :release
      t.string :artist

      t.timestamps
    end
    add_index :release_groups, :rgid, unique: true
    add_index :release_groups, :release
    add_index :release_groups, :artist
  end
end
