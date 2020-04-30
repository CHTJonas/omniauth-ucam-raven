class UcamRavenExample < Sinatra::Base
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    opts = {
      desc: 'Ucam-Raven Omniauth Strategy - Sinatra Demo',
      msg: 'you are testing login authorisation',
      params: 'This string will always get returned from WLS to WAA.',
      date: true
    }
    provider :ucamraven, 2, "/Users/charlie/Downloads/pubkey2", opts
  end

  get '/' do
    redirect '/auth/ucamraven'
  end

  get '/auth/:provider/callback' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect
  rescue
    "No Data"
  end

  get '/auth/failure' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect
  rescue
    "No Data"
  end
end
