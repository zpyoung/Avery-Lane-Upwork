# class ContractPdf < Prawn::Document
#   def initialize(consignment, view)
#     super(top_margin: 70)
#     @consignment = consignment
#     @view = view
#     image_header
#     order_number
#     # line_items
#     # total_price
#   end
#
#   def image_header
#     image  "#{Rails.root}/images/averylane-logo.png", :position => :center
#   end
#   def order_number
#     text "test"
#   end
#
#   # def line_items
#   #   move_down 20
#   #   table line_item_rows do
#   #     row(0).font_style = :bold
#   #     columns(1..3).align = :right
#   #     self.row_colors = ["DDDDDD", "FFFFFF"]
#   #     self.header = true
#   #   end
#   # end
#   #
#   # def line_item_rows
#   #   [["Product", "Qty", "Unit Price", "Full Price"]] +
#   #   @order.line_items.map do |item|
#   #     [item.name, item.quantity, price(item.unit_price), price(item.full_price)]
#   #   end
#   # end
#   #
#   # def price(num)
#   #   @view.number_to_currency(num)
#   # end
#   #
#   # def total_price
#   #   move_down 15
#   #   text "Total Price: #{price(@order.total_price)}", size: 16, style: :bold
#   # end
# end
