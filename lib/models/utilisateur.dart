enum UtilisateurType { parent, directeur, garderie, autre }

abstract class Utilisateur {
  final int id;
  final String nom;
  final String email;
  final String motDePasse;
  final UtilisateurType type;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.email,
    required this.motDePasse,
    required this.type,
  });

  void sAuthentifier();
  void creerCompte();
}
