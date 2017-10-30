module Ransack
  module Helpers
    module FormHelper
      class SortLink
        def order_indicator
          if @hide_indicator || no_sort_direction_specified?
            ApplicationController.helpers.fa_icon("sort")
          else
            direction_arrow
          end
        end

        def direction_arrow
          if @current_dir == "desc".freeze
            ApplicationController.helpers.fa_icon("sort-desc")
          else
            ApplicationController.helpers.fa_icon("sort-asc")
          end
        end
      end
    end
  end
end