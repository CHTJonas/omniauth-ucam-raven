# Sinatra Example

This example clearly demonstrates how to use the omniauth-ucam-raven strategy with a simple Sinatra web app.
You will need to download the Raven service RSA public key pro tempore in PEM format from the project pages [here](https://raven.cam.ac.uk/project/keys/) and edit the path in `ucamravenexample.rb`.
At the time of writing (April 2020), the key ID being used to sign responses is 2.

## Setup

1. `git clone https://github.com/chtjonas/omniauth-ucam-raven.git`
2. `cd omniauth-ucam-raven/examples/sinatra`
3. `bundle install`
4. `bundle exec rackup`
5. Navigate to http://localhost:4567
