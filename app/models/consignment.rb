class Consignment < ApplicationRecord
    has_many :items, inverse_of: :consignment
    has_many :contracts, inverse_of: :consignment
    accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
    after_initialize :set_status , :if => :new_record?

    enum status: [:new_consignment, :approved, :partially_approved, :rejected, :needs_contract]

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
    validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
    validates :phone, presence: true
    validates :date_available, presence: true
    validates :need_pickup, inclusion: { in: [ true, false ] }

    validates :email, presence: true

    validates :address_1_mailing, presence: true
    validates :city_mailing, presence: true
    validates :state_mailing, presence: true
    validates :zip_mailing, presence: true

    private

    def set_status
        self.status ||= :new_consignment
    end


end
