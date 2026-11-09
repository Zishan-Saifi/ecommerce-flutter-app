# 🛍️ LuxeStore - E-Commerce Flutter Application

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Provider](https://img.shields.io/badge/State_Management-Provider-blue?style=for-the-badge)](https://pub.dev/packages/provider)
[![Vercel Deployment](https://img.shields.io/badge/Deployment-Vercel-black?style=for-the-badge&logo=vercel&logoColor=white)](https://luxestore-ecommerce-two.vercel.app)

An advanced, responsive mobile e-commerce application developed for **DevCamp 2.0 (Week 4 • Project 4 - Compulsory)**. The application integrates live REST APIs, reactive state management, persistent local storage, and real-time checkout with coupon discounts.

---

## 🔗 Project & Demo Links

- **🌐 Live Production Web App:** [https://luxestore-ecommerce-app.vercel.app/](https://luxestore-ecommerce-app.vercel.app/)
- **📦 GitHub Repository:** [https://github.com/Zishan-Saifi/ecommerce-flutter-app](https://github.com/Zishan-Saifi/ecommerce-flutter-app)
- **📹 Demo Video Walkthrough:** [Click to Watch Demo Video](https://drive.google.com/drive/folders/1k9wxnikhBXXsPfPgMcuSDwYWxnL7TwHf) *(Make sure access is set to "Anyone with the link")*
- **📸 App Screenshots Folder:** [View Google Drive Screenshots](https://drive.google.com/drive/folders/1FESrjbGxq9PKiE7sKRCGH1UpfmXr9QPU)

---

## 🌟 Features Implemented

### 1. Core Compulsory Features
- **Public REST API Integration:** Fetches real-time catalogue items, categories, thumbnails, stock, and ratings from the [DummyJSON](https://dummyjson.com/) API.
- **Product Catalogue & Detailed View:**
  - Responsive product grid with badges for ratings, discounts, and brand details.
  - Comprehensive Product Detail screen featuring a multi-image gallery, real-time stock counters, service highlights, and customer reviews.
- **Category Filtering & Sorting:**
  - Dynamic category chips (`All`, `Beauty`, `Fragrances`, `Furniture`, `Groceries`, etc.) with active filter states.
  - Sorting by **Price: Low to High**, **Price: High to Low**, and **Customer Rating**.
- **Cart Management:**
  - Add to cart with quantity controls (+/-) and duplicate checks.
  - Item removal with real-time subtotal, shipping, and tax recalculation.
- **Wishlist / Favorites:**
  - Quick-toggle favorite state synced across Home grid, Product Detail, and Favorites screens.
- **Local Persistence:**
  - Cart items and Favorites are serialized and stored via `shared_preferences`, ensuring persistence across app restarts and reloads.
- **Robust UI States:**
  - Shimmer/skeleton loading placeholders during network fetches.
  - Empty states for Wishlist, Cart, and Orders with direct call-to-action buttons.
  - Network error handling with retry capability.

### 2. Optional Extensions (Bonus Points)
- **Real-Time Product Search:** Instant query filtering across product titles and categories.
- **Mock Checkout & Coupon System:**
  - Delivery address form and mock payment options (COD, Card).
  - Promo code verification: `LUXE50` (50% instant discount) and `SAVE20` with dynamic invoice recalculation.
- **Order History & Cancellation:**
  - Placed orders logged into persistent order management with timestamp and interactive cancellation.
- **Polished Responsive Design:**
  - Mobile viewport optimization with floating action buttons and live badge counters on bottom navigation.

---

## 🏗️ Architecture & State Management Approach

The application follows clean architecture with the Repository Pattern and `Provider` (`ChangeNotifierProvider`, `MultiProvider`):