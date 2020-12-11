class Image < Asset
  has_attached_file :attachment,
    :styles => {
      :normal => "400x300>",
      :thumb => "160x120>"
    },
    :storage => :s3,
    :s3_credentials => {
      :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :bucket => ENV['AWS_BUCKET'],
      :s3_region => ENV['AWS_REGION']
    },
    :path => "/images/:id/:style.:extension"

  validates_attachment_content_type :attachment, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def url(style=:normal)
    attachment.url(style).gsub("http://", "https://")
  end
end
