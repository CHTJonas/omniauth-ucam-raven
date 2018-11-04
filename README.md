# Raven Omniauth strategy

This Ruby gem provides an OmniAuth strategy for authenticating using the [Raven SSO System](https://raven.cam.ac.uk), provided by the University of Cambridge.

## Installation

Add the strategy to your `Gemfile`:

```ruby
gem 'omniauth-ucam-raven'
```

And then run `bundle install`.

## Usage

You can integrate the strategy into your middleware in a `config.ru`:

```ruby
use OmniAuth::Builder do
  provider :ucamraven, ENV['KEY_ID'], ENV['KEY_PATH']
end
```

If you're using Rails, you'll want to add to the middleware stack:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :ucamraven, ENV['KEY_ID'], ENV['KEY_PATH']
end
```

For a full list of options that you can configure when setting `:ucamraven` as provider you will need to look
[here](https://github.com/CHTJonas/omniauth-ucam-raven/blob/master/lib/omniauth/strategies/ucam-raven.rb#L13) in the source code.

For additional information, please refer to the [OmniAuth wiki](https://github.com/intridea/omniauth/wiki).

See the code for the [example Sinatra app](https://github.com/CHTJonas/omniauth-ucam-raven/blob/master/examples/sinatra/config.ru) for a hands-on example.

## License

omniauth-ucam-raven is released under the MIT License. Copyright (c) 2018 Charlie Jonas.
