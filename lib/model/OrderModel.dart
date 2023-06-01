class OrderModel {
  String? image;
  String? name;
  double? prix;
  String? name_table ;

  OrderModel({
      required this.image,
      required this.name,
      required this.prix,
      required this.name_table,
      });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      name: json['name'] ,
      prix: double.parse(json['prix'].toString()) ,
      image: json['image'] ,
      name_table: json['name_table'] ,

    );
  }
  // Method to convert ProduitModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'prix': prix,
      'image': image,
      'name_table': name_table,

    };
  }

}