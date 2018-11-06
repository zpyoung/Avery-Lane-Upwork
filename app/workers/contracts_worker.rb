class ContractsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: 'contracts',
  unique: :until_and_while_executing

  def perform(consignment_id, contract_id, html)
    puts "STARTING CONTRACTS WORKER GENERATING CONTRACT FOR: Consignment: #{consignment_id}"
    @consignment = Consignment.find(consignment_id)
    @contract = Contract.find(contract_id)
    success = generate_pdf(@consignment, @contract, html)
    if success
      puts "SUCCESS -- FINNISHED CONTRACTS WORKER GENERATING CONTRACT FOR: Consignment: #{@consignment.id}"
    else
      puts "FAILED -- FINNISHED CONTRACTS WORKER GENERATING CONTRACT FOR: Consignment: #{@consignment.id}"
    end
  end

private

  def generate_pdf(consignment, contract, html)
   # kit = PDFKit.new(html, page_size: 'letter')
   # pdf = kit.to_pdf

    save_path = Rails.root.join('public','current_contract.pdf')
    File.open(save_path, 'w:ASCII-8BIT') do |file|
     #   file << pdf
    end
    name = "contracts/#{SecureRandom.uuid}/#{getFileName(consignment)}"
    obj = S3_BUCKET.object(name)
    success = obj.upload_file(save_path)
    obj.acl.put({acl: 'public-read'})
    if success
      @contract.update(contract_url: "https://s3-us-west-1.amazonaws.com/avery-lane/#{name}")
    end
    return success
  end

  def getFileName(consignment)
    filename ||= "#{consignment.last_name}-#{consignment.consigner_number}-contract.pdf".gsub(/[^a-zA-Z0-9_\.]/, '_')
  end

end
