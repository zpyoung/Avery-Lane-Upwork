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
	def edit
		@consignment = Consignment.find(params[:id])
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
				if @consignment.dashboard_modified
					format.html{redirect_to root_path, notice: "Consignment created successfully!"}
				elsif @consignment.admin_created
					format.html{redirect_to consignment_path(@consignment, admin: @consignment.admin_created), notice: "Items were submitted successfully!"}
				else
					format.html{redirect_to consignment_path(@consignment), notice: "Items were submitted successfully!"}
				end
				format.json { render json: @consignment }
			else
				format.html { render :new, layout: 'landing'}
				format.json { render json: @consignment.errors, status: :unprocessable_entity }
				flash[:alert] = '<span class="bolder"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> Error!&nbsp; Consignment Items Not Submitted Because: </span><br>' + @consignment.errors.full_messages.join("<br>").html_safe
			end
		end
	end

	def update
		@consignment = Consignment.find(params[:id])
		respond_to do |format|
			if @consignment.update(consignment_params)
				if @consignment.dashboard_modified
					format.html { redirect_to root_path, notice: "Nice! You just added updated #{@consignment.consigner_number}!" }
				else
					format.html { redirect_to root_path, notice: "Nice! You just added updated #{@consignment.consigner_number}!" }
				end
			else
				format.html { redirect_to root_path}
				format.json { render json: @consignment.errors, status: :unprocessable_entity }
				flash[:alert] = "Something wen't wrong! Please try again.."
				flash[:alert] = '<span class="bolder"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> Error!&nbsp; #{@consignment.consigner_number} Not Updated Because: </span><br>' + @consignment.errors.full_messages.join("<br>").html_safe
			end
  		end
	end

	def destroy
		@consignment = Consignment.find(params[:id])
		respond_to do |format|
			if @consignment.destroy
				format.html { redirect_to root_path }
				format.json { head :no_content }
			else
				flash[:alert] = "Something wen't wrong! Please try again.."
				flash[:alert] = '<span class="bolder"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> Error!&nbsp; Consignment Not Destroyed Because: </span><br>' + @consignment.errors.full_messages.join("<br>").html_safe
			end
		end
	end

	def duplicate_consignment
		@old_consignment = Consignment.find(params[:consignment_id])
		@new_consignment = @old_consignment.dup
		@new_consignment.updated_at = Time.now
		respond_to do |format|
		  if @new_consignment.save
			format.html { redirect_to root_path, notice: "Success! Consignment has been Duplicated!" }
		  else
			flash[:alert] = "Something wen't wrong! Please try again.."
			redirect_to root_path
		  end
		end
	end

	def change_status
		@consignment = Consignment.find(params[:consignment_id])
		sent = send_to_trello(@consignment)
		respond_to do |format|
			if sent
				format.html { redirect_to root_path, notice: "Success! Consignment has been Approved and sent to Trello!" }
			else
				flash[:alert] = "Something wen't wrong! Please try again.."
				redirect_to root_path
			end
		end
	end

	def send_to_trello(consignment)
		list = Trello::List.find(Rails.configuration.trello_approved_list_id)
		@consignment = consignment
		@consignment_items = @consignment.items.all
		card_name = "#{@consignment.first_name} #{@consignment.last_name} - #{@consignment.consigner_number}"
		card_desc = trello_card_content(@consignment, @consignment_items)
		card = Trello::Card::create(name: card_name, list_id: list.id, desc: card_desc)
		approval_tasks_checklist = Trello::Checklist::create(name: "Approval Tasks", card_id: card.id, position: 1)
		incoming_tasks_checklist = Trello::Checklist::create(name: "Incoming Tasks", card_id: card.id, position: 2)
		iventory_tasks_checklist = Trello::Checklist::create(name: "Inventory Tasks", card_id: card.id, position: 3)

		["Scedule Pick-up or Drop-off", "Add Incoming Date"].each do |item|
			approval_tasks_checklist.add_item(item)
		end
		["Items Received in Warehouse", "Tag Items with Consigner &num;'s "].each do |item|
			incoming_tasks_checklist.add_item(item)
		end
		["Inventory All Items", "Update ASSET", "Final Pricing in ASSET", "Create Item &num;'s", "Send HelloSign Contract", "Signed Contract Received"].each do |item|
			iventory_tasks_checklist.add_item(item)
		end
		if !card.id.blank?
			return true
		else
			return false
		end
	end

	def trello_card_content(consignment, consignment_items)
		rows = []

		rows << "Consignor Details"
		rows << "============"

		rows << "**Account Name:** #{consignment.first_name} #{consignment.last_name}"

		rows << "**Pickup Address:** "
		rows << "**Street 1:** #{consignment.address_1_pickup},#{ consignment.address_2_pickup} #{consignment.city_pickup}, #{consignment.state_pickup}, #{consignment.zip_pickup}"
		# rows << "**Street 2:** #{consignment.address_2_pickup}"
		# rows << "**City:** #{consignment.city_pickup}"
		# rows << "**State:** #{consignment.state_pickup}"
		# rows << "**Zip:** #{consignment.zip_pickup}"

		rows << "**Mailing Address:**"
		rows << "**Street 1:** #{consignment.address_1_mailing},#{ consignment.address_2_mailing} #{consignment.city_mailing} #{consignment.state_mailing} #{consignment.zip_mailing}"
		# rows << "**Street 2:** #{consignment.address_2_mailing}"
		# rows << "**City:** #{consignment.city_mailing}"
		# rows << "**State:** #{consignment.state_mailing}"
		# rows << "**Zip:** #{consignment.zip_mailing}"

		rows << "**Email:** #{consignment.email}"
		rows << "**Cell Phone:** #{consignment.phone}"
		rows << "**Home Phone:** #{consignment.home_phone}"
		rows << "**Number of Items:** #{consignment_items.count} Item"

		rows << "Item Details"
		rows << "============"
		if consignment_items.any?
			consignment_items.each do |item|
				rows << "#{item.item_type} - $#{item.price}"
			end
		else
			rows << "No Items Found"
		end
		rows << "Mover Details"
		rows << "============"
		rows << "**Available Dates:** #{consignment.date_available.strftime("%D - %I:%M%p") unless consignment.date_available.blank?}"
		rows << "**Items to Pick-up:**"
		if consignment_items.any?
			consignment_items.each do |item|
				rows << "#{item.item_type}"
			end
		else
			rows << "No Items Found"
		end
	    rows.join("\xA")
	end


	protected

		def consignment_params
			params.require(:consignment).permit(:first_name, :last_name, :email, :phone, :need_pickup, :date_available, :address_1_pickup, :address_2_pickup, :city_pickup, :state_pickup, :zip_pickup, :address_1_mailing, :address_2_mailing, :city_mailing, :state_mailing, :zip_mailing, :home_phone, :consigner_number, :consignment_price, :contact, :contract_additional_item, :status, :admin_created, :dashboard_modified, items_attributes: [:id, :image, :description, :item_type, :_destroy, :value, :cost, :price, :item_number, :item_status])
		end

	private
		def set_s3_direct_post
		  @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
		end
end
