class ProduitModel {
  int? id;
  String? name;
  String? description;
  double? prix;
  String? image ;
  int? id_category;


  ProduitModel(
      {required this.id,
        required this.name,
        required this.description,
        required this.prix,
        required this.image,
        required this.id_category,});

  factory ProduitModel.fromJson(Map<String, dynamic> json) {
    return ProduitModel(
      id: json['id'],
      name: json['name'] ,
      description: json['description'] ,
      prix: double.parse(json['prix'].toString()) ,
      image: json['image'] ,
      id_category: json['id_category'],
    );
  }
}
