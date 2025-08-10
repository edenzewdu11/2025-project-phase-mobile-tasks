import 'dart:async';

import 'package:contracts_of_data_sources/features/product/presentation/bloc/product_bloc.dart';
import 'package:contracts_of_data_sources/features/product/presentation/pages/add_update_product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_update_product_page_test.mocks.dart';

@GenerateMocks([ProductBloc])
void main() {
  late MockProductBloc mockProductBloc;

  setUpAll(() {
    // ✅ Register a dummy value for ProductState
    provideDummy<ProductState>(IntialState());
  });

  setUp(() {
    mockProductBloc = MockProductBloc();
  });

  testWidgets(
    'fills form and dispatches CreateProductEvent then shows validation error for price',
    (WidgetTester tester) async {
      // ✅ Stub state
      when(mockProductBloc.state).thenReturn(IntialState());

      // ✅ Stub the stream getter explicitly
      when(
        mockProductBloc.stream,
      ).thenAnswer((_) => const Stream<ProductState>.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const AddUpdateProductPage(isEditing: false),
          ),
        ),
      );

      // Fill form
      await tester.enterText(
        find.byKey(const Key('nameField')),
        'Test Product',
      );
      await tester.enterText(
        find.byKey(const Key('priceField')),
        'abdre.99',
      ); // invalid
      await tester.enterText(
        find.byKey(const Key('descriptionField')),
        'Test Description',
      );
      await tester.enterText(
        find.byKey(const Key('imageUrlField')),
        'https://image.com/img.jpg',
      );
      await tester.pump();

      // Tap submit button
      await tester.tap(find.byKey(const Key('addUpdatButton')));
      await tester.pump();

      // Expect validation error
      expect(find.text('Enter a valid price.'), findsOneWidget);
    },
  );
}
