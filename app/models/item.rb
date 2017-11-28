class Item < ApplicationRecord
    belongs_to :consignment
    before_validation :strip_commas_from_price_cost

    after_initialize :set_status , :if => :new_record?

    enum item_status: [:accepting, :not_accepting]

    def strip_commas_from_price_cost
      self.price = price_before_type_cast.to_s.gsub(/,/, '').to_f
    #   self.cost = cost_before_type_cast.to_s.gsub(/,/, '').to_f
    end

    private

    def set_status
        self.item_status ||= :not_accepting
    end
end
