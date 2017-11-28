class ItemsController < ApplicationController
    before_action :set_s3_direct_post

    def new
        @consignment = Consignment.find(params[:consignment_id])
        @item = Item.new
        @types = ['Dining or Breakfast', 'Accent Table or Desk', 'Art, Accessories or Other', 'Antiques']
        gon.types = @types;
    end

    def create
        # binding.prys
        @consignment = Consignment.find(params[:consignment_id])
        params[:item_image].each_with_index do |item, index|
            @item = @consignment.items.create(image: params[:item_image][index], description: params[:item_description][index], item_type: params[:item_item_type][index], price: params[:item_price][index])
        end

        # @item = @consignment.items.create(item_params)
        respond_to do |format|
            if @item.save
                format.html{redirect_to edit_consignment_path(@consignment), notice: "Items Added to Consignment Successfully!"}
            else
                format.html{redirect_to edit_consignment_path(@consignment), alert: "Something went wrong, please try again."}
            end
        end
    end

    def destroy
        @consignment = Consignment.find(params[:consignment_id])
        @item = @consignment.items.find(params[:id])
        @item.destroy
    end

    protected

        def item_params
            params.require(:item).permit(:image, :description, :item_type, :_destroy, :value, :cost, :price, :item_number, :item_status)
        end

    private
        def set_s3_direct_post
          @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
        end
end
