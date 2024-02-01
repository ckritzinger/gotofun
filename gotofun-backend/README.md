# gotofun-backend

This is a simple rails application that serves as a backend for the gotofun-app.

It performs three main functions:

1. It provides a JWKS endpoint for PowerSync auth.
2. It provides an endpoint where the app may obtain a JWT for PowerSync auth.
3. It provides a backend API for data updates.
4. It provides some basic CRUD for the data.

## Setup

It's recommended to use [rbenv](https://github.com/rbenv/rbenv) to manage your Ruby version.

1. The usual Rails things: `bundle install`, `rails db:setup`, etc.
2. Edit gotofun-backend/app/controllers/keys_controller.rb
  1. Change `POWERSYNC_ENDPOINT` to your PowerSync instance endpoint
  2. Change `API_ENDPOINT` to the base URL where you will host this app
3. Regenerate the credentials (details below) with: `rm config/credentials.yaml.emc && rails credentials:edit`

## Running the app

```
rails s
```

You can then access the app at http://localhost:3000

- The JWKS endpoint is at http://127.0.0.1:3000/keys
- The JWT endpoint is at http://127.0.0.1:3000/keys/<user_id>
- CRUD UI is at http://127.0.0.1:3000/
- The standard Rails CRUD json/REST API is at http://127.0.0.1:3000/activities.json, and can be used for client writes.

For debugging auth, it may be useful to connect your mobile app to a local instance of this backend.

To do so, you will need to use a tool like [ngrok](https://ngrok.com/) to expose your local server to the internet.

Then, you will need to edit gotofun-app/lib/config.dart and change `backendApiHost` to the ngrok URL.

You will also need to change `API_ENDPOINT` in ./app/controllers/keys_controller.rb to the ngrok URL.

## Regenerating the credentials

your credentials.yaml.emc should look something like this:

```
secret_key_base: 2c2d5b420a58...
admin_password: supersecretyouwillneverguess
private_key: |-
  -----BEGIN RSA PRIVATE KEY-----
  MIIEpQIBAAKCAQEA2yAvLaeOudwzbf4Gkl6x2dheb/onCzD+TsGOiEgdPf1cjX4w
  ...
  ...
  -----END RSA PRIVATE KEY-----
```

Generate a private key in your rails console with: `OpenSSL::PKey::RSA.generate(2048).to_s`