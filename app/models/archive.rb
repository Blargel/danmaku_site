class Archive < Asset
  # has_one_attached :attachment

  before_destroy :destroy_s3_data
  MAX_FILE_SIZE = '300 MB'

  def import_s3_data
    s3_archive = find_s3_archive
    s3_data = s3_archive.about

    self.attachment_content_type = s3_archive.content_type
    self.attachment_file_size = s3_archive.content_length
    self.attachment_updated_at = s3_archive.last_modified
  end

  def attachment_url
    s3_archive.public_url
  end

  def destroy_s3_data
    s3_archive.delete if s3_archive.exists?
  end

  private

  def s3
    @s3 ||= Aws::S3::Resource.new(region: region)
  end

  def region
    ENV['AWS_REGION'] || 'us-east-1'
  end

  def bucket
    @bucket ||= s3.bucket(ENV['AWS_BUCKET'])
  end

  def s3_archive
    @s3_archive ||= bucket.object(s3_key)
  end
end
