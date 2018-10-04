class ConsignmentWorker < ApplicationController
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(consignment_id)
        puts "SIDEKIQ WORKER STARTING TO ADD CONSIGNMENT TO TRELLO"
        #Get Consignment
        @consignment = Consignment.find(consignment_id)
        @contract = @consignment.contracts.first

        #Create PDF Contract
        # contract_url = generate_pdf(@consignment, @contract)
        # Send to Trello List
        uploaded = send_to_trello(@consignment)
        # Update consignment based on upload result
        if uploaded[:sent] === true
            @consignment.update(listed: true)
        else
            @consignment.update(listed: false)
        end
    end

    def generate_pdf(consignment)
        ac = ActionController::Base.new()
        html = ac.render_to_string(:layout => 'contract_base' , :action => :show, controller: :contracts)
        kit = PDFKit.new(html, page_size: 'letter')
        pdf = kit.to_pdf

        save_path = Rails.root.join('public','current_contract.pdf')
            File.open(save_path, 'w:ASCII-8BIT') do |file|
            file << pdf
        end
    end

    def send_to_trello(consignment)
        list = Trello::List.find(Rails.configuration.trello_approved_list_id)
        @consignment = consignment
        @consignment_items = @consignment.items.all
        @consignment.trello_status = true
        card_name = "#{@consignment.first_name} #{@consignment.last_name} - #{@consignment.consigner_number}"
        card_desc = trello_card_content(@consignment, @consignment_items)
        card = Trello::Card::create(name: card_name, list_id: list.id, desc: card_desc)
        approval_tasks_checklist = Trello::Checklist::create(name: "Approval Tasks", card_id: card.id, position: 1)
        incoming_tasks_checklist = Trello::Checklist::create(name: "Incoming Tasks", card_id: card.id, position: 2)
        iventory_tasks_checklist = Trello::Checklist::create(name: "Inventory Tasks", card_id: card.id, position: 3)

        #Add attachments
        @consignment_items.each do |item|
            if item.accepting?
                card.add_attachment("https:#{item.image}", "#{item.item_type}")
            end
        end

        card.add_attachment("#{Rails.root.join('public','current_contract.pdf')}", "consignment-contract")

        ["Scedule Pick-up or Drop-off", "Add Incoming Date"].each do |item|
            approval_tasks_checklist.add_item(item)
        end
        ["Items Received in Warehouse", "Tag Items with Consigner Number's "].each do |item|
            incoming_tasks_checklist.add_item(item)
        end
        ["Inventory All Items", "Update ASSET", "Final Pricing in ASSET", "Create Item Number's", "Send HelloSign Contract", "Signed Contract Received"].each do |item|
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

        rows << "**Mailing Address:**"
        rows << "**Street 1:** #{consignment.address_1_mailing},#{ consignment.address_2_mailing} #{consignment.city_mailing} #{consignment.state_mailing} #{consignment.zip_mailing}"

        rows << "**Email:** #{consignment.email}"
        rows << "**Cell Phone:** #{consignment.phone}"
        rows << "**Home Phone:** #{consignment.home_phone}"
        rows << "**Number of Items:** #{consignment_items.count} Item"

        rows << "Item Details"
        rows << "============"
        if consignment_items.any?
            consignment_items.each do |item|
                if item.accepting?
                    rows << "#{item.item_type} - $#{item.price}"
                end
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
                if item.accepting?
                    rows << "#{item.item_type}"
                end
            end
        else
            rows << "No Items Found"
        end
        rows.join("\xA")
    end
end
