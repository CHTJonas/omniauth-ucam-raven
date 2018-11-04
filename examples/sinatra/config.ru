require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'omniauth-ucam-raven'
require 'uri'

class UcamRavenExample < Sinatra::Base
  use Rack::Session::Cookie

  get '/' do
    redirect '/auth/ucam-raven'
  end

  get '/auth/:provider/callback' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end

  get '/auth/failure' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end

  use OmniAuth::Builder do
    provider OmniAuth::Strategies::UcamRaven, 2, "/Users/charlie/Downloads/pubkey2", {desc: 'Ucam-Raven Omniauth Strategy - Sinatra Demo', msg: 'you are testing login authorisation', params: 'This string will always get returned from WLS to WAA.', date: true }
  end
end

run UcamRavenExample.run!
