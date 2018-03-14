class AddContractUrlToContract < ActiveRecord::Migration[5.0]
  def change
    add_column :contracts, :contract_url, :string
  end
end
