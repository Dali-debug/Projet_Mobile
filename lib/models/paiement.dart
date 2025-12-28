class Paiement {
  final int idPaiement;
  final double montant;
  final DateTime datePaiement;
  final String statut;

  Paiement({
    required this.idPaiement,
    required this.montant,
    required this.datePaiement,
    required this.statut,
  });

  // From JSON
  factory Paiement.fromJson(Map<String, dynamic> json) {
    return Paiement(
      idPaiement: json['idpaiement'] ?? json['idPaiement'] ?? 0,
      montant: (json['montant'] ?? 0).toDouble(),
      datePaiement: DateTime.parse(json['datepaiement'] ?? json['datePaiement'] ?? DateTime.now().toIso8601String()),
      statut: json['statut'] ?? '',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'idpaiement': idPaiement,
      'montant': montant,
      'datepaiement': datePaiement.toIso8601String(),
      'statut': statut,
    };
  }
}
