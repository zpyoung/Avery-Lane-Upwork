class ConsignmentsController < ApplicationController
    before_action :set_s3_direct_post, only: [:new, :edit, :create, :update, :admin]
    layout 'landing', only: %i[new landing show admin]

    def index
        @consignments = Consignment.all
    end

    def show
        @consignment = Consignment.find(params[:id])
    end

    def new
        @consignment = Consignment.new
        @consignment.need_pickup = false
        @types = ['Dining or Breakfast', 'Accent Table or Desk', 'Art, Accessories or Other', 'Antiques']
        gon.types = @types;
    end

    def admin
        @consignment = Consignment.new
        @consignment.need_pickup = false
        @types = ['Dining or Breakfast', 'Accent Table or Desk', 'Art, Accessories or Other', 'Antiques']
        gon.types = @types;
    end

    def create
        @consignment = Consignment.create(consignment_params)
        respond_to do |format|
            if @consignment.save
                format.html{redirect_to consignment_path(@consignment), notice: "Items were submitted successfully!"}
                format.json { render json: @consignment }
            else
                format.html { render :new, layout: 'landing'}
                format.json { render json: @consignment.errors, status: :unprocessable_entity }
                flash[:alert] = '<span class="bolder"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> Error!&nbsp; Consignment Items Not Submitted Because: </span><br>' + @consignment.errors.full_messages.join("<br>").html_safe
            end
        end
    end

    protected

        def consignment_params
            params.require(:consignment).permit(:first_name, :last_name, :email, :phone, :need_pickup, :date_available, items_attributes: [:id, :image, :description, :item_type, :_destroy, :value, :cost, :price])
        end

    private
        def set_s3_direct_post
          @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
        end
end
