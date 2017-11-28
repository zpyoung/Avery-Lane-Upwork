class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
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
      t.datetime :experation_date

      t.timestamps
    end
  end
end
