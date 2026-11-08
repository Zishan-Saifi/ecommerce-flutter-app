# LuxeStore - Advanced Flutter E-Commerce App

A feature-rich E-Commerce mobile application built with Flutter, Provider state management, and DummyJSON REST API.

## 🚀 Features

### Core Requirements
- **REST API Integration:** Fetches live catalogue, thumbnails, stock, and ratings from DummyJSON.
- **Filtering & Sorting:** Filter by category pills and sort by Price (Low/High) & Rating.
- **Search:** Real-time product search.
- **Cart Management:** Add to cart, live quantity updates, item removal, and subtotal calculation.
- **Wishlist/Favorites:** Toggle favorite items across the app.
- **Local Persistence:** SharedPreferences keeps Cart and Favorites persistent across app restarts.
- **UI States:** Shimmer/loading skeletons, error handling, and empty states.

### Advanced / Bonus Extensions
- **Interactive Product Details:** Image gallery, product specifications, and customer reviews.
- **Checkout & Coupons:** Interactive discount coupons (`LUXE50` for 50% off, `SAVE20`).
- **Order Management:** Mock checkout flow with order history and order cancellation.

## 🛠️ Architecture & State Management
- **State Management:** `Provider` (`ChangeNotifierProvider`, `MultiProvider`)
  - `ProductProvider`: Handles catalogue fetching, search query, category filtering, and sorting logic.
  - `CartProvider`: Manages cart items, quantities, and persistent storage.
  - `FavoritesProvider`: Manages wishlist items and persistence.
  - `OrderProvider`: Tracks active orders and status updates.
- **Network Layer:** `http` package with modular Repository pattern.
- **Persistence:** `shared_preferences`.

## 📹 Demo Video
[Click here to watch the full walkthrough](PASTE_YOUR_VIDEO_LINK_HERE)

## 📸 Screenshots
*(Add your screenshot links or images here)*

## 🏃 How to Run
```bash
flutter pub get
flutter run -d chrome