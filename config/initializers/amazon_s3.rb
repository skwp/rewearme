AWS::S3::Base.establish_connection!(
  :access_key_id     => ENV["amazon_access_key_id"],
  :secret_access_key => ENV["secret_access_key"]
)
