CarrierWave.configure do |config|
  secrets = Rails.application.credentials[Rails.env.to_sym]
  config.fog_provider = 'fog/google'
  config.fog_credentials = {
    provider: 'Google',
    google_project: secrets[:google_cloud_storage_project_name],
    google_json_key_string: secrets[:google_cloud_storage_credential_content]
  }
  config.fog_directory = secrets[:google_cloud_storage_bucket_name]
end

if Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
  end
end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
  end
end
