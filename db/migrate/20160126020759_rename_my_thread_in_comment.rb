class RenameMyThreadInComment < ActiveRecord::Migration
  def change
    rename_column :comments, :my_thread_id, :my_thread_id
  end
end
