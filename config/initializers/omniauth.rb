OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '1077948300645-es82b0b8nsep5hbo9aku6m23r0o3ce10.apps.googleusercontent.com', '91lbti7mDlmQFQcjTicxTu-W', {skip_jwt: true, client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end