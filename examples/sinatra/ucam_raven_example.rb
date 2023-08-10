class UcamRavenExample < Sinatra::Base
  use Rack::Session::Cookie, key: 'ucam_raven_example', expire_after: 300, secret: 'donotassumethisissecret'

  OmniAuth.config.allowed_request_methods = [:post, :get]
  OmniAuth.config.silence_get_warning = true
  use OmniAuth::Builder do
    options = {
      desc: 'Ucam-Raven OmniAuth Strategy - Sinatra Demo',
      msg: 'you are testing login authorisation',
      params: 'This string will always get returned from WLS to WAA',
      date: true
    }
    provider 'ucam-raven', File.join(Dir.pwd, "..", "certs"), options
  end

  get '/' do
    redirect '/auth/ucam-raven'
  end

  get '/auth/:provider/callback' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect
  rescue
    "No data"
  end

  get '/auth/failure' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect
  rescue
    "No data"
  end
end
