class Coffee {
  final String id;
  final String name;
  final String description;
  final String flavor;
  final double price;
  final String size; // S, M, L
  final bool isIced;
  final bool isHot;
  final double rating;
  bool isFavorite;
  final String imageUrl;
  final List<String> ingredients;
  final int calories;
  final String brewMethod;
    // 🔥 New fields
  final String? note;
  final bool discountApplied;
  final double deliveryFee;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.flavor,
    required this.price,
    required this.size,
    required this.isIced,
    required this.isHot,
    required this.rating,
    this.isFavorite = false,
    required this.imageUrl,
    required this.ingredients,
    required this.calories,
    required this.brewMethod,
    this.note,                 // ✅ optional note
    this.discountApplied = false, // ✅ default false
    this.deliveryFee = 0.0,  
  });
  // In your Coffee model class
Coffee copyWith({
  String? id,
  String? name,
  String? description,
  double? price,
  double? rating,
  String? imageUrl,
  List<String>? ingredients,
  bool? isFavorite,
  int? calories,
  String? flavor,
  String? size,
  bool? isIced,
  bool? isHot,
  String? brewMethod,
 
}) {
  return Coffee(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    rating: rating ?? this.rating,
    imageUrl: imageUrl ?? this.imageUrl,
    ingredients: ingredients ?? this.ingredients,
    isFavorite: isFavorite ?? this.isFavorite,
    calories: calories ?? this.calories,
    flavor: flavor ?? this.flavor,
    size: size ?? this.size,
    isIced: isIced ?? this.isIced,
    isHot: isHot ?? this.isHot,
    brewMethod: brewMethod ?? this.brewMethod,
  );
}
}