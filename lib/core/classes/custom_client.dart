import 'dart:convert';

import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:http/http.dart' as http;

// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

/// The abstract base class for an HTTP client.
///
/// This is a mixin-style class; subclasses only need to implement [send] and
/// maybe [close], and then they get various convenience methods for free.
abstract mixin class BaseClient implements http.Client {
  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) =>
      _sendUnstreamed('HEAD', url, headers);

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) =>
      _sendUnstreamed('GET', url, headers);

  @override
  Future<http.Response> post(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _sendUnstreamed('POST', url, headers, body, encoding);

  @override
  Future<http.Response> put(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _sendUnstreamed('PUT', url, headers, body, encoding);

  @override
  Future<http.Response> patch(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _sendUnstreamed('PATCH', url, headers, body, encoding);

  @override
  Future<http.Response> delete(Uri url,
          {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
      _sendUnstreamed('DELETE', url, headers, body, encoding);

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) async {
    final response = await get(url, headers: headers);
    _checkResponseSuccess(url, response);
    return response.body;
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async {
    final response = await get(url, headers: headers);
    _checkResponseSuccess(url, response);
    return response.bodyBytes;
  }

  /// Sends an HTTP request and asynchronously returns the response.
  ///
  /// Implementers should call [BaseRequest.finalize] to get the body of the
  /// request as a [ByteStream]. They shouldn't make any assumptions about the
  /// state of the stream; it could have data written to it asynchronously at a
  /// later point, or it could already be closed when it's returned. Any
  /// internal HTTP errors should be wrapped as [ClientException]s.
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request);

  /// Sends a non-streaming [Request] and returns a non-streaming [Response].
  Future<http.Response> _sendUnstreamed(
      String method, Uri url, Map<String, String>? headers,
      [Object? body, Encoding? encoding]) async {
    var request = http.Request(method, url);

    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      } else {
        throw ArgumentError('Invalid request body "$body".');
      }
    }

    return http.Response.fromStream(await send(request));
  }

  /// Throws an error if [response] is not successful.
  void _checkResponseSuccess(Uri url, http.Response response) {
    // if (response.statusCode < 400) return;
    // var message = 'Request to $url failed with status ${response.statusCode}';
    // if (response.reasonPhrase != null) {
    //   message = '$message: ${response.reasonPhrase}';
    // }
    // throw http.ClientException('$message.', url);
  }

  @override
  void close() {}
}


class CustomClient extends BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final token = SharedPrefs.instance.prefs.getString('token');
    request.headers['Authorization'] = 'Bearer $token';
    return http.Client().send(request);
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final response = await super.get(url, headers: headers);
    if (response.statusCode == 401) {
      SharedPrefs.instance.clearToken();
    }
    return response;
  }

  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await super.post(url, headers: headers, body: body, encoding: encoding);
    if (response.statusCode == 401) {
      SharedPrefs.instance.clearToken();
    }
    return response;
  }

  @override
  Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await super.put(url, headers: headers, body: body, encoding: encoding);
    if (response.statusCode == 401) {
      SharedPrefs.instance.clearToken();
    }
    return response;
  }

  @override
  Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await super.delete(url, headers: headers, body: body, encoding: encoding);
    if (response.statusCode == 401) {
      SharedPrefs.instance.clearToken();
    }
    return response;
  }

  @override
  Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await super.patch(url, headers: headers, body: body, encoding: encoding);
    if (response.statusCode == 401) {
      SharedPrefs.instance.clearToken();
    }
    return response;
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) async {
    final response = await super.head(url, headers: headers);
    if (response.statusCode == 401) {
      SharedPrefs.instance.clearToken();
    }
    return response;
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) async {
    final response = await super.read(url, headers: headers);
    if (response == 'Unauthorized') {
      SharedPrefs.instance.clearToken();
    }
    return response;
  } 
}

Future<http.Response> get(Uri url, {Map<String, String>? headers}) =>
    _withClient((client) => client.get(url, headers: headers));

Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _withClient((client) => client.post(url, headers: headers, body: body, encoding: encoding));

Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _withClient((client) => client.put(url, headers: headers, body: body, encoding: encoding));

Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _withClient((client) => client.patch(url, headers: headers, body: body, encoding: encoding));

Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _withClient((client) => client.delete(url, headers: headers, body: body, encoding: encoding));

Future<String> read(Uri url, {Map<String, String>? headers}) =>
    _withClient((client) => client.read(url, headers: headers));

Future<T> _withClient<T>(Future<T> Function(CustomClient) fn) async {
  var client = CustomClient();
  try {
    return await fn(client);
  } finally {
    client.close();
  }
}