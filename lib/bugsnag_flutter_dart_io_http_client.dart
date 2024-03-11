library bugsnag_flutter_dart_io_http_client;

import 'dart:io';

final _subscribers = <dynamic Function(dynamic)?>[];

void addSubscriber(dynamic Function(dynamic)? callback) {
  _subscribers.add(callback);
}

class BugsnagHttpClient implements HttpClient{

  final HttpClient _client = HttpClient();
  static int _requestId = 0;
  @override
  bool autoUncompress = true;

  @override
  Duration? connectionTimeout;

  @override
  Duration idleTimeout  = const Duration(seconds: 15);

  @override
  int? maxConnectionsPerHost;

  @override
  String? userAgent;

  HttpClient _getClient() {

    _client.autoUncompress = autoUncompress;
    _client.connectionTimeout = connectionTimeout;
    _client.idleTimeout = idleTimeout;
    _client.maxConnectionsPerHost = maxConnectionsPerHost;
    return _client;
  }

  String _generateRequestId() {
    _requestId += 1;
    return "$_requestId";
  }

  void _notifySubscriber(Map<String, dynamic> data) {
    for (var subscriber in _subscribers) {
      subscriber!(data);
    }
  }

  String _sendRequestStartNotification(String? url,String? method) {
    var requestId = _generateRequestId();
    _notifySubscriber({
      "url": url,
      "status": "started",
      "request_id": requestId,
      "http_method": method
    });
    return requestId;
  }

  void _sendRequestCompleteNotification(String requestId, HttpClientRequest request, HttpClientResponse response) {
    _notifySubscriber({
      "status": "complete",
      "status_code": response.statusCode,
      "request_id": requestId,
      "http_method": request.method,
      "response_content_length": response.contentLength,
      "request_content_length": request.contentLength
    });
  }

  void _sendRequestFailedNotification(String requestId) {
    _notifySubscriber({
      "status": "failed",
      "request_id": requestId
    });
  }

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {
    _getClient().addCredentials(url, realm, credentials);
  }

  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {
    _getClient().addProxyCredentials(host, port, realm, credentials);
  }

  @override
  set authenticate(Future<bool> Function(Uri url, String scheme, String? realm)? f) {
    _client.authenticate = f;
  }

  @override
  set authenticateProxy(Future<bool> Function(String host, int port, String scheme, String? realm)? f) {
    _client.authenticateProxy = f;
  }

  @override
  set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) {
    _client.badCertificateCallback = callback;
  }

  @override
  void close({bool force = false}) {
    _getClient().close(force: force);
  }

  @override
  set connectionFactory(Future<ConnectionTask<Socket>> Function(Uri url, String? proxyHost, int? proxyPort)? f) {
    _client.connectionFactory = f;
  }

  @override
  Future<HttpClientRequest> get(String host, int port, String path) async {
    var requestId = _sendRequestStartNotification("$host:$port$path", "GET");
    return _getClient().get(host,port,path)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    var requestId = _sendRequestStartNotification(url.toString(), "GET");
    return _getClient().getUrl(url)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) {
    var requestId = _sendRequestStartNotification("$host:$port$path", "DELETE");
    return _getClient().delete(host,port,path)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) {
    var requestId = _sendRequestStartNotification(url.toString(), "DELETE");
    return _getClient().deleteUrl(url)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  set findProxy(String Function(Uri url)? f) {
    _client.findProxy = f;
  }

  @override
  Future<HttpClientRequest> head(String host, int port, String path) {
    var requestId = _sendRequestStartNotification("$host:$port$path", "HEAD");
    return _getClient().head(host,port,path)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<HttpClientRequest> headUrl(Uri url) {
    var requestId = _sendRequestStartNotification(url.toString(), "HEAD");
    return _getClient().headUrl(url)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  set keyLog(Function(String line)? callback) {
    _client.keyLog = callback;
  }

  @override
  Future<HttpClientRequest> open(String method, String host, int port, String path) {
    var requestId = _sendRequestStartNotification("$host:$port$path", "OPEN");
    return _getClient().open(method,host,port,path)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
    var requestId = _sendRequestStartNotification(url.toString(), "OPEN");
    return _getClient().openUrl(method,url)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) {
    var requestId = _sendRequestStartNotification("$host:$port$path", "PATCH");
    return _getClient().patch(host,port,path)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<HttpClientRequest> patchUrl(Uri url) {
    var requestId = _sendRequestStartNotification(url.toString(), "PATCH");
    return _getClient().patchUrl(url)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<HttpClientRequest> post(String host, int port, String path) {
    var requestId = _sendRequestStartNotification("$host:$port$path", "POST");
    return _getClient().post(host,port,path)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<HttpClientRequest> postUrl(Uri url) {
    var requestId = _sendRequestStartNotification(url.toString(), "POST");
    return _getClient().postUrl(url)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<HttpClientRequest> put(String host, int port, String path) {
    var requestId = _sendRequestStartNotification("$host:$port$path", "PUT");
    return _getClient().put(host,port,path)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }

  @override
  Future<HttpClientRequest> putUrl(Uri url) {
    var requestId = _sendRequestStartNotification(url.toString(), "PUT");
    return _getClient().putUrl(url)
        .then((HttpClientRequest request) {
      request.done.then((HttpClientResponse response) {
        _sendRequestCompleteNotification(requestId, request, response);
      }).catchError((error) {
        _sendRequestFailedNotification(requestId);
      });
      return request;
    });
  }



}
