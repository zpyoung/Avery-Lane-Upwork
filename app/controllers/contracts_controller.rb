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

    def check_contract_updated
        @contract = Contract.find(params[:contract])
        updated = @contract.contract_url.present?
        puts "$$$$$$$$$$$$$$$$$$ #{updated}"
        respond_to do |format|
            format.json {render json: {updated: updated, url: @contract.contract_url}}
        end
    end

    def show
        @consignment = Consignment.find(params[:consignment_id])
        @contract = @consignment.contracts.first
        html = render_to_string(:show)
        @contract.update(contract_url: nil)
        contract = ContractsWorker.perform_async(@consignment.id, @contract.id, html)
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
