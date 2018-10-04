class AddTrelloStatusToConsignment < ActiveRecord::Migration[5.0]
  def change
    add_column :consignments, :trello_status, :boolean, default: false
  end
end
