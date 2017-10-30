class AddRoleToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :support, :boolean, default: false, null: false
    add_column :users, :role, :string
    User.reset_column_information
    User.update_all(role: User::Role::ADMIN)
  end
  
  def down
    remove_column :users, :role
  end
end
