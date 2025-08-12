import 'dart:convert';
import 'dart:io';

import 'package:contracts_of_data_sources/core/error/exception.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_remote_data_source.dart';
import 'package:contracts_of_data_sources/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'product_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;
  const baseUrl =
    'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v1/products';
  const headers = {'Content-Type': 'application/json'};

  // Shared product model
  const tProductModel = ProductModel(
    id: '1',
    name: 'PC',
    imageUrl: 'dummy1.jpeg',
    price: 123,
    description: 'long description',
  );

  // Helpers
  void mockGetResponse(String fixtureFile, {int statusCode = 200}) {
    when(
      mockHttpClient.get(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response(fixture(fixtureFile), statusCode));
  }

  void mockPutResponse({int statusCode = 200}) {
    when(
      mockHttpClient.put(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => http.Response('', statusCode));
  }

  void mockDeleteResponse({int statusCode = 200}) {
    when(
      mockHttpClient.delete(any, headers: anyNamed('headers')),
    ).thenAnswer((_) async => http.Response('', statusCode));
  }

  void mockMultipartSend({required int statusCode}) {
    when(mockHttpClient.send(any)).thenAnswer(
      (_) async =>
          http.StreamedResponse(Stream.value(utf8.encode('')), statusCode),
    );
  }

  Future<File> createDummyImage(String path) async {
    final file = File(path);
    await file.create(recursive: true);
    await file.writeAsBytes([1, 2, 3]);
    return file;
  }

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getProductById', () {
    final tId = '6672776eb905525c145fe0bb';

    test('should perform a GET request with correct URL and headers', () async {
      mockGetResponse('product_remote.json');

      await dataSource.getProductById(tId);

      verify(mockHttpClient.get(Uri.parse('$baseUrl/$tId'), headers: headers));
    });

    test('should return ProductModel when response is 200', () async {
      mockGetResponse('product_remote.json');

      final expected = ProductModel.fromJson(
        (json.decode(fixture('product_remote.json'))
            as Map<String, dynamic>)['data'],
      );

      final result = await dataSource.getProductById(tId);

      expect(result, equals(expected));
    });

    test('should throw ServerException when response is not 200', () async {
      mockGetResponse('product_remote.json', statusCode: 404);

      expect(
        () => dataSource.getProductById(tId),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getAllProducts', () {
    test('should perform a GET request with correct URL and headers', () async {
      mockGetResponse('product_list.json');

      await dataSource.getAllProducts();

      verify(mockHttpClient.get(Uri.parse(baseUrl), headers: headers));
    });

    test('should return list of ProductModels when response is 200', () async {
      mockGetResponse('product_list.json');

      final List<ProductModel> expected =
          (json.decode(fixture('product_list.json'))['data'] as List)
              .map((e) => ProductModel.fromJson(e))
              .toList();

      final result = await dataSource.getAllProducts();

      expect(result, equals(expected));
    });

    test('should throw ServerException when response is not 200', () async {
      mockGetResponse('product_list.json', statusCode: 404);

      expect(
        () => dataSource.getAllProducts(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('createProduct', () {
    late File imageFile;
    late http.MultipartRequest capturedRequest;

    setUp(() async {
      imageFile = await createDummyImage(tProductModel.imageUrl);
    });

    tearDown(() async {
      if (await imageFile.exists()) await imageFile.delete();
    });

    test('should send a multipart POST request with correct data', () async {
      mockMultipartSend(statusCode: 201);

      when(mockHttpClient.send(any)).thenAnswer((invocation) async {
        capturedRequest =
            invocation.positionalArguments[0] as http.MultipartRequest;
        return http.StreamedResponse(Stream.value(utf8.encode('')), 201);
      });

      await dataSource.createProduct(tProductModel);

      expect(capturedRequest.url.toString(), equals(baseUrl));
      expect(capturedRequest.method, equals('POST'));
      expect(capturedRequest.fields['name'], equals(tProductModel.name));
      expect(
        capturedRequest.fields['description'],
        equals(tProductModel.description),
      );
      expect(
        capturedRequest.fields['price'],
        equals(tProductModel.price.toString()),
      );
      expect(capturedRequest.files.length, equals(1));
      expect(capturedRequest.files.first.field, equals('image'));
    });

    test('should complete normally when status is 201', () async {
      mockMultipartSend(statusCode: 201);

      await expectLater(dataSource.createProduct(tProductModel), completes);
    });

    test('should throw ServerException on error response', () async {
      mockMultipartSend(statusCode: 400);

      expect(
        () => dataSource.createProduct(tProductModel),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw exception if image file not found', () async {
      final file = File(tProductModel.imageUrl);
      if (await file.exists()) await file.delete();

      expect(
        () => dataSource.createProduct(tProductModel),
        throwsA(
          predicate((e) => e.toString().contains('Image file not found')),
        ),
      );
    });
  });

  group('updateProduct', () {
    final updatedProduct = const ProductModel(
      id: '6672940692adcb386d593686',
      name: 'TV',
      imageUrl: 'not-used-in-update',
      price: 123.4,
      description: "36' TV",
    );

    test('should perform PUT with correct URL, headers, and body', () async {
      mockPutResponse();

      await dataSource.updateProduct(updatedProduct);

      final expectedBody = json.encode({
        'name': updatedProduct.name,
        'description': updatedProduct.description,
        'price': updatedProduct.price,
      });

      verify(
        mockHttpClient.put(
          Uri.parse('$baseUrl/${updatedProduct.id}'),
          headers: headers,
          body: expectedBody,
        ),
      );
    });

    test('should complete normally when status code is 200', () async {
      mockPutResponse();

      expect(dataSource.updateProduct(updatedProduct), completes);
    });

    test('should throw ServerException when response is not 200', () async {
      mockPutResponse(statusCode: 400);

      expect(
        () => dataSource.updateProduct(updatedProduct),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('deleteProduct', () {
    final tId = '6672940692adcb386d593686';

    test('should perform DELETE with correct URL and headers', () async {
      mockDeleteResponse();

      await dataSource.deleteProduct(tId);

      verify(
        mockHttpClient.delete(Uri.parse('$baseUrl/$tId'), headers: headers),
      );
    });

    test('should complete normally when status code is 200', () async {
      mockDeleteResponse();

      expect(dataSource.deleteProduct(tId), completes);
    });

    test('should throw ServerException when status code is not 200', () async {
      mockDeleteResponse(statusCode: 404);

      expect(
        () => dataSource.deleteProduct(tId),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
