library bugsnag_flutter_dart_io_http_client;

import 'dart:io' as dart_io;

import 'package:bugsnag_bridge/bugsnag_bridge.dart';

final _subscribers = <dynamic Function(dynamic)?>[];

void addSubscriber(dynamic Function(dynamic)? callback) {
  _subscribers.add(callback);
}

class HttpClient implements dart_io.HttpClient {
  final dart_io.HttpClient _client = dart_io.HttpClient();
  late HttpHeadersProvider _headersProvider = HttpHeadersProviderImpl();
  static int _requestId = 0;
  @override
  bool autoUncompress = true;

  @override
  Duration? connectionTimeout;

  @override
  Duration idleTimeout = const Duration(seconds: 15);

  @override
  int? maxConnectionsPerHost;

  @override
  String? userAgent;

  dart_io.HttpClient _getClient() {
    _client.autoUncompress = autoUncompress;
    _client.connectionTimeout = connectionTimeout;
    _client.idleTimeout = idleTimeout;
    _client.maxConnectionsPerHost = maxConnectionsPerHost;
    return _client;
  }

  String _generateRequestId() {
    _requestId += 1;
    return _requestId.toString();
  }

  void _notifySubscriber(Map<String, dynamic> data) {
    for (final subscriber in _subscribers) {
      if (subscriber != null) subscriber(data);
    }
  }

  String _sendRequestStartNotification(String? url, String? method) {
    final requestId = _generateRequestId();
    _notifySubscriber({
      'url': url,
      'status': 'started',
      'request_id': requestId,
      'http_method': method
    });
    return requestId;
  }

  void _sendRequestCompleteNotification(
    String requestId,
    dart_io.HttpClientRequest request,
    dart_io.HttpClientResponse response,
  ) {
    _notifySubscriber({
      'status': 'complete',
      'status_code': response.statusCode,
      'request_id': requestId,
      'http_method': request.method,
      'response_content_length': response.contentLength,
      'request_content_length': request.contentLength,
      'client': 'dart:io',
      'url': request.uri.toString()
    });
  }

  void _sendRequestFailedNotification(String requestId) {
    _notifySubscriber({
      'status': 'failed',
      'request_id': requestId,
      'client': _client.runtimeType.toString()
    });
  }

  @override
  void addCredentials(
      Uri url, String realm, dart_io.HttpClientCredentials credentials) {
    _getClient().addCredentials(url, realm, credentials);
  }

  @override
  void addProxyCredentials(String host, int port, String realm,
      dart_io.HttpClientCredentials credentials) {
    _getClient().addProxyCredentials(host, port, realm, credentials);
  }

  @override
  set authenticate(
      Future<bool> Function(Uri url, String scheme, String? realm)? f) {
    _client.authenticate = f;
  }

  @override
  set authenticateProxy(
    Future<bool> Function(
      String host,
      int port,
      String scheme,
      String? realm,
    )? f,
  ) {
    _client.authenticateProxy = f;
  }

  @override
  set badCertificateCallback(
      bool Function(dart_io.X509Certificate cert, String host, int port)?
          callback) {
    _client.badCertificateCallback = callback;
  }

  @override
  void close({bool force = false}) {
    _getClient().close(force: force);
  }

  @override
  set connectionFactory(
      Future<dart_io.ConnectionTask<dart_io.Socket>> Function(
              Uri url, String? proxyHost, int? proxyPort)?
          f) {
    _client.connectionFactory = f;
  }

  @override
  Future<dart_io.HttpClientRequest> get(
    String host,
    int port,
    String path,
  ) {
    final requestId = _sendRequestStartNotification('$host:$port$path', 'GET');
    return _getClient().get(host, port, path).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  Future<dart_io.HttpClientRequest> getUrl(Uri url) {
    final requestId = _sendRequestStartNotification(url.toString(), 'GET');
    return _getClient().getUrl(url).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  Future<dart_io.HttpClientRequest> delete(String host, int port, String path) {
    final requestId = _sendRequestStartNotification(
      '$host:$port$path',
      'DELETE',
    );

    return _getClient().delete(host, port, path).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  Future<dart_io.HttpClientRequest> deleteUrl(Uri url) {
    final requestId = _sendRequestStartNotification(url.toString(), 'DELETE');
    return _getClient().deleteUrl(url).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  set findProxy(String Function(Uri url)? f) {
    _client.findProxy = f;
  }

  @override
  Future<dart_io.HttpClientRequest> head(
    String host,
    int port,
    String path,
  ) {
    final requestId = _sendRequestStartNotification('$host:$port$path', 'HEAD');
    return _getClient().head(host, port, path).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  Future<dart_io.HttpClientRequest> headUrl(Uri url) {
    final requestId = _sendRequestStartNotification(url.toString(), 'HEAD');
    return _getClient().headUrl(url).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  set keyLog(Function(String line)? callback) {
    _client.keyLog = callback;
  }

  @override
  Future<dart_io.HttpClientRequest> open(
    String method,
    String host,
    int port,
    String path,
  ) {
    final requestId = _sendRequestStartNotification('$host:$port$path', method);
    return _getClient().open(method, host, port, path).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  Future<dart_io.HttpClientRequest> openUrl(String method, Uri url) {
    final requestId = _sendRequestStartNotification(url.toString(), method);
    return _getClient().openUrl(method, url).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  Future<dart_io.HttpClientRequest> patch(String host, int port, String path) {
    final requestId =
        _sendRequestStartNotification('$host:$port$path', 'PATCH');
    return _getClient().patch(host, port, path).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  Future<dart_io.HttpClientRequest> patchUrl(Uri url) {
    final requestId = _sendRequestStartNotification(url.toString(), 'PATCH');
    return _getClient().patchUrl(url).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  Future<dart_io.HttpClientRequest> post(String host, int port, String path) {
    final requestId = _sendRequestStartNotification('$host:$port$path', 'POST');
    return _getClient()
        .post(host, port, path)
        .then((dart_io.HttpClientRequest request) async {
      await _headersProvider
          .requestHeaders(
            url: request.uri.toString(),
            requestId: requestId,
          )
          ?.forEach((key, value) => request.headers.set(key, value));

      request.done.then((dart_io.HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<dart_io.HttpClientRequest> postUrl(Uri url) {
    final requestId = _sendRequestStartNotification(url.toString(), 'POST');
    return _getClient().postUrl(url).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  Future<dart_io.HttpClientRequest> put(String host, int port, String path) {
    final requestId = _sendRequestStartNotification('$host:$port$path', 'PUT');
    return _getClient().put(host, port, path).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }

  @override
  Future<dart_io.HttpClientRequest> putUrl(Uri url) {
    final requestId = _sendRequestStartNotification(url.toString(), 'PUT');
    return _getClient().putUrl(url).then(
      (dart_io.HttpClientRequest request) async {
        await _headersProvider
            .requestHeaders(
              url: request.uri.toString(),
              requestId: requestId,
            )
            ?.forEach((key, value) => request.headers.set(key, value));

        request.done.then((dart_io.HttpClientResponse response) {
          _sendRequestCompleteNotification(requestId, request, response);
        }).catchError((error) {
          _sendRequestFailedNotification(requestId);
        });
        return request;
      },
    );
  }
}
