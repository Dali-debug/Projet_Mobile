import 'review.dart';

class Nursery {
  final String id;
  final String name;
  final String address;
  final double distance;
  final double rating;
  final int reviewCount;
  final double price;
  final int availableSpots;
  final int totalSpots;
  final String hours;
  final String photo;
  final String description;
  final List<String> activities;
  final int staff;
  final String ageRange;
  final List<Review>? reviews;

  Nursery({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.availableSpots,
    required this.totalSpots,
    required this.hours,
    required this.photo,
    required this.description,
    required this.activities,
    required this.staff,
    required this.ageRange,
    this.reviews,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'distance': distance,
      'rating': rating,
      'reviewCount': reviewCount,
      'price': price,
      'availableSpots': availableSpots,
      'totalSpots': totalSpots,
      'hours': hours,
      'photo': photo,
      'description': description,
      'activities': activities,
      'staff': staff,
      'ageRange': ageRange,
      'reviews': reviews?.map((r) => r.toJson()).toList(),
    };
  }

  factory Nursery.fromJson(Map<String, dynamic> json) {
    return Nursery(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      distance: json['distance'].toDouble(),
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      price: json['price'].toDouble(),
      availableSpots: json['availableSpots'],
      totalSpots: json['totalSpots'],
      hours: json['hours'],
      photo: json['photo'],
      description: json['description'],
      activities: List<String>.from(json['activities']),
      staff: json['staff'],
      ageRange: json['ageRange'],
      reviews: json['reviews'] != null
          ? (json['reviews'] as List).map((r) => Review.fromJson(r)).toList()
          : null,
    );
  }
}
