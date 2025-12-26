import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/nursery.dart';
import '../services/api_service.dart';

class NurserySearch extends StatefulWidget {
  const NurserySearch({super.key});

  @override
  State<NurserySearch> createState() => _NurserySearchState();
}

class _NurserySearchState extends State<NurserySearch> {
  final _searchController = TextEditingController();
  List<Nursery> _nurseries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGarderies();
  }

  Future<void> _loadGarderies() async {
    try {
      final garderies = await ApiService.getGarderies();
      setState(() {
        _nurseries = garderies.map((g) => Nursery(
          id: g['idgarderie'].toString(),
          name: g['nom'] ?? '',
          address: g['adresse'] ?? '',
          distance: 0.0, // TODO: Calculate distance
          rating: 4.5, // TODO: Calculate from reviews
          reviewCount: 0, // TODO: Get from database
          price: (g['tarif'] ?? 0.0).toDouble(),
          availableSpots: (g['disponibilite'] ?? 0).toInt(),
          totalSpots: (g['disponibilite'] ?? 0).toInt(),
          hours: '7:00 - 18:00', // TODO: Add to database
          photo: g['photo'] ?? '',
          description: g['description'] ?? '',
          activities: [], // TODO: Get from database
          staff: 0, // TODO: Add to database
          ageRange: '1 - 5 ans', // TODO: Add to database
        )).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des garderies: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF00BFA5), Color(0xFF00ACC1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () =>
                          appState.setScreen(ScreenType.parentDashboard),
                    ),
                    const Expanded(
                      child: Text(
                        'Chercher une garderie',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white),
                      onPressed: () {
                        // Show filters
                      },
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Nom, adresse...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                ),
              ),

              // Location indicator
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: const [
                    Icon(Icons.location_on, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Tunis, Tunisia',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          _isLoading 
                            ? 'Chargement...' 
                            : _nurseries.isEmpty
                              ? 'Aucune garderie trouvée'
                              : '${_nurseries.length} garderie${_nurseries.length > 1 ? 's' : ''} trouvée${_nurseries.length > 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : _nurseries.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Aucune garderie disponible',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Les nouvelles garderies apparaîtront ici',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                itemCount: _nurseries.length,
                                itemBuilder: (context, index) {
                                  final nursery = _nurseries[index];
                                  return _NurseryCard(
                                    nursery: nursery,
                                    onTap: () => appState.selectNursery(nursery),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NurseryCard extends StatelessWidget {
  final Nursery nursery;
  final VoidCallback onTap;

  const _NurseryCard({
    required this.nursery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: nursery.photo.isNotEmpty
                        ? Image.network(
                            nursery.photo,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image,
                                    size: 64, color: Colors.grey),
                              );
                            },
                          )
                        : const Icon(Icons.image, size: 64, color: Colors.grey),
                  ),
                ),
                // Available spots badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BFA5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${nursery.availableSpots} places',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Rating badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: Color(0xFFFFB300)),
                        const SizedBox(width: 4),
                        Text(
                          nursery.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Distance
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${nursery.distance} km',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Address
                  Text(
                    nursery.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Info row
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${nursery.staff} personnel',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        nursery.hours,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        '(${nursery.reviewCount} avis)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${nursery.price} TND/mois',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00BFA5),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: nursery.availableSpots > 0
                              ? const Color(0xFF00BFA5).withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          nursery.availableSpots > 0
                              ? '✓ ${nursery.availableSpots} places disponibles'
                              : 'Complet',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: nursery.availableSpots > 0
                                ? const Color(0xFF00BFA5)
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
