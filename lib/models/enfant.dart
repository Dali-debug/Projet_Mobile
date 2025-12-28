class Enfant {
  final int idEnfant;
  final String nom;
  final int age;
  final int? parentId;
  final int? garderieId;

  Enfant({
    required this.idEnfant,
    required this.nom,
    required this.age,
    this.parentId,
    this.garderieId,
  });

  // From JSON
  factory Enfant.fromJson(Map<String, dynamic> json) {
    return Enfant(
      idEnfant: json['idenfant'] ?? json['idEnfant'] ?? 0,
      nom: json['nom'] ?? '',
      age: json['age'] ?? 0,
      parentId: json['parent_id'],
      garderieId: json['garderie_id'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'idenfant': idEnfant,
      'nom': nom,
      'age': age,
      'parent_id': parentId,
      'garderie_id': garderieId,
    };
  }

  void mettreAJourEtat() {}
  void ajouterDevoir(dynamic d) {}
}
