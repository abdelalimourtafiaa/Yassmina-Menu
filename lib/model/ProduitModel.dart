class ProduitModel {
  int? id_produit;
  String? name;
  String? description;
  double? prix;
  String? image ;

  ProduitModel(
      {required this.id_produit,
        required this.name,
        required this.description,
        required this.prix,
        required this.image});

  factory ProduitModel.fromJson(Map<String, dynamic> json) {
    return ProduitModel(
      id_produit: json['id_produit'],
      name: json['name'] ,
      description: json['description'] ,
      prix: double.parse(json['prix'].toString()) ,
      image: json['image'] ,
    );
  }
}
