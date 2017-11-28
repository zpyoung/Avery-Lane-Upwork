class ChangeTermsTypeInContracts < ActiveRecord::Migration[5.0]
  def change
      add_column :contracts, :terms_and_conditions_list, :text, array: true, default: []
      add_column :settings, :terms_and_conditions_list, :text, array: true, default: []
  end
end
