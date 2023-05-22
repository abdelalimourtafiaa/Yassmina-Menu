class CategorieModel {
    int? id ;
    String? name_category;
    String? icon;


  CategorieModel(
      {required this.id,
        required this.name_category,
        required this.icon
        });

  factory CategorieModel.fromJson(Map<String, dynamic> json) {
    return CategorieModel(
      id: json['id'],
      name_category: json['name_category'] ,
        icon: json['icon']
    );
  }
}
