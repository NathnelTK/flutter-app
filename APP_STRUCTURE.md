# Mini Market App - Technical Structure

## Navigation Flow (go_router)

```
Home Screen (/)
    ├─> Product Detail (/product/:id) [tap on product card]
    │   ├─> Cart (/cart) [from app bar]
    │   └─> Back to Home [back button]
    │
    ├─> Cart (/cart) [tap cart icon in app bar]
    │   └─> Checkout [dialog] → Back to Home
    │
    └─> Add Product (/add-product) [tap FAB]
        └─> Back to Home with new product
```

## State Management Architecture

### Providers (Riverpod)

1. **ProductsNotifier**
   - Type: `StateNotifierProvider<ProductsNotifier, List<Product>>`
   - Initial State: Sample products from `sample_products.dart`
   - Actions:
     - `addProduct(Product)` - Add new product to list
     - `updateProduct(String id, Product)` - Update existing product
     - `deleteProduct(String id)` - Remove product from list

2. **CartNotifier**
   - Type: `StateNotifierProvider<CartNotifier, List<CartItem>>`
   - Initial State: Empty list
   - Actions:
     - `addToCart(Product, int quantity)` - Add or update cart item
     - `removeFromCart(String productId)` - Remove item
     - `updateQuantity(String productId, int quantity)` - Update item quantity
     - `clearCart()` - Remove all items

3. **Computed Providers**
   - `cartTotalProvider` - Calculates total cart value
   - `cartItemCountProvider` - Counts total items in cart

## Data Models

### Product
```dart
class Product {
  final String id;
  final String title;
  final double price;
  final String category;
  final String description;
  final IconData icon;
  final Color backgroundColor;
}
```

### CartItem
```dart
class CartItem {
  final Product product;
  final int quantity;
  double get totalPrice => product.price * quantity;
}
```

## Screens Breakdown

### 1. Home Screen (`home_screen.dart`)
**Route:** `/`

**Features:**
- Grid view of products (2 columns)
- Cart icon with badge showing item count
- Floating action button to add products
- Product cards with icon, title, and price
- Navigation to product details on card tap

**State:**
- Reads: `productsProvider`, `cartItemCountProvider`
- Updates: None (read-only)

### 2. Product Detail Screen (`product_detail_screen.dart`)
**Route:** `/product/:id`

**Features:**
- Large product icon display
- Product title, price, description
- Quantity selector (+/- buttons)
- Add to cart button
- Edit button (placeholder)
- Delete button with confirmation dialog

**State:**
- Reads: None (receives Product via route extra)
- Updates: 
  - `cartProvider.addToCart()`
  - `productsProvider.deleteProduct()`

### 3. Cart Screen (`cart_screen.dart`)
**Route:** `/cart`

**Features:**
- List of cart items with icons
- Item quantity display
- Remove item button
- Total amount calculation
- Checkout button with confirmation dialog
- Empty state illustration

**State:**
- Reads: `cartProvider`, `cartTotalProvider`
- Updates:
  - `cartProvider.removeFromCart()`
  - `cartProvider.clearCart()`

### 4. Add Product Screen (`add_product_screen.dart`)
**Route:** `/add-product`

**Features:**
- Form with validation
- Text inputs: title, price, description
- Dropdown: category selection
- Color picker for background
- Save button
- Auto-icon selection based on category

**State:**
- Reads: None
- Updates: `productsProvider.addProduct()`

## Color Scheme

The app uses a predefined color palette for product backgrounds:
- Light Blue: `#D4D9F7`
- Light Teal: `#D4F1E8`
- Light Peach: `#F5E1D4`
- Light Purple: `#E4D9F7`
- Light Green: `#DCE8D4`
- Light Pink: `#F5D9E8`

## Category → Icon Mapping

```dart
{
  'smartphones': Icons.smartphone,
  'audio': Icons.headphones,
  'clothing': Icons.checkroom,
  'computers': Icons.laptop,
  'electronics': Icons.camera_alt,
  'accessories': Icons.backpack,
}
```

## Key Dependencies Usage

### go_router
- Declarative routing configuration
- Type-safe navigation with named routes
- Passing objects via `extra` parameter
- Context extension methods: `context.push()`, `context.pop()`

### flutter_riverpod
- `ProviderScope` wrapping root widget
- `ConsumerWidget` for reactive UI
- `ConsumerStatefulWidget` for stateful reactive components
- `ref.watch()` for reactive reads
- `ref.read()` for one-time actions

## Sample Data

6 pre-populated products:
1. Phone X - $549.0 (smartphones)
2. Headphones - $89.0 (audio)
3. T-shirt - $15.0 (clothing)
4. Laptop - $899.0 (computers)
5. Camera - $320.0 (electronics)
6. Backpack - $42.0 (accessories)

## User Flows

### Add to Cart Flow
1. User taps product card → Navigate to Product Detail
2. User adjusts quantity (default: 1)
3. User taps "Add to cart" button
4. CartNotifier updates state
5. Success snackbar appears
6. Cart badge updates automatically

### Checkout Flow
1. User taps cart icon → Navigate to Cart
2. User reviews items (can remove items)
3. User sees total at bottom
4. User taps "Checkout" button
5. Confirmation dialog appears
6. User confirms → Cart cleared, navigate back to Home
7. Success snackbar appears

### Add Product Flow
1. User taps FAB → Navigate to Add Product
2. User fills form (all fields required)
3. User selects category (updates icon automatically)
4. User picks background color
5. User taps "Save product" button
6. Form validates
7. New product added to ProductsNotifier
8. Navigate back to Home
9. New product appears in grid

## Error Handling

- Form validation on Add Product screen
- Null checks for product deletion
- Minimum quantity of 1 in cart
- Empty cart state handling
- Confirmation dialogs for destructive actions

## UI/UX Features

- Material Design 3 components
- Rounded corners (12-16px radius)
- Subtle shadows on cards
- Color-coded product categories
- Smooth page transitions
- Snackbar feedback for user actions
- Confirmation dialogs for important actions
- Badge notifications on cart icon
- Empty states with icons and messages
