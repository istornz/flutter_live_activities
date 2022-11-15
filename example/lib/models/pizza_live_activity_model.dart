class PizzaLiveActivityModel {
  final String name;
  final String description;
  final int quantity;
  final double price;
  final String deliverName;
  final DateTime deliverDate;

  PizzaLiveActivityModel({
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.deliverName,
    required this.deliverDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'deliverName': deliverName,
      'deliverStartDate': DateTime.now().millisecondsSinceEpoch,
      'deliverEndDate': deliverDate.millisecondsSinceEpoch,
    };
  }
}
