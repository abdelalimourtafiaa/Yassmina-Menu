class ProduitModel {
  int id_produit =0 ;
  String name = "";
  String description = "";
  double prix =0 ;
  String image = "";

  ProduitModel(
      this.id_produit, this.name, this.description, this.prix, this.image);

  ProduitModel.fromJson(Map json)
     :id_produit=json['id_produit'],
        name=json['name'],
        description=json['description'],
        prix=json['prix'],
        image=json['image'];


}
