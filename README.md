# NOTE: This repo is a work in progress and has not yet been released as a production ready package.

# BugSnag Flutter Dart:io Http Client

A wrapper for [Dart:io HTTP](https://api.dart.dev/stable/3.3.1/dart-io/dart-io-library.html) that enables automated instrumentation via the BugSnag Performance SDK and Error Monitoring SDK. This package simplifies the process of tracking and monitoring HTTP requests in your Dart applications.

## Features

- **Automated Request Instrumentation**: Automatically creates network spans for HTTP requests and sends them to the BugSnag Performance dashboard.

## Getting Started

To use the `BugsnagHttpClient` wrapper in your Dart project, first add the dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  bugsnag_flutter_dart_io_http_client: ^1.0.0 # Use the latest version
```

Then, run pub get in your terminal to fetch the package.

## Usage
Here's a simple example of using BugSnagHttpClient:

```dart

// Import the wrapper
import 'package:bugsnag_flutter_dart_io_http_client/bugsnag_flutter_dart_io_http_client.dart' as dart_io;


// add Bugsnag Performance as a subscriber. This only needs to be done once in your apps lifecycle.
dart_io.addSubscriber(BugsnagPerformance.networkInstrumentation);


// Make a request 
final client = dart_io.BugsnagHttpClient();
HttpClientRequest request = await client.getUrl(FixtureConfig.MAZE_HOST);
await request.close();

```
