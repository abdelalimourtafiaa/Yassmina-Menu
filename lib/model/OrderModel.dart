class OrderModel {
  String? image;
  String? name;
  double? prix;

  OrderModel({
      required this.image,
      required this.name,
      required this.prix});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      name: json['name'] ,
      prix: double.parse(json['prix'].toString()) ,
      image: json['image'] ,
    );
  }
  // Method to convert ProduitModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'prix': prix,
      'image': image,
    };
  }

}