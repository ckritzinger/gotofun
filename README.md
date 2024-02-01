# gotofun

This is a sample application that demonstrates how to use [PowerSync](https://www.powersync.com/)
to build an offline-first Flutter app with a Rails backend.

The app displays a list of fun things to do. It also provides some example code for adding new items to the DB. Building a mobile UI for this is left as an exercise for the reader.

The backend provides some scaffolding for adding new items and a simple REST API that can be used for updates. Both of these are very lightly modified Rails scaffolding.

The backend also implements authentication endpoints as required by PowerSync (JWT generation and a JKWKS endpoint).

## Setup

1. Deploy the Rails app to a server somewhere. I used Fly.io.
2. Deploy the Flutter app to a device or emulator.
3. Read the individual [backend](./gotofun-backend/README.md) and [app](./gotofun-app/README.md) READMEs for detailed setup info.

## Fly.io Setup

First, [install the flyctl CLI](https://fly.io/docs/hands-on/install-flyctl/)

Then, create your fly app:

```
cd gotofun-backend
flyctl launch
# if you're on a free plan, run this with --ha=false
fly deploy
```

You now need to make the DB accessible to the internet, so that PowerSync can connect to it.

Fly has instructions for doing this [here](https://fly.io/docs/postgres/connecting/connecting-external/).

The docs are a little vague on how to get the username and password to connect to the DB. I found the easiest way was:

```
# if you're on a free plan, you need to run fly open first to get your app running
fly console
ENV['DATABASE_URL']
```

You can then extract your username and password from the URL.

In the connection string replace the Fly internal hostname with the public hostname for your **DB** app. This normally involves replacing the `.flycast` part of the hostname with `.fly.dev`.

Something like this:

```
postgres://user:password@gotofun-backend-db.flycast:5432/gotofun_backend?sslmode=disable
```

becomes

```
postgres://user:password@gotofun-backend-db.fly.dev:5432/gotofun_backend?sslmode=disable
```

Now you can use the connection string to connect to the DB from your local machine.

```
psql -Atx "postgres://..."
```

Follow the [normal Powersync instructions](https://docs.powersync.com/usage/installation/database-setup/fly-postgres) to set up your DB for Powersync.