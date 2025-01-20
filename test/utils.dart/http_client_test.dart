import 'dart:convert';

import 'package:currency_app/utils.dart/http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

typedef Json = Map<String, dynamic>;

class MockClient extends Mock implements Client {}

class ParserSpy {
  int counter = 0;
  late final Json parsedJson;

  dynamic call(Json json) {
    parsedJson = json;
    counter++;
    return json;
  }
}

void main() {
  group('HttpClient', () {
    late MockClient client;
    late HttpClient httpClient;

    final anyUrl = Uri.parse('https://any.com');

    setUpAll(() {
      registerFallbackValue(Uri.parse('https://any.com'));
    });

    setUp(() {
      client = MockClient();
      httpClient = HttpClient(client);
    });

    tearDown(() {
      client.close();
      reset(client);
    });

    test('get should call client.get with the correct url and headers', () {
      final anyHeaders = {'any': 'any'};
      anyParser(json) => json;

      when(() => client.get(anyUrl, headers: anyHeaders)).thenAnswer(
        (_) async => Response('{}', 200),
      );

      httpClient.get(anyUrl, headers: anyHeaders, parser: anyParser);
      verify(() => client.get(anyUrl, headers: anyHeaders)).called(1);
    });

    test('get should parse the JSON response from client.get exactly once',
        () async {
      final anyJson = '''
      {
        "title": "any",
        "description": "any"
      }
      ''';

      final parserSpy = ParserSpy();

      when(() => client.get(anyUrl)).thenAnswer(
        (_) async => Response(anyJson, 200),
      );

      await httpClient.get(anyUrl, parser: parserSpy.call);
      expect(parserSpy.counter, 1);

      final decodedJson = {
        'title': 'any',
        'description': 'any',
      };
      expect(parserSpy.parsedJson, decodedJson);
    });

    test('get should throw an exception if the client.get throws an exception',
        () async {
      final anyException = ClientException('message');

      when(() => client.get(anyUrl)).thenAnswer(
        (_) async => throw anyException,
      );

      expect(
        () async => await httpClient.get(anyUrl, parser: (json) => json),
        throwsA(isA<ClientException>()),
      );
    });
  });
}
