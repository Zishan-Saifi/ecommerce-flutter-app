class ProductReview {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;

  ProductReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      comment: json['comment'] ?? 'Great product, loved the quality!',
      date: json['date'] ?? '',
      reviewerName: json['reviewerName'] ?? 'Verified Buyer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date,
      'reviewerName': reviewerName,
    };
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String warrantyInformation;
  final String shippingInformation;
  final String thumbnail;
  final List<String> images;
  final List<ProductReview> reviews;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    this.brand = 'Luxe Brand',
    this.warrantyInformation = '1 Year Official Warranty',
    this.shippingInformation = 'Ships in 1-2 business days',
    required this.thumbnail,
    required this.images,
    this.reviews = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawReviews = json['reviews'] as List<dynamic>?;
    List<ProductReview> parsedReviews = [];
    if (rawReviews != null && rawReviews.isNotEmpty) {
      parsedReviews = rawReviews.map((r) => ProductReview.fromJson(r as Map<String, dynamic>)).toList();
    } else {
      // Default reviews agar API me na ho
      parsedReviews = [
        ProductReview(rating: 5, comment: 'Exceptional build quality and fast shipping!', date: '2 days ago', reviewerName: 'Rohit Sharma'),
        ProductReview(rating: 4, comment: 'Value for money, exactly as described.', date: '1 week ago', reviewerName: 'Priya Verma'),
      ];
    }

    return Product(
      id: json['id'] as int,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      brand: json['brand'] ?? 'Premium Luxury',
      warrantyInformation: json['warrantyInformation'] ?? '1 Year Brand Warranty',
      shippingInformation: json['shippingInformation'] ?? 'Free Standard Delivery',
      thumbnail: json['thumbnail'] ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      reviews: parsedReviews,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'thumbnail': thumbnail,
      'images': images,
      'reviews': reviews.map((r) => r.toJson()).toList(),
    };
  }
}