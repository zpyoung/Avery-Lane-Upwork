class Item < ApplicationRecord
    belongs_to :consignment

    after_initialize :set_status , :if => :new_record?

    enum item_status: [:accepting, :not_accepting]

    private

    def set_status
        self.item_status ||= :not_accepting
    end
end
