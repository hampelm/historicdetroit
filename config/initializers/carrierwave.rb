CarrierWave.configure do |config|
  secrets = Rails.application.credentials[Rails.env.to_sym]

  if secrets
    config.fog_provider = 'fog/google'
    config.fog_credentials = {
      provider: 'Google',
      google_project: secrets[:google_cloud_storage_project_name],
      google_json_key_string: secrets[:google_cloud_storage_credential_content]
    }
    config.fog_directory = secrets[:google_cloud_storage_bucket_name]
  end
end

if Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
  end
elsif Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
  end
else
  CarrierWave.configure do |config|
    config.storage = :fog
  end
end

# Suppress verbose Google Cloud Storage API debug logs
Google::Apis.logger.level = Logger::WARN
