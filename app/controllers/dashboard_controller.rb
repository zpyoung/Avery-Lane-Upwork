require 'trello'
class DashboardController < ApplicationController
  def index
    # render
    @consignments = Consignment.all.includes(:items)

    # @data = get_trello_data
  end

  def get_trello_data
    member = Trello::Member.find("zacharyyoung9")
    boards = member.boards
    puts boards.to_json
    binding.pry
    return boards.to_json
  end

end
