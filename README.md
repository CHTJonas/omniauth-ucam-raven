# Raven Omniauth strategy

This Ruby gem provides an OmniAuth strategy for authenticating using the [Raven SSO System](https://raven.cam.ac.uk), provided by the University of Cambridge.

## Installation

Add the strategy to your `Gemfile`:

```ruby
gem 'omniauth-ucam-raven'
```

And then run `bundle install`.

## Usage

You will need to download the public key used by the Raven service to sign responses and store it somewhere that is not writable by your web application.
Download the PEM formated PKCS#1 RSA public key from the Raven project pages [here](https://raven.cam.ac.uk/project/keys/).
You will also need the key ID that is currently in use - as of August 2004 this is 2.
From this point on, we assume the full UNIX path and key ID are in the KEY_PATH and KEY_ID environment variables respectively.

You can integrate the strategy into your middleware in a `config.ru`:

```ruby
use OmniAuth::Builder do
  provider :ucamraven, ENV['KEY_ID'], ENV['KEY_PATH']
end
```

If you're using Rails, you'll want to add the following to an initialisers eg. `config/initializers/omniauth.rb` and then restart your application:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :ucamraven, ENV['KEY_ID'], ENV['KEY_PATH']
end
```

For a full list of options that you can configure when setting `:ucamraven` as your strategy you will need to look
[here](https://github.com/CHTJonas/omniauth-ucam-raven/blob/master/lib/omniauth/strategies/ucam-raven.rb#L13) in the source code.
An options hash can be appended to the arguments when `provider` is called, for example:

```ruby
use OmniAuth::Builder do
  provider :ucamraven, ENV['KEY_ID'], ENV['KEY_PATH'], { desc: 'my description', msg: 'my message' }
end
```

See the code for the [example Sinatra app](https://github.com/CHTJonas/omniauth-ucam-raven/blob/master/examples/sinatra) for a hands-on example of this.

For additional information, please refer to the [OmniAuth wiki](https://github.com/intridea/omniauth/wiki).

## License

omniauth-ucam-raven is released under the MIT License.
Copyright (c) 2018-2020 Charlie Jonas.
