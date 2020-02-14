class AddCountToPosts < ActiveRecord::Migration[6.0]
  def up
    add_column :posts, :count, :integer
  end

  def down
    remove_column :posts, :count, :integer
  end
end
