class FoodItem {
  String? name;
  int? price;
  String? image;
  bool? availability;

  FoodItem({
    this.name,
    this.price,
    this.availability,
    this.image,
  });

  FoodItem.fromMap(Map<String, dynamic> snapshot)
      : name = snapshot['name'] ?? '',
        price = snapshot['price'] ?? 0,
        availability = snapshot['description'] ?? false,
        image = snapshot['image'] ?? '';

  toJson() {
    return {
      "name": name,
      "price": price,
      "availability": availability,
      "image": image,
    };
  }
}
