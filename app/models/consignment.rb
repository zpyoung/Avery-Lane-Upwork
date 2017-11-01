class Consignment < ApplicationRecord
    has_many :items, inverse_of: :consignment
    accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
    validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
    validates :phone, presence: true
    validates :date_available, presence: true
    validates :need_pickup, inclusion: { in: [ true, false ] }

end
