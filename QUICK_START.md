# Quick Start Guide - Mini Market App

## 🚀 Running the App

### Option 1: Run on Chrome (Web)
```bash
flutter run -d chrome
```

### Option 2: Run on Windows Desktop
```bash
flutter run -d windows
```

### Option 3: Run on Android Emulator
1. Start an Android emulator
2. Run:
```bash
flutter run
```

### Option 4: Run on Physical Device
1. Connect your device via USB
2. Enable USB debugging
3. Run:
```bash
flutter run
```

## 📋 Prerequisites Check

Run this command to check if your environment is set up:
```bash
flutter doctor
```

## 🔧 Installation Steps

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Check for issues:**
   ```bash
   flutter analyze
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 🎯 Testing the App

### Test Flow 1: Browse and Add to Cart
1. App opens to Home Screen with 6 sample products
2. Tap on "Phone X" product card
3. On Product Detail screen, tap "+" to increase quantity to 3
4. Tap "Add to cart" button
5. Tap cart icon in app bar (notice the badge showing "3")
6. Verify cart shows "Headphones Qty 3" and total "$267.0"

### Test Flow 2: Add New Product
1. From Home Screen, tap the blue "+" button (FAB)
2. Fill in the form:
   - Title: "Desk Lamp"
   - Price: "45.50"
   - Category: Select "accessories"
   - Description: "LED desk lamp with adjustable brightness"
3. Select a color from the color picker
4. Tap "Save product"
5. Verify you're back on Home Screen
6. Verify new product appears in the grid

### Test Flow 3: Delete Product
1. Tap on any product to view details
2. Tap the red delete icon in app bar
3. Confirm deletion in the dialog
4. Verify product is removed from Home Screen

### Test Flow 4: Checkout
1. Add multiple products to cart
2. Navigate to cart
3. Tap "Checkout" button
4. Confirm in dialog
5. Verify cart is cleared and you're back on Home Screen

## 📱 Platform-Specific Notes

### Windows
- App runs natively on Windows 10/11
- Tested on Windows build

### Web (Chrome)
- Full functionality available
- Best experience on desktop browsers

### Android
- Requires Android SDK setup
- Min SDK version: Check android/app/build.gradle

### iOS
- Requires Xcode on macOS
- Requires Apple Developer account for physical device testing

## 🐛 Troubleshooting

### Issue: "No devices found"
**Solution:** 
- For web: `flutter run -d chrome`
- For Windows: `flutter run -d windows`
- For Android: Start an emulator or connect a device

### Issue: "flutter: command not found"
**Solution:**
- Ensure Flutter is added to PATH
- Restart terminal/command prompt

### Issue: Build fails
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Hot reload not working
**Solution:**
- Press 'r' in terminal for hot reload
- Press 'R' in terminal for hot restart

## 🎨 Customization Tips

### Change App Theme
Edit `lib/main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple), // Change color
  useMaterial3: true,
),
```

### Add More Sample Products
Edit `lib/data/sample_products.dart` and add more products to the list.

### Change Product Colors
Edit the `_colors` list in `lib/screens/add_product_screen.dart`.

## 📚 Key Files to Explore

1. **main.dart** - App entry point with Riverpod setup
2. **router/app_router.dart** - Navigation configuration
3. **providers/cart_provider.dart** - Shopping cart logic
4. **screens/home_screen.dart** - Main product grid
5. **models/product.dart** - Product data structure

## 🔥 Hot Tips

- Press 'r' in terminal for hot reload (fast)
- Press 'R' in terminal for hot restart (slow but complete)
- Press 'p' to toggle performance overlay
- Press 'q' to quit

## ✅ Features Checklist

After running, verify these features work:

- [ ] Home screen displays 6 products in a grid
- [ ] Tapping a product opens detail screen
- [ ] Cart icon shows badge with item count
- [ ] Can add items to cart with custom quantity
- [ ] Cart screen shows all items with total
- [ ] Can remove items from cart
- [ ] Can create new products via FAB
- [ ] Can delete products from detail screen
- [ ] Checkout clears cart and shows confirmation
- [ ] All navigation works smoothly

## 🎉 You're Ready!

The app is now running with full functionality:
- ✅ go_router for navigation
- ✅ Riverpod for state management
- ✅ Material Design 3 UI
- ✅ Shopping cart functionality
- ✅ Product management (add/delete)

Enjoy exploring the Mini Market app!
