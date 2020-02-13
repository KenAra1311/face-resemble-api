class AddColumnPosts < ActiveRecord::Migration[6.0]
  def up
    add_column :posts, :emotion, :string
  end

  def down
    remove_column :posts, :emotion, :string
  end
end
