# Mini Market App

A Flutter e-commerce application with shopping cart functionality and product management, built with **go_router** for navigation and **BLoC (Business Logic Component)** pattern for state management.

## Features

- 📱 **Product Listing**: Browse products in a grid layout with loading states
- 🛒 **Shopping Cart**: Add products to cart with quantity selection
- ➕ **CRUD Operations**: Create, Read, Update, and Delete products
- ✏️ **Product Management**: Add new products with custom details
- 🗑️ **Delete Products**: Remove products from the catalog
- 🧭 **Navigation**: Smooth navigation using go_router
- 🎨 **Modern UI**: Clean, Material Design 3 interface
- ⚡ **Reactive State Management**: Efficient BLoC pattern implementation

## State Management with BLoC

This app uses the **BLoC (Business Logic Component)** pattern for state management, which provides:

### What is BLoC?

BLoC is a design pattern that separates business logic from the UI. It uses **Streams** to manage state and events:

- **Events**: Actions triggered by the user (e.g., AddProduct, DeleteProduct)
- **States**: Different states of the app (e.g., Loading, Loaded, Error)
- **Bloc**: Transforms events into states

### Benefits of BLoC

1. **Separation of Concerns**: Business logic is completely separated from UI
2. **Testability**: Easy to test business logic independently
3. **Reusability**: Same BLoC can be used across multiple widgets
4. **Predictability**: Clear flow from events to states
5. **Scalability**: Easy to add new features without affecting existing code

### BLoC Architecture in This App

```
lib/
├── bloc/
│   ├── product/
│   │   ├── product_bloc.dart      # Handles product business logic
│   │   ├── product_event.dart     # Product events (LoadProducts, AddProduct, etc.)
│   │   └── product_state.dart     # Product states (Loading, Loaded, Error)
│   └── cart/
│       ├── cart_bloc.dart         # Handles cart business logic
│       ├── cart_event.dart        # Cart events (AddToCart, RemoveFromCart, etc.)
│       └── cart_state.dart        # Cart states (Initial, Loaded)
```

### Product BLoC Events

- `LoadProducts` - Fetch all products from data source
- `AddProduct` - Create a new product
- `UpdateProduct` - Modify an existing product
- `DeleteProduct` - Remove a product

### Product BLoC States

- `ProductInitial` - Initial state before loading
- `ProductLoading` - Data is being fetched
- `ProductLoaded` - Products successfully loaded
- `ProductError` - Error occurred during operation

### Cart BLoC Events

- `LoadCart` - Initialize cart
- `AddToCart` - Add product with quantity
- `RemoveFromCart` - Remove product from cart
- `UpdateCartQuantity` - Change product quantity
- `ClearCart` - Empty the entire cart

### Cart BLoC States

- `CartInitial` - Initial empty state
- `CartLoaded` - Cart with items and computed totals

## CRUD Operations

The app implements complete CRUD (Create, Read, Update, Delete) functionality:

### Create (Add Product)
- Navigate to Add Product screen via floating action button
- Fill in product details (title, price, category, description, color)
- BLoC event: `AddProduct(product)`
- New product is added to the product list

### Read (View Products)
- Home screen loads products with `LoadProducts` event
- Products displayed in grid layout
- Product details shown on dedicated screen

### Update (Edit Product)
- Edit functionality available on product detail screen
- BLoC event: `UpdateProduct(id, updatedProduct)`
- Currently shows "coming soon" message (ready for implementation)

### Delete (Remove Product)
- Delete button available on product detail screen
- Confirmation dialog before deletion
- BLoC event: `DeleteProduct(id)`
- Product removed from list

## Network Access in Flutter

### Current Implementation (In-Memory Storage)

This app uses **in-memory storage** for simplicity and learning purposes:

```dart
// In ProductBloc
void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
  emit(ProductLoading());
  try {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _products = List.from(sampleProducts);
    emit(ProductLoaded(_products));
  } catch (e) {
    emit(ProductError(e.toString()));
  }
}
```

### Real-World Network Access

In a production app, you would typically:

#### 1. Using HTTP Package

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Product>> fetchProducts() async {
  final response = await http.get(
    Uri.parse('https://api.example.com/products'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
```

#### 2. Using Dio Package (Advanced)

```dart
import 'package:dio/dio.dart';

class ProductRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.example.com',
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  ));

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await _dio.post('/products', data: product.toJson());
    return Product.fromJson(response.data);
  }
}
```

#### 3. BLoC with Real API

```dart
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await repository.getProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to load products: ${e.toString()}'));
    }
  }
}
```

### Network Best Practices

1. **Error Handling**: Always handle network errors gracefully
2. **Loading States**: Show loading indicators during network calls
3. **Timeout**: Set appropriate timeout durations
4. **Retry Logic**: Implement retry mechanisms for failed requests
5. **Caching**: Cache data locally to improve performance
6. **Authentication**: Include auth tokens in headers when needed
7. **SSL Pinning**: Use certificate pinning for sensitive apps

## Screenshots

The app includes the following screens:
1. **Home Screen**: Grid view of all products with loading state
2. **Product Detail Screen**: View details, adjust quantity, add to cart, delete product
3. **Cart Screen**: Review cart items with live total calculation
4. **Add Product Screen**: Form to create new products with validation

## Project Structure

```
lib/
├── bloc/
│   ├── product/
│   │   ├── product_bloc.dart
│   │   ├── product_event.dart
│   │   └── product_state.dart
│   └── cart/
│       ├── cart_bloc.dart
│       ├── cart_event.dart
│       └── cart_state.dart
├── data/
│   └── sample_products.dart        # Sample product data
├── models/
│   ├── product.dart                # Product data model
│   └── cart_item.dart              # Cart item model
├── router/
│   └── app_router.dart             # Go Router configuration
├── screens/
│   ├── home_screen.dart            # Main product listing
│   ├── product_detail_screen.dart  # Product details view
│   ├── cart_screen.dart            # Shopping cart
│   └── add_product_screen.dart     # Add new product form
└── main.dart                       # App entry point
```

## Dependencies

- `flutter`: SDK
- `go_router: ^14.6.2`: Declarative routing
- `flutter_bloc: ^8.1.6`: BLoC state management
- `equatable: ^2.0.7`: Value equality for BLoC states
- `cupertino_icons: ^1.0.8`: iOS-style icons

## Getting Started

### Prerequisites

- Flutter SDK 3.13.2 or higher
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android builds)
- Xcode (for iOS builds on macOS)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

   Or run on Chrome:
   ```bash
   flutter run -d chrome
   ```

## Navigation Structure

The app uses go_router with the following routes:

- `/` - Home screen (product listing)
- `/product/:id` - Product detail screen
- `/cart` - Shopping cart screen
- `/add-product` - Add new product screen

## Usage

### Adding Products (Create)
1. Tap the blue floating action button (+) on the home screen
2. Fill in product details:
   - Title (required)
   - Price (required, numeric)
   - Category (dropdown selection)
   - Description (required)
   - Background color (color picker)
3. Tap "Save product"
4. **BLoC Event**: `AddProduct` is dispatched
5. Navigate back to home screen with updated product list

### Viewing Products (Read)
1. App loads with `LoadProducts` event
2. Loading indicator shows while fetching data
3. Products displayed in grid layout
4. Tap any product to view full details

### Deleting Products (Delete)
1. Open product detail screen
2. Tap delete icon (trash) in app bar
3. Confirm deletion in dialog
4. **BLoC Event**: `DeleteProduct` is dispatched
5. Navigate back to home screen
6. Product removed from list

### Shopping
1. Browse products on home screen
2. Tap product card to view details
3. Adjust quantity using +/- buttons
4. Tap "Add to cart" button
5. **BLoC Event**: `AddToCart` is dispatched
6. Cart badge updates in real-time
7. View cart by tapping cart icon
8. Remove items with delete button
9. Tap "Checkout" to complete order
10. **BLoC Event**: `ClearCart` empties the cart

## Code Highlights

### BLoC Provider Setup
```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc()..add(LoadProducts()),
        ),
        BlocProvider(
          create: (context) => CartBloc()..add(LoadCart()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
      ),
    );
  }
}
```

### Using BLoC in UI
```dart
// Reading state
BlocBuilder<ProductBloc, ProductState>(
  builder: (context, state) {
    if (state is ProductLoading) {
      return CircularProgressIndicator();
    }
    if (state is ProductLoaded) {
      return GridView.builder(
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: state.products[index]);
        },
      );
    }
    return ErrorWidget(state.message);
  },
)

// Dispatching events
context.read<ProductBloc>().add(DeleteProduct(productId));
context.read<CartBloc>().add(AddToCart(product, quantity));
```

## Running Tests

```bash
flutter test
```

## Building for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Future Enhancements

- [x] BLoC pattern implementation
- [x] CRUD operations
- [ ] Update/Edit product functionality (UI ready, needs implementation)
- [ ] Product image upload
- [ ] Product search and filtering
- [ ] User authentication with BLoC
- [ ] Real API integration (HTTP/Dio)
- [ ] Local database (SQLite/Hive)
- [ ] Order history with BLoC
- [ ] Payment integration
- [ ] Product categories page
- [ ] Favorites/Wishlist with BLoC
- [ ] Product reviews and ratings
- [ ] Offline support with caching

## Learning Resources

### BLoC Pattern
- [Official BLoC Documentation](https://bloclibrary.dev/)
- [BLoC Architecture Guide](https://bloclibrary.dev/#/architecture)
- [Flutter BLoC Package](https://pub.dev/packages/flutter_bloc)

### Network Access in Flutter
- [HTTP Package](https://pub.dev/packages/http)
- [Dio Package](https://pub.dev/packages/dio)
- [Flutter Networking Guide](https://docs.flutter.dev/cookbook/networking)

### State Management
- [Flutter State Management Options](https://docs.flutter.dev/data-and-backend/state-mgmt/options)

## License

This project is open source and available under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
