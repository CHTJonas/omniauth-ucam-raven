> **Warning**
> If you are viewing this README on the `main` branch then please note that this may contain as yet unreleased changes.
> You probably want to checkout a tag using the GitHub interface and view documentation for that specific version.

# Raven OmniAuth strategy

This Ruby gem provides an OmniAuth strategy for authenticating using the [Raven SSO System](https://raven.cam.ac.uk), provided by the University of Cambridge.

## Installation

Add the strategy to your `Gemfile`:

```ruby
gem 'omniauth-ucam-raven'
```

And then run `bundle install`.

You then need to download the Raven service RSA public key(s) in PEM format from ~the project pages [here](https://raven.cam.ac.uk/project/keys/)~ the mirror [here](https://w3.charliejonas.co.uk/mirror/raven/keys/) and store it somewhere that is not writable by your web application. Tip: it's the one without the `.crt` file extension.

## Usage

The strategy expects a path to the directory where you store your Raven public key(s).
This allows multiple keys to be supported in order to facilitate rollover or multiple backend auth servers.

If you're using Rails, you'll want to add the following to an initialisers e.g. `config/initializers/omniauth.rb` and then restart your application server:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider "ucam-raven", Rails.root.join("vendor", "ucam-raven-public-keys")
end
```

For Sinatra and other Rack-based frameworks, you can integrate the strategy into your middleware e.g. in a `config.ru`:

```ruby
use OmniAuth::Builder do
  provider "ucam-raven", '/path/to/keys/dir'
end
```

Upon authentication, the user's details will be available in the `request.env['omniauth.auth']` object as show in the example below. Each field is well documented in the [protocol specification](https://w3.charliejonas.co.uk/mirror/raven/waa2wls-protocol.txt).

```
{
  "provider"=>"ucam-raven",
  "uid"=>"crsid",
  "info"=>{"name"=>nil, "ptags"=>["current"]},
  "credentials"=>{"auth"=>"", "sso"=>["pwd"]},
  "extra"=>{"id"=>"dateandtime", "lifetime"=>"sessionlifetime", "parameters"=>"your params string returned to you"}
}
```

When prototyping you application, you may find it helpful to add the following line of code, otherwise GET requests to the application authentication URL won't work.

```ruby
OmniAuth.config.allowed_request_methods = [:post, :get]
```

## Configuration

The Ucam-Raven strategy will work straight out of the box but you can apply custom configuration if you so desire by appending an options hash to the arguments when `provider` is called, for example:

```ruby
use OmniAuth::Builder do
  keys_dir = Rails.root.join("vendor", "ucam-raven-public-keys")
  options = { desc: 'my description', msg: 'my message', params: 'string to be returned after login', date: true }
  provider "ucam-raven", keys_dir, opts
end
```

If you are looking to use the strategy with the [SRCF Goose authentication service](https://auth.srcf.net/) rather than Raven then you can include the following configuration:

```ruby
use OmniAuth::Builder do
  keys_dir = Rails.root.join("vendor", "ucam-raven-public-keys")
  provider "ucam-raven", keys_dir, honk: true
end
```

See the code for the [example Sinatra app](https://github.com/CHTJonas/omniauth-ucam-raven/blob/main/examples/sinatra) for a hands-on example of this and [here](https://github.com/CHTJonas/omniauth-ucam-raven/blob/main/lib/omniauth/strategies/ucam-raven.rb#L18) for a full list of configurable options.
Each option is fully documented in the [specification](https://w3.charliejonas.co.uk/mirror/raven/waa2wls-protocol.txt).

For additional information, please refer to the [OmniAuth wiki](https://github.com/intridea/omniauth/wiki).

## License

omniauth-ucam-raven is released under the MIT License.
Copyright (c) 2018 Charlie Jonas.
