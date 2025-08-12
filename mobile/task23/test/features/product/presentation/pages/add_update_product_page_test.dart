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
    provideDummy<ProductState>(InitialState());  // Fixed typo: IntialState -> InitialState
  });

  setUp(() {
    mockProductBloc = MockProductBloc();
  });

  testWidgets(
    'fills form and dispatches CreateProductEvent then shows validation error for price',
    (WidgetTester tester) async {
      // ✅ Stub state
      when(mockProductBloc.state).thenReturn(InitialState());  // Fixed typo

      // ✅ Stub the stream getter explicitly
      when(mockProductBloc.stream)
          .thenAnswer((_) => const Stream<ProductState>.empty());

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
        'abdre.99',  // Invalid price format
      );
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

  testWidgets(
    'successfully creates product with valid data',
    (WidgetTester tester) async {
      // ✅ Stub state
      when(mockProductBloc.state).thenReturn(InitialState());
      when(mockProductBloc.stream)
          .thenAnswer((_) => const Stream<ProductState>.empty());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const AddUpdateProductPage(isEditing: false),
          ),
        ),
      );

      // Fill form with valid data
      await tester.enterText(
        find.byKey(const Key('nameField')),
        'Test Product',
      );
      await tester.enterText(
        find.byKey(const Key('priceField')),
        '29.99',
      );
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

      // Verify that CreateProductEvent was added
      verify(mockProductBloc.add(any)).called(1);
    },
  );

  testWidgets(
    'shows loading state when creating product',
    (WidgetTester tester) async {
      // ✅ Stub state
      when(mockProductBloc.state).thenReturn(LoadingState());
      when(mockProductBloc.stream)
          .thenAnswer((_) => Stream.value(LoadingState()));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const AddUpdateProductPage(isEditing: false),
          ),
        ),
      );

      // Trigger a rebuild to show loading state
      await tester.pump();

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'shows error message when product creation fails',
    (WidgetTester tester) async {
      // ✅ Stub state
      when(mockProductBloc.state).thenReturn(InitialState());
      when(mockProductBloc.stream)
          .thenAnswer((_) => Stream.value(ErrorState(message: 'Failed to create product')));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const AddUpdateProductPage(isEditing: false),
          ),
        ),
      );

      // Trigger a rebuild to show error state
      await tester.pump();

      // Verify error message is shown
      expect(find.text('Failed to create product'), findsOneWidget);
    },
  );
}