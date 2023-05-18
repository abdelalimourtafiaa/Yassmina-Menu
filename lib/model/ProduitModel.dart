class ProduitModel {
  int? id_produit;
  String? name;
  String? description;
  double? prix;
  String? image ;
  int? id_category;


  ProduitModel(
      {required this.id_produit,
        required this.name,
        required this.description,
        required this.prix,
        required this.image,
        required this.id_category,});

  factory ProduitModel.fromJson(Map<String, dynamic> json) {
    return ProduitModel(
      id_produit: json['id_produit'],
      name: json['name'] ,
      description: json['description'] ,
      prix: double.parse(json['prix'].toString()) ,
      image: json['image'] ,
      id_category: json['id_category'],
    );
  }
}
