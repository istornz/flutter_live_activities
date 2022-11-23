import 'package:live_activities/models/live_activity_image.dart';

class PizzaLiveActivityModel {
  final String name;
  final String description;
  final int quantity;
  final double price;
  final String deliverName;
  final DateTime deliverDate;
  final LiveActivityImageFromAsset? image;
  final LiveActivityImageFromUrl? shop;

  PizzaLiveActivityModel({
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.deliverName,
    required this.deliverDate,
    this.image,
    this.shop,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'image': image,
      'shop': shop,
      'price': price,
      'deliverName': deliverName,
      'deliverStartDate': DateTime.now().millisecondsSinceEpoch,
      'deliverEndDate': deliverDate.millisecondsSinceEpoch,
    };
  }
}
