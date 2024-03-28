<div align="center">
  <a href="https://www.bugsnag.com/platforms/flutter">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://assets.smartbear.com/m/3dab7e6cf880aa2b/original/BugSnag-Repository-Header-Dark.svg">
      <img alt="SmartBear BugSnag logo" src="https://assets.smartbear.com/m/3945e02cdc983893/original/BugSnag-Repository-Header-Light.svg">
    </picture>
  </a>
</div>

# BugSnag Flutter Dart:io Http Client Wrapper

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

## Support

* [Read the integration guide](https://docs.bugsnag.com/performance/flutter/)
* [Search open and closed issues](https://github.com/bugsnag/bugsnag-flutter-dart-io-http-client/issues?utf8=✓&q=is%3Aissue) for similar problems
* [Report a bug or request a feature](https://github.com/bugsnag/bugsnag-flutter-dart-io-http-client/issues/new)

## License

The BugSnag Flutter Performance SDK is free software released under the MIT License. See the [LICENSE](./LICENSE) for details.
