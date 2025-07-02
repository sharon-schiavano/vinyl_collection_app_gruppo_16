import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

// Import dei servizi e schermate necessari
import 'services/vinyl_provider.dart';
import 'screens/add_edit_vinyl_screen.dart';
import 'utils/constants.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              // === HEADER: Intestazione app ===
              _buildHeader(),
              SizedBox(height: AppConstants.spacingLarge),
              
              // === CONTENT: Contenuto principale scrollabile ===
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // === RECENT VINYLS: Vinili recenti ===
                      _buildRecentVinylsSection(context),
                      SizedBox(height: AppConstants.spacingLarge),
                      
                      // === FAVORITE VINYLS: Vinili preferiti ===
                      _buildFavoriteVinylsSection(context),
                      SizedBox(height: AppConstants.spacingLarge),
                      
                      // === RANDOM VINYLS: Vinili casuali consigliati ===
                      _buildRandomVinylsSection(context),
                      SizedBox(height: AppConstants.spacingLarge),

                      // === STATS: Statistiche rapide ===
                      _buildQuickStatsSection(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // NAVIGATION: Naviga alla schermata aggiunta vinile
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditVinylScreen(),
            ),
          );
          
          // REFRESH: Ricarica dati se vinile aggiunto con successo
          if (result == true && mounted) {
            // Il provider si aggiorna automaticamente tramite notifyListeners
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text('Vinile aggiunto alla collezione!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        backgroundColor: AppConstants.primaryColor,
        tooltip: 'Aggiungi nuovo vinile',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  // === HEADER: Widget intestazione ===
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'La tua collezione di vinili',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Icon(
            Icons.account_circle,
            color: AppConstants.primaryColor,
            size: 32,
          ),
        ),
      ],
    );
  }
  
  // === RECENT VINYLS SECTION: Sezione vinili recenti ===
  Widget _buildRecentVinylsSection(BuildContext context) {
    return Consumer<VinylProvider>(
      builder: (context, provider, child) {
        final recentVinyls = provider.recentVinyls;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(
                  'Aggiunti di Recente',
                  Icons.schedule,
                  onTap: () {
                    Navigator.pushNamed(context, '/listaVinili_view');
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/listaVinili_view');
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppConstants.primaryColor,
                    size: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppConstants.spacingMedium),
            if (recentVinyls.isEmpty)
              _buildEmptyState(
                'Nessun vinile aggiunto',
                'Inizia aggiungendo il tuo primo vinile alla collezione!',
                Icons.album,
              )
            else
              SizedBox(
                height: 165,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  itemCount: recentVinyls.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: AppConstants.spacingMedium),
                  itemBuilder: (context, index) {
                    final vinyl = recentVinyls[index];
                    return _buildVinylCard(vinyl, context);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
  
  // === FAVORITE VINYLS SECTION: Sezione vinili preferiti ===
  Widget _buildFavoriteVinylsSection(BuildContext context) {
    return Consumer<VinylProvider>(
      builder: (context, provider, child) {
        final favoriteVinyls = provider.favoriteVinyls;
        
        return Column(
          children: [
            _buildSectionHeader(
              'I Tuoi Preferiti',
              Icons.favorite,
              onTap: () {
                // Funzionalità da implementare: navigazione alla lista preferiti
                Navigator.pushNamed(context, '/analisi_view');
              },
            ),
            SizedBox(height: AppConstants.spacingMedium),
            
            if (favoriteVinyls.isEmpty)
              _buildEmptyState(
                'Nessun preferito',
                'Marca i tuoi vinili preferiti per vederli qui!',
                Icons.favorite_border,
              )
            else
              SizedBox(
                height: 165,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  itemCount: favoriteVinyls.length,
                  separatorBuilder: (context, index) => 
                      SizedBox(width: AppConstants.spacingMedium),
                  itemBuilder: (context, index) {
                    final vinyl = favoriteVinyls[index];
                    return _buildVinylCard(vinyl, context);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
  
  // === QUICK STATS SECTION: Sezione statistiche rapide ===
  Widget _buildQuickStatsSection(BuildContext context) {
    return Consumer<VinylProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            _buildSectionHeader(
              'Statistiche Rapide',
              Icons.analytics,
              onTap: () {
                // Funzionalità da implementare: navigazione alle statistiche complete
                Navigator.pushNamed(context, '/analisi_view');
              },
            ),
            SizedBox(height: AppConstants.spacingMedium),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Totale Vinili',
                    provider.totalVinyls.toString(),
                    Icons.album,
                    AppConstants.primaryColor,
                  ),
                ),
                SizedBox(width: AppConstants.spacingMedium),
                Expanded(
                  child: _buildStatCard(
                    'Preferiti',
                    provider.favoriteCount.toString(),
                    Icons.favorite,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildRandomVinylsSection(BuildContext context) {
    return Consumer<VinylProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            _buildSectionHeader(
              'Vinili Consigliati',
              Icons.recommend,
              onTap: () {
                // da cambiare!
              },
            ),
            SizedBox(height: AppConstants.spacingMedium),

            if (provider.randomVinyls.isEmpty)
              _buildEmptyState(
                'Nessun vinile consigliato',
                'Aggiungi vinili alla tua collezione per ricevere consigli!',
                Icons.recommend,
              )
            else
              SizedBox(
                height: 165,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  itemCount: provider.randomVinyls.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: AppConstants.spacingMedium),
                  itemBuilder: (context, index) {
                    final vinyl = provider.randomVinyls[index];
                    return _buildVinylCard(vinyl, context);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
          


  // === SECTION HEADER: Widget intestazione sezione ===
  Widget _buildSectionHeader(String title, IconData icon, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppConstants.primaryColor,
              size: 24,
            ),
            SizedBox(width: AppConstants.spacingSmall),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
          ],
        ),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(4),
            ),
          ),
      ],
    );
  }
  
  // === VINYL CARD: Widget card vinile ===
  Widget _buildVinylCard(vinyl, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // NAVIGATION: Naviga alla schermata dettaglio vinile
        await Navigator.pushNamed(
          context,
          '/DettaglioVinile',
          arguments: vinyl,
        );
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE: Immagine copertina
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppConstants.borderRadius),
                ),
              ),
              child: vinyl.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppConstants.borderRadius),
                      ),
                      child: Image.file(
                        File(vinyl.imagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildImagePlaceholder();
                        },
                      ),
                    )
                  : _buildImagePlaceholder(),
            ),
            
            // INFO: Informazioni vinile
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vinyl.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      vinyl.artist,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vinyl.year.toString(),
                          style: TextStyle(
                            color: AppConstants.primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (vinyl.isFavorite)
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 12,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // === IMAGE PLACEHOLDER: Placeholder per immagine ===
  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Icons.album,
        color: AppConstants.primaryColor.withValues(alpha: 0.5),
        size: 40,
      ),
    );
  }
  
  // === EMPTY STATE: Widget stato vuoto ===
  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.grey[400],
              size: 48,
            ),
            SizedBox(height: AppConstants.spacingSmall),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  // === STAT CARD: Widget card statistica ===
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          SizedBox(height: AppConstants.spacingSmall),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

