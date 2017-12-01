class ItemsController < ApplicationController
    before_action :set_s3_direct_post

    def new
        @consignment = Consignment.find(params[:consignment_id])
        @item = Item.new
        @types = ['Dining or Breakfast', 'Accent Table or Desk', 'Art, Accessories or Other', 'Antiques']
        gon.types = @types;
    end

    def create
        @consignment = Consignment.find(params[:consignment_id])
        if params[:item_image] && params[:item_description] && params[:item_item_type]
            params[:item_image].each_with_index do |item, index|
                @item = @consignment.items.create(image: params[:item_image][index], description: params[:item_description][index], item_type: params[:item_item_type][index])
                @item.save
            end
            saved = true
        else
            saved = false
        end

        respond_to do |format|
            if saved
                format.html{redirect_to edit_consignment_path(@consignment), notice: "Items Added to Consignment Successfully!"}
            else
                format.html{redirect_to edit_consignment_path(@consignment), alert: "Something went wrong, please fill out all fields and try again."}
            end
        end
    end

    def destroy
        @consignment = Consignment.find(params[:consignment_id])
        @item = @consignment.items.find(params[:id])
        respond_to do |format|
            if @item.destroy
                format.html { redirect_to edit_consignment_path(@consignment), notice: "Item was deleted successfully!"}
                format.json { head :no_content }
    			format.js   { render :layout => false }
            else
                format.html{redirect_to edit_consignment_path(@consignment), alert: "Something went wrong, please try again."}
            end
        end

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
