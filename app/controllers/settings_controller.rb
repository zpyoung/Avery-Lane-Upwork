class SettingsController < ApplicationController

    def new
        @settings = Setting.new
    end

    def edit
        @settings = Setting.first
    end

    def create
        @settings = Setting.build(settings_params)
        @settings.save
    end

    def update
        @settings = Setting.find(params[:id])
        respond_to do |format|
            if @settings.update(settings_params)
                format.html {redirect_to edit_setting_path(@settings), notice: "Nice! You just updated the default settings."}
                format.json { render json: @settings }
            else
                format.html { edirect_to edit_setting_path(@settings)}
    			format.json { render json: @settings.errors, status: :unprocessable_entity }
    			flash[:alert] = "Something wen't wrong! Please try again.."
    			flash[:alert] = '<span class="bolder"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> Error!&nbsp; Settings not updated because: </span><br>' + @settings.errors.full_messages.join("<br>").html_safe
            end
        end
    end

    protected
        def settings_params
            params.require(:setting).permit(:contract_type, :intro, :systematic_price_reductions, :optional_extension, :end_of_agreement, :note, :payment_to_consignor, :insurance, :additional_notes, :experation_date, :contract_status, terms_and_conditions_list: [])
        end
end
