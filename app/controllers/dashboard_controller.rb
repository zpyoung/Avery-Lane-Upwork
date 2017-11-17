class DashboardController < ApplicationController
  def index
    # render
    @consignments = Consignment.all
  end
end
