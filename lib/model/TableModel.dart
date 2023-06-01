class TableModel {
  String? name;
  int? id_table;

  TableModel({

    required this.name,
    required this.id_table});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      name: json['name'] ,
      id_table: json['id_table'] ,
    );
  }
  // Method to convert ProduitModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id_table': id_table,
    };
  }

}