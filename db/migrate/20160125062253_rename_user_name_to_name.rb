class RenameUserNameToName < ActiveRecord::Migration
  def change
    rename_column :users, :name, :name
  end
end
