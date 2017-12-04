class ContractsController < ApplicationController
    layout 'contract_base', only: %i[show]

    def new
        @contract = Contract.new
        @consignment = Consignment.find(params[:consignment_id])
    end

    def edit
        @consignment = Consignment.find(params[:consignment_id])
        @contract = @consignment.contracts.find(params[:id])
    end

    def show
        @consignment = Consignment.find(params[:consignment_id])
        @contract = @consignment.contracts.first
        pdf = generate_pdf(@contract, @consignment)
        # add = S3Store.new(pdf).store
        # binding.pry
    end

    # def generate_pdf
    #     html = render_to_string(:show)
    #     kit = PDFKit.new(html, page_size: 'letter')
    #     pdf = kit.to_pdf
    #     # puts pdf
    #     return pdf
    # end

    def generate_pdf(contract, consignment)
        html = render_to_string(:show)
        kit = PDFKit.new(html, page_size: 'letter')
        pdf = kit.to_pdf

        # save_path = Rails.root.join('public','current_contract.pdf')
        #     File.open(save_path, 'w:ASCII-8BIT') do |file|
        #     file << pdf
        # end
        send_data(pdf,
        filename: "#{getFileName(consignment)}",
        disposition: 'attachment',
        type: :pdf)
    end


    def create
        @consignment = Consignment.find(params[:consignment_id])
        @contract = @consignment.contracts.create(contract_params)
        respond_to do |format|
			if @contract.save
                format.html{redirect_to root_path, notice: "Contract created successfully!"}
				format.json { render json: @contract }
			else
				format.html { render :new, layout: 'landing'}
				format.json { render json: @contract.errors, status: :unprocessable_entity }
				flash[:alert] = '<span class="bolder"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> Error!&nbsp; Contract Not Submitted Because: </span><br>' + @contract.errors.full_messages.join("<br>").html_safe
			end
		end
    end
    def update
        @consignment = Consignment.find(params[:consignment_id])
        @contract = @consignment.contracts.find(params[:id])
        respond_to do |format|
            if @contract.update(contract_params)
                format.html { redirect_to root_path, notice: "Nice! You just added updated the contract for #{@consignment.consigner_number}!" }
            else
                format.html { redirect_to root_path}
				format.json { render json: @contract.errors, status: :unprocessable_entity }
				flash[:alert] = "Something wen't wrong! Please try again.."
				flash[:alert] = '<span class="bolder"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> Error!&nbsp; Contract Not Updated Because: </span><br>' + @contract.errors.full_messages.join("<br>").html_safe
            end
        end
    end
    def destroy
        @consignment = Consignment.find(params[:consignment_id])
        @contract = @consignment.contracts.find(params[:id])
        respond_to do |format|
			if @contract.destroy
				format.html { redirect_to root_path }
				format.json { head :no_content }
			else
				flash[:alert] = "Something wen't wrong! Please try again.."
				flash[:alert] = '<span class="bolder"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> Error!&nbsp; Contract Not Destroyed Because: </span><br>' + @contract.errors.full_messages.join("<br>").html_safe
			end
		end
    end

    protected

        def getFileName(consignment)
          filename ||= "#{consignment.last_name}-#{consignment.consigner_number}-contract.pdf".gsub(/[^a-zA-Z0-9_\.]/, '_')
        end

        def contract_params
            params.require(:contract).permit(:contract_type, :intro, :systematic_price_reductions, :optional_extension, :end_of_agreement, :note, :payment_to_consignor, :insurance, :additional_notes, :experation_date, :contract_status, accepted_items: [], rejected_items: [], terms_and_conditions_list: [])
        end
end
