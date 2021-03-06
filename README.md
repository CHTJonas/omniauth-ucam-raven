# Raven Omniauth strategy

This Ruby gem provides an OmniAuth strategy for authenticating using the [Raven SSO System](https://raven.cam.ac.uk), provided by the University of Cambridge.

## Installation

Add the strategy to your `Gemfile`:

```ruby
gem 'omniauth-ucam-raven'
```

And then run `bundle install`.

You then need to download the Raven service RSA public key pro tempore in PEM format from the project pages [here](https://raven.cam.ac.uk/project/keys/) and store it somewhere that is not writable by your web application.
You also need to note the key ID which at the time of writing (April 2020) is 2.

## Usage

The strategy expects Raven signing key data in the form of an array of key ID & key path tuples.
This allows multiple signing keys to be supported in order to facilitate key rollover or multiple backend auth servers.
If you do not provide the key paths and/or IDs in the correct format then an exception will be raised.
From this point on, it's assumed that the full UNIX file path and key ID are stored in the `KEY_PATH` and `KEY_ID` environment variables respectively.

If you're using Rails, you'll want to add the following to an initialisers e.g. `config/initializers/omniauth.rb` and then restart your application server:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  key_data = [[ENV['KEY_ID'], ENV['KEY_PATH']]]
  provider :ucamraven, key_data
end
```

For Sinatra and other Rack-based frameworks, you can integrate the strategy into your middleware e.g. in a `config.ru`:

```ruby
use OmniAuth::Builder do
  key_data = [[ENV['KEY_ID'], ENV['KEY_PATH']]]
  provider :ucamraven, key_data
end
```

Upon authentication, the user's details will be available in the `request.env['omniauth.auth']` object as show in the example below. Each field is well documented in the [protocol specification](https://github.com/cambridgeuniversity/UcamWebauth-protocol/blob/6e70f1f0223bc30f6963bdb79e06214a482a512e/waa2wls-protocol.txt#L231).
It should be noted that the `email` field is for provided convenience only and its presence does not imply that the address contained therein is a valid email address.

```
{
  "provider"=>"ucamraven",
  "uid"=>"crsid",
  "info"=>{"name"=>nil, "email"=>"crsid@cam.ac.uk", "ptags"=>["current"]},
  "credentials"=>{"auth"=>"", "sso"=>["pwd"]},
  "extra"=>{"id"=>"dateandtime", "lifetime"=>"sessionlifetime", "parameters"=>"your params string returned to you"}
}
```

## Configuration

The Ucam-Raven strategy will work straight out of the box but you can apply custom configuration if you so desire by appending an options hash to the arguments when `provider` is called, for example:

```ruby
use OmniAuth::Builder do
  key_data = [[1, "path_to_key_1"], [2, "path_to_key_2"], [3, "path_to_key_3"]]
  options = { desc: 'my description', msg: 'my message', params: 'string to be returned after login', date: true }
  provider :ucamraven, key_data, options
end
```

If you are looking to use the strategy with the [SRCF Goose authentication service](https://auth.srcf.net) rather than Raven then you can include the following configuration:

```ruby
use OmniAuth::Builder do
  key_data = [[2, "path_to_raven_key"], [500, "path_to_goose_key"]]
  provider :ucamraven, key_data, honk: true
end
```

See the code for the [example Sinatra app](https://github.com/CHTJonas/omniauth-ucam-raven/blob/master/examples/sinatra) for a hands-on example of this and [here](https://github.com/CHTJonas/omniauth-ucam-raven/blob/master/lib/omniauth/strategies/ucam-raven.rb#L14) for a full list of configurable options.
Each option is fully documented in the [specification](https://github.com/cambridgeuniversity/UcamWebauth-protocol/blob/6e70f1f0223bc30f6963bdb79e06214a482a512e/waa2wls-protocol.txt#L106).

For additional information, please refer to the [OmniAuth wiki](https://github.com/intridea/omniauth/wiki).

## License

omniauth-ucam-raven is released under the MIT License.
Copyright (c) 2018-2020 Charlie Jonas.
