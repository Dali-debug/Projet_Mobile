import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/utilisateur.dart';
import '../models/parent.dart';
import '../models/directeur.dart';
import '../utils/validators.dart';
import '../services/api_service.dart';

enum AuthMode { signin, signup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _mode = AuthMode.signin;
  UtilisateurType _userType = UtilisateurType.parent;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        if (_mode == AuthMode.signin) {
          // Authentification
          final result = await ApiService.login(
            _emailController.text,
            _passwordController.text,
          );

          if (!mounted) return;
          Navigator.pop(context); // Close loading

          if (result != null) {
            // Créer l'instance de l'utilisateur à partir des données de l'API
            final user = result['type'] == 'parent'
                ? Parent(
                    id: result['id'],
                    nom: result['nom'],
                    email: result['email'],
                    motDePasse: result['motdepasse'],
                    type: UtilisateurType.parent,
                  )
                : Directeur(
                    id: result['id'],
                    nom: result['nom'],
                    email: result['email'],
                    motDePasse: result['motdepasse'],
                    type: result['type'] == 'directeur'
                        ? UtilisateurType.directeur
                        : UtilisateurType.garderie,
                  );

            Provider.of<AppState>(context, listen: false).setUser(user);
          } else {
            _showError('Email ou mot de passe incorrect');
          }
        } else {
          // Inscription
          final typeString = _userType == UtilisateurType.parent
              ? 'parent'
              : _userType == UtilisateurType.directeur
                  ? 'directeur'
                  : 'garderie';

          final result = await ApiService.createUtilisateur(
            nom: _nameController.text.isEmpty
                ? 'Utilisateur'
                : _nameController.text,
            email: _emailController.text,
            motDePasse: _passwordController.text,
            type: typeString,
            telephone:
                _phoneController.text.isEmpty ? null : _phoneController.text,
          );

          if (!mounted) return;
          Navigator.pop(context); // Close loading

          if (result != null) {
            // Créer l'instance de l'utilisateur
            final user = _userType == UtilisateurType.parent
                ? Parent(
                    id: result['id'],
                    nom: result['nom'],
                    email: result['email'],
                    motDePasse: result['motdepasse'],
                    type: UtilisateurType.parent,
                  )
                : Directeur(
                    id: result['id'],
                    nom: result['nom'],
                    email: result['email'],
                    motDePasse: result['motdepasse'],
                    type: _userType,
                  );

            Provider.of<AppState>(context, listen: false).setUser(user);
          } else {
            _showError('Erreur lors de la création du compte');
          }
        }
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Close loading
        _showError('Erreur de connexion au serveur');
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFECFDF5), Color(0xFFEFF6FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 32),

                // Header
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
                    ),
                  ),
                  child: const Icon(Icons.child_care,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  _mode == AuthMode.signin ? 'Bienvenue' : 'Créer un compte',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _mode == AuthMode.signin
                      ? 'Connectez-vous pour continuer'
                      : 'Rejoignez JINEN aujourd\'hui',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 32),

                // User Type Selection (only for signup)
                if (_mode == AuthMode.signup) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Je suis',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _UserTypeButton(
                          icon: Icons.person,
                          label: 'Parent',
                          isSelected: _userType == UtilisateurType.parent,
                          color: const Color(0xFF10B981),
                          onTap: () => setState(
                              () => _userType = UtilisateurType.parent),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _UserTypeButton(
                          icon: Icons.child_care,
                          label: 'Garderie',
                          isSelected: _userType == UtilisateurType.garderie,
                          color: const Color(0xFF3B82F6),
                          onTap: () => setState(
                              () => _userType = UtilisateurType.garderie),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_mode == AuthMode.signup) ...[
                        const Text('Nom complet',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Votre nom',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Champ requis' : null,
                        ),
                        const SizedBox(height: 16),
                      ],
                      const Text('Email',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'votre@email.com',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      if (_mode == AuthMode.signup) ...[
                        const Text('Téléphone',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '+216 12345678',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: Validators.validateTunisianPhone,
                        ),
                        const SizedBox(height: 16),
                      ],
                      const Text('Mot de passe',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 16),
                      if (_mode == AuthMode.signin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(color: Color(0xFF10B981)),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ).copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                _mode == AuthMode.signin
                                    ? 'Se connecter'
                                    : 'Créer mon compte',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Toggle Mode
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _mode == AuthMode.signin
                          ? 'Pas encore de compte ?'
                          : 'Déjà inscrit ?',
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _mode = _mode == AuthMode.signin
                              ? AuthMode.signup
                              : AuthMode.signin;
                        });
                      },
                      child: Text(
                        _mode == AuthMode.signin
                            ? 'S\'inscrire'
                            : 'Se connecter',
                        style: const TextStyle(color: Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _UserTypeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE5E7EB),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : const Color(0xFF9CA3AF),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : const Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
