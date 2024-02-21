# gotofun-app

A sample offline-first Flutter app that connects to [PowerSync](https://www.powersync.com/) as a sync layer, and a Rails backend service.

This project is a demo of the utility of local-first architecture and serves as a starting point for a Flutter application that uses Powersync.

### Setup

1. Edit ./lib/config.dart
2. change `powersyncInstanceEndpoint` to your PowerSync instance endpoint
3. change `backendApiHost` to your backend host

### Running the app

```
flutter pub get
flutter run
```

