class User < ApplicationRecord
  include AttributeOption
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  
  validates :first_name, :last_name, presence: true
  attribute_options :role, [:admin, :user]
  
  scope :active, -> { where("deleted_at IS NULL") }
  scope :sorted, -> { order(:first_name, :last_name) }
  scope :employees, -> { where(support: false) }
  
  ransacker :full_name, formatter: proc { |v| v.mb_chars.downcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('lower', [ Arel::Nodes::NamedFunction.new('concat_ws', [ Arel::Nodes.build_quoted(' '), parent.table[:first_name], parent.table[:last_name] ])])
  end
  
  def to_s
    [first_name, last_name].select(&:present?).join(" ")
  end
  
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end
  
  def active_for_authentication?
    super && !deleted_at
  end

  def inactive_message
    !deleted_at ? super : :deleted_account
  end
end
