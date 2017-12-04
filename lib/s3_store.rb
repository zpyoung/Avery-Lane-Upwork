class S3Store
  BUCKET = "app-uploads".freeze

  def initialize file
    @file = file
    # @s3 = AWS::S3.new
    @bucket = S3_BUCKET
  end

  def store
    # @obj = @bucket.objects[filename].write(file: @file, acl: :public_read)
    @obj = @bucket.objects["uploads/#{SecureRandom.uuid}/${filename}"].write(file: @file, success_action_status: '201', acl: 'public-read')
    self
  end

  def url
    @obj.public_url.to_s
  end

  private

  def filename
    @filename ||= "contract.pdf".gsub(/[^a-zA-Z0-9_\.]/, '_')
  end
end
