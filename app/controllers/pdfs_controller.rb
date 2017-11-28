class PdfsController < ApplicationController
    layout 'blank_base', only: %i[pdf_header]
    def pdf_header
        # @consignment = Consignment.find(params[:consignment_id])
        # @contract = @consignment.contracts.find(params[:id])
    end

end
