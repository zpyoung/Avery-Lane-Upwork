require 'trello'
class DashboardController < ApplicationController
  def index
    # render
    @consignments = Consignment.all.includes(:items)

    # @data = get_trello_data
  end

  def get_trello_data
    member = Trello::Member.find("averylanehome")
    boards = member.boards
    puts boards.to_json
    return boards.to_json
  end

end
