class Consignment < ApplicationRecord
    has_many :items, inverse_of: :consignment
    accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
    validates :phone, presence: true
    validates :date_available, presence: true

end
