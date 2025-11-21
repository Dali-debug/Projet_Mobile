import 'notification.dart';
import 'enfant.dart';
import 'utilisateur.dart';

class Directeur extends Utilisateur {
  Directeur({
    required int id,
    required String nom,
    required String email,
    required String motDePasse,
  }) : super(id: id, nom: nom, email: email, motDePasse: motDePasse);

  void creerProfilGarderie() {}
  void mettreAJourProfil() {}
  void gererComptesInscrits() {}
  void ajouterDevoir(Enfant enfant) {}
  void envoyerEtatEnfant(Enfant enfant) {}
  void mettreAJourDisponibilite() {}
  void envoyerNotification(NotificationModel n) {}
}
