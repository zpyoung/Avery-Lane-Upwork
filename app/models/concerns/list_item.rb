module ListItem
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, uniqueness: true

    scope :sorted, -> { order(:name) }
    default_scope { sorted }
  end

  def to_s
    name
  end
end