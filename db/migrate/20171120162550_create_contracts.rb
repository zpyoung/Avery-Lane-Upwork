class CreateContracts < ActiveRecord::Migration[5.0]
  def change
    create_table :contracts do |t|
      t.references :consignment
      t.integer :contract_type
      t.text :intro
      t.text :terms_and_conditions
      t.text :systematic_price_reductions
      t.text :optional_extension
      t.text :end_of_agreement
      t.text :note
      t.text :payment_to_consignor
      t.text :insurance
      t.text :additional_notes
      t.text :accepted_items, array: true, default: []
      t.text :rejected_items, array: true, default: []
      t.datetime :experation_date
      t.integer :contract_status

      t.timestamps
    end
  end
end
