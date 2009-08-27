unless RAILS_ENV.eql?("test")
  URL_FRIENDLY_NAMES = YAML.load_file(File.join(Rails.root, "config", "url_friendly_names.yml"))
else
  URL_FRIENDLY_NAMES = YAML.load_file(File.join(Rails.root, "test", "fixtures", "no_model", "mock_url_friendly_names.yml"))
end

