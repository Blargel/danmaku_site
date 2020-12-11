class S3UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    bucket          = ENV['AWS_BUCKET']
    access_key_id   = ENV['AWS_ACCESS_KEY_ID']
    acl             = 'public-read'
    secret_key      = ENV['AWS_SECRET_ACCESS_KEY']
    key             = params[:key]
    content_type    = params[:content_type]
    https           = 'false'
    error_message   = ''
    expiration_date = 1.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')

    policy = Base64.encode64(
      <<~POLICY
        {
          'expiration': '#{expiration_date}',
          'conditions': [
            {'bucket': '#{bucket}'},
            {'key': '#{key}'},
            {'acl': '#{acl}'},
            {'Content-Type': '#{content_type}'},
            {'Content-Disposition': 'attachment'},
            ['starts-with', '$Filename', ''],
            ['eq', '$success_action_status', '201']
          ]
        }
      POLICY
    ).gsub(/\n|\r/, '')

    signature = Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        secret_key, policy
      )
    ).gsub("\n", '')

    respond_to do |format|
      format.xml do
        render xml: {
          policy: policy,
          signature: signature,
          bucket: bucket,
          accesskeyid: access_key_id,
          acl: acl,
          expirationdate: expiration_date,
          https: https,
          errorMessage: error_message.to_s
        }.to_xml
      end
    end
  end
end
