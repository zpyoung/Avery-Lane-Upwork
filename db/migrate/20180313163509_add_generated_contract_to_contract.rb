class AddGeneratedContractToContract < ActiveRecord::Migration[5.0]
  def self.up
    add_attachment :contracts, :generated_contract
  end

  def self.down
    remove_attachment :contracts, :generated_contract
  end
end
