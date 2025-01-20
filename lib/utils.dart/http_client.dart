import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_client.g.dart';

class HttpClient {
  final Client client;

  const HttpClient(this.client);

  Future<T> get<T>(
    Uri uri, {
    Map<String, String>? headers,
    required T Function(Map<String, dynamic> json) parser,
  }) async {
    final response = await client.get(uri, headers: headers);

    return parser(jsonDecode(response.body));
  }
}

@riverpod
HttpClient httpClient(Ref ref) => HttpClient(Client());
