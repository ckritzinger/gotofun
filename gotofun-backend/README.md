# gotofun-backend

This is a simple rails application that serves as a backend for the gotofun-app.

It performs three main functions:

1. It provides a JWKS endpoint for PowerSync auth.
2. It provides an endpoint where the app may obtain a JWT for PowerSync auth.
3. It provides a backend API for data updates.
4. It provides some basic CRUD for the data.

## Setup

1. The usual Rails things: `bundle install`, `rails db:setup`, etc.
2. Edit gotofun-backend/app/controllers/keys_controller.rb
3. Change `POWERSYNC_ENDPOINT` to your PowerSync instance endpoint
4. Change `API_ENDPOINT` to the base URL where you will host this app

## Running the app

```
rails s
```

For debugging auth, it may be useful to connect your mobile app to a local instance of this backend.

To do so, you will need to use a tool like [ngrok](https://ngrok.com/) to expose your local server to the internet.

Then, you will need to edit gotofun-app/lib/config.dart and change `backendApiHost` to the ngrok URL.

You will also need to change `API_ENDPOINT` to the ngrok URL.
