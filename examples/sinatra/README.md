# Sinatra Example

This example clearly demonstrates how to use the omniauth-ucam-raven strategy with a simple Sinatra web app.
You will need to download the RSA public key from the Raven project pages [here](https://raven.cam.ac.uk/project/keys/) before you continue.
At the time of writing (November 2018), the key ID in use to sign responses was number two.

## Setup

1. `git clone https://github.com/chtjonas/omniauth-ucam-raven.git`
2. `cd omniauth-ucam-raven/examples/sinatra`
3. Run the `rackup` command
4. Navigate to http://localhost:4567 and complete the login process
