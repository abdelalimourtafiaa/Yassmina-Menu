class CategorieModel {
    int? id_category ;
    String? name_category;


  CategorieModel(
      {required this.id_category,
        required this.name_category,
        });

  factory CategorieModel.fromJson(Map<String, dynamic> json) {
    return CategorieModel(
      id_category: json['id_category'],
      name_category: json['name_category'] ,
    );
  }
}
