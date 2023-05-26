class TableModel {
  String? name;
  int? id;

  TableModel({

    required this.name,
    required this.id});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      name: json['name'] ,
      id: json['id'] ,
    );
  }
  // Method to convert ProduitModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }

}