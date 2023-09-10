class Ingredient {
  Ingredient({required this.title, required this.quantity});

  String title;
  String quantity;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
        title: json['title'] ?? '', quantity: json['quantity'] ?? '');
  }

  @override
  String toString() {
    return 'Ingredient{title: $title, quantity: $quantity}';
  }
}