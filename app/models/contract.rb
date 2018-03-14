class Contract < ApplicationRecord
    belongs_to :consignment

    has_attached_file :generated_contract
end
