class Activite {
  final int idActivite;
  final String titre;
  final String description;

  Activite({
    required this.idActivite,
    required this.titre,
    required this.description,
  });

  // From JSON
  factory Activite.fromJson(Map<String, dynamic> json) {
    return Activite(
      idActivite: json['idactivite'] ?? json['idActivite'] ?? 0,
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'idactivite': idActivite,
      'titre': titre,
      'description': description,
    };
  }
}
