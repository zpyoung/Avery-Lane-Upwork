class Item < ApplicationRecord
    belongs_to :consignment
    before_validation :strip_commas_from_price_cost

    after_initialize :set_status , :if => :new_record?

    enum item_status: [:accepting, :not_accepting]

    ITEM_TYPES = [
    'Accessories',
    'Armchair',
    'Art - Sculptural	',
    'Art - Wall',
    'Bed - Full',
    'Bed - King',
    'Bed - Queen',
    'Bed - Twin',
    'Bench',
    'Buffet',
    'Chair',
    'Chandelier',
    'Chest of Drawers',
    'China Cabinet',
    'Desk',
    'Dining Set - 4 Chairs',
    'Dining Set - 6+ Chairs',
    'Display Cabinet',
    'Dresser',
    'Lamp - Floor',
    'Lamp - Table',
    'Loveseat',
    'Nightstand',
    'Office Credenza',
    'Ottoman',
    'Patio - Chaise Lounge',
    'Patio - Club Chair',
    'Patio - Coffee/End Table',
    'Patio - Dining Set, 4 Chairs',
    'Patio - Dining Set, 6+ Chairs',
    'Patio - Loveseat',
    'Patio - Ottoman',
    'Patio - Sofa',
    'Rug',
    'Sectional Sofa',
    'Sofa',
    'Table - Coffee',
    'Table - End/Side',
    'Table - Sofa',
    'OTHER']

    def strip_commas_from_price_cost
      self.price = price_before_type_cast.to_s.gsub(/,/, '').to_f
    #   self.cost = cost_before_type_cast.to_s.gsub(/,/, '').to_f
    end

    private

    def set_status
        self.item_status ||= :not_accepting
    end
end
