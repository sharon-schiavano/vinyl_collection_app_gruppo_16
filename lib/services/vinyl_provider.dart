// Provider per la gestione dello stato dei vinili e delle categorie
// Utilizza il pattern Provider per gestire lo stato globale dell'applicazione

// Import necessari per il funzionamento del provider
import 'package:flutter/foundation.dart';  // Per ChangeNotifier e debugPrint
import '../models/vinyl.dart';              // Modello dati Vinyl
import '../models/category.dart' as models; // Modello dati Category (con alias)
import 'database_service.dart';             // Servizio per operazioni database

// Classe principale che gestisce lo stato dell'applicazione
// Estende ChangeNotifier per notificare i widget dei cambiamenti
class VinylProvider with ChangeNotifier {
  // === SERVIZI E DIPENDENZE ===
  // Istanza del servizio database per operazioni CRUD
  final DatabaseService _databaseService = DatabaseService();
  
  // === STATO PRIVATO DELL'APPLICAZIONE ===
  // Lista completa dei vinili caricati dal database
  List<Vinyl> _vinyls = [];
  // Lista delle categorie/generi musicali
  List<models.Category> _categories = [];
  // Lista filtrata dei vinili (per ricerche e filtri)
  List<Vinyl> _filteredVinyls = [];
  // Query di ricerca corrente
  String _searchQuery = '';
  // Genere selezionato per il filtro
  String _selectedGenre = 'Tutti';
  // Flag per indicare operazioni in corso
  bool _isLoading = false;
  
  // === GETTERS PUBBLICI ===
  // Accesso in sola lettura alla lista completa dei vinili
  List<Vinyl> get vinyls => _vinyls;
  // Accesso in sola lettura alla lista delle categorie
  List<models.Category> get categories => _categories;
  // Lista vinili da mostrare (filtrata o completa)
  List<Vinyl> get filteredVinyls => _filteredVinyls.isEmpty && _searchQuery.isEmpty && _selectedGenre == 'Tutti' ? _vinyls : _filteredVinyls;
  // Query di ricerca corrente
  String get searchQuery => _searchQuery;
  // Genere selezionato corrente
  String get selectedGenre => _selectedGenre;
  // Stato di caricamento
  bool get isLoading => _isLoading;
  
  // === GETTERS COMPUTATI ===
  // Lista dei vinili marcati come preferiti
  List<Vinyl> get favoriteVinyls => _vinyls.where((vinyl) => vinyl.isFavorite).toList();
  // Lista dei 5 vinili aggiunti più di recente
  List<Vinyl> get recentVinyls => _vinyls.take(5).toList();
  
  // === STATISTICHE ===
  // Numero totale di vinili nella collezione
  int get totalVinyls => _vinyls.length;
  // Numero di vinili preferiti
  int get favoriteCount => favoriteVinyls.length;
  
  // Distribuzione dei vinili per genere (per grafici e statistiche)
  Map<String, int> get genreDistribution {
    Map<String, int> distribution = {};
    // Conta i vinili per ogni genere
    for (var vinyl in _vinyls) {
      distribution[vinyl.genre] = (distribution[vinyl.genre] ?? 0) + 1;
    }
    return distribution;
  }

  // === METODI DI INIZIALIZZAZIONE ===
  
  // Metodo principale di inizializzazione del provider
  // Chiamato all'avvio dell'app per caricare tutti i dati necessari
  Future<void> initialize() async {
    // Imposta lo stato di caricamento e notifica i listener
    _isLoading = true;
    notifyListeners();
    
    try {
      // Carica tutti i vinili dal database
      await loadVinyls();
      // Carica tutte le categorie dal database
      await loadCategories();
    } catch (e) {
      // Gestisce eventuali errori durante l'inizializzazione
      debugPrint('Errore durante l\'inizializzazione: $e');
    } finally {
      // Rimuove lo stato di caricamento e notifica i listener
      _isLoading = false;
      notifyListeners();
    }
  }

  // === METODI DI CARICAMENTO DATI ===
  
  // Carica tutti i vinili dal database
  // Aggiorna la lista locale e applica i filtri correnti
  Future<void> loadVinyls() async {
    try {
      // Recupera tutti i vinili dal database
      _vinyls = await _databaseService.getAllVinyls();
      // Applica i filtri correnti alla lista caricata
      _applyFilters();
      // Notifica i widget che i dati sono cambiati
      notifyListeners();
    } catch (e) {
      // Gestisce errori durante il caricamento dei vinili
      debugPrint('Errore nel caricamento vinili: $e');
    }
  }

  // Carica tutte le categorie dal database
  // Aggiorna la lista locale delle categorie disponibili
  Future<void> loadCategories() async {
    try {
      // Recupera tutte le categorie dal database
      _categories = await _databaseService.getAllCategories();
      // Notifica i widget che i dati sono cambiati
      notifyListeners();
    } catch (e) {
      // Gestisce errori durante il caricamento delle categorie
      debugPrint('Errore nel caricamento categorie: $e');
    }
  }

  // === OPERAZIONI CRUD (Create, Read, Update, Delete) ===
  
  // Aggiunge un nuovo vinile alla collezione
  // Restituisce true se l'operazione ha successo, false altrimenti
  Future<bool> addVinyl(Vinyl vinyl) async {
    try {
      // Imposta stato di caricamento per feedback visivo
      _isLoading = true;
      notifyListeners();
      
      // Inserisce il vinile nel database e ottiene l'ID generato
      int id = await _databaseService.insertVinyl(vinyl);
      // Assegna l'ID al vinile
      vinyl.id = id;
      // Aggiunge il vinile in cima alla lista (più recenti prima)
      _vinyls.insert(0, vinyl);
      // Riapplica i filtri per aggiornare la vista filtrata
      _applyFilters();
      
      // Rimuove stato di caricamento e notifica successo
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Gestisce errori e ripristina stato normale
      debugPrint('Errore nell\'aggiunta del vinile: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Aggiorna un vinile esistente nella collezione
  // Restituisce true se l'operazione ha successo, false altrimenti
  Future<bool> updateVinyl(Vinyl vinyl) async {
    try {
      // Imposta stato di caricamento
      _isLoading = true;
      notifyListeners();
      
      // Aggiorna il vinile nel database
      await _databaseService.updateVinyl(vinyl);
      
      // Trova e aggiorna il vinile nella lista locale
      int index = _vinyls.indexWhere((v) => v.id == vinyl.id);
      if (index != -1) {
        _vinyls[index] = vinyl;
        // Riapplica i filtri per aggiornare la vista
        _applyFilters();
      }
      
      // Rimuove stato di caricamento e notifica successo
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Gestisce errori e ripristina stato normale
      debugPrint('Errore nell\'aggiornamento del vinile: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Elimina un vinile dalla collezione
  // Restituisce true se l'operazione ha successo, false altrimenti
  Future<bool> deleteVinyl(int id) async {
    try {
      // Imposta stato di caricamento
      _isLoading = true;
      notifyListeners();
      
      // Elimina il vinile dal database
      await _databaseService.deleteVinyl(id);
      // Rimuove il vinile dalla lista locale
      _vinyls.removeWhere((vinyl) => vinyl.id == id);
      // Riapplica i filtri per aggiornare la vista
      _applyFilters();
      
      // Rimuove stato di caricamento e notifica successo
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      // Gestisce errori e ripristina stato normale
      debugPrint('Errore nella cancellazione del vinile: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Cambia lo stato di preferito di un vinile
  // Restituisce true se l'operazione ha successo, false altrimenti
  Future<bool> toggleFavorite(int id) async {
    try {
      // Trova il vinile nella lista
      int index = _vinyls.indexWhere((vinyl) => vinyl.id == id);
      if (index != -1) {
        Vinyl vinyl = _vinyls[index];
        // Crea una copia con stato preferito invertito
        Vinyl updatedVinyl = vinyl.copyWith(isFavorite: !vinyl.isFavorite);
        // Aggiorna il vinile utilizzando il metodo updateVinyl
        return await updateVinyl(updatedVinyl);
      }
      return false;
    } catch (e) {
      // Gestisce errori durante il toggle
      debugPrint('Errore nel toggle favorito: $e');
      return false;
    }
  }

  // === METODI DI RICERCA E FILTRO ===
  
  // Imposta la query di ricerca e applica i filtri
  // Cerca nei campi: titolo, artista, etichetta e genere
  void searchVinyls(String query) {
    // Converte la query in minuscolo per ricerca case-insensitive
    _searchQuery = query.toLowerCase();
    // Applica tutti i filtri attivi
    _applyFilters();
    // Notifica i widget del cambiamento
    notifyListeners();
  }

  // Filtra i vinili per genere musicale
  // Accetta 'Tutti' per mostrare tutti i generi
  void filterByGenre(String genre) {
    // Imposta il genere selezionato
    _selectedGenre = genre;
    // Applica tutti i filtri attivi
    _applyFilters();
    // Notifica i widget del cambiamento
    notifyListeners();
  }

  // Rimuove tutti i filtri attivi
  // Ripristina la vista completa della collezione
  void clearFilters() {
    // Resetta la query di ricerca
    _searchQuery = '';
    // Resetta il filtro genere
    _selectedGenre = 'Tutti';
    // Svuota la lista filtrata
    _filteredVinyls = [];
    // Notifica i widget del cambiamento
    notifyListeners();
  }

  // Metodo privato che applica tutti i filtri attivi
  // Combina ricerca testuale e filtro per genere
  void _applyFilters() {
    // Crea una copia della lista completa
    List<Vinyl> filtered = List.from(_vinyls);
    
    // Applica filtro di ricerca testuale se presente
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((vinyl) {
        // Cerca in titolo, artista, etichetta e genere (case-insensitive)
        return vinyl.title.toLowerCase().contains(_searchQuery) ||
               vinyl.artist.toLowerCase().contains(_searchQuery) ||
               vinyl.label.toLowerCase().contains(_searchQuery) ||
               vinyl.genre.toLowerCase().contains(_searchQuery);
      }).toList();
    }
    
    // Applica filtro per genere se non è 'Tutti'
    if (_selectedGenre != 'Tutti') {
      filtered = filtered.where((vinyl) => vinyl.genre == _selectedGenre).toList();
    }
    
    // Aggiorna la lista filtrata
    _filteredVinyls = filtered;
  }

  // === METODI UTILITY ===
  
  // Trova un vinile specifico tramite ID
  // Restituisce null se non trovato
  Vinyl? getVinylById(int id) {
    try {
      // Cerca il primo vinile con l'ID specificato
      return _vinyls.firstWhere((vinyl) => vinyl.id == id);
    } catch (e) {
      // Restituisce null se non trovato
      return null;
    }
  }

  // Ottiene la lista di tutti i generi disponibili
  // Include 'Tutti' come prima opzione per i filtri
  List<String> get availableGenres {
    // Estrae tutti i generi unici dalla collezione
    Set<String> genres = _vinyls.map((vinyl) => vinyl.genre).toSet();
    // Crea lista con 'Tutti' come prima opzione
    List<String> genreList = ['Tutti'];
    // Aggiunge i generi ordinati alfabeticamente
    genreList.addAll(genres.toList()..sort());
    return genreList;
  }

  // Filtra i vinili per anno di pubblicazione
  // Utile per ricerche cronologiche
  List<Vinyl> getVinylsByYear(int year) {
    return _vinyls.where((vinyl) => vinyl.year == year).toList();
  }

  // Filtra i vinili per artista
  // Ricerca case-insensitive nel nome dell'artista
  List<Vinyl> getVinylsByArtist(String artist) {
    return _vinyls.where((vinyl) => 
        vinyl.artist.toLowerCase().contains(artist.toLowerCase())).toList();
  }

  // === METODI STATISTICI ===
  
  // Distribuzione dei vinili per anno di pubblicazione
  // Restituisce una mappa anno -> numero di vinili
  Map<int, int> get yearDistribution {
    Map<int, int> distribution = {};
    // Conta i vinili per ogni anno
    for (var vinyl in _vinyls) {
      distribution[vinyl.year] = (distribution[vinyl.year] ?? 0) + 1;
    }
    return distribution;
  }

  // Distribuzione dei vinili per condizione
  // Restituisce una mappa condizione -> numero di vinili
  Map<String, int> get conditionDistribution {
    Map<String, int> distribution = {};
    // Conta i vinili per ogni condizione
    for (var vinyl in _vinyls) {
      distribution[vinyl.condition] = (distribution[vinyl.condition] ?? 0) + 1;
    }
    return distribution;
  }

  // Ottiene i 5 vinili più vecchi della collezione
  // Ordinati per anno di pubblicazione crescente
  List<Vinyl> get oldestVinyls {
    List<Vinyl> sorted = List.from(_vinyls);
    // Ordina per anno crescente (più vecchi prima)
    sorted.sort((a, b) => a.year.compareTo(b.year));
    // Restituisce i primi 5
    return sorted.take(5).toList();
  }

  // Ottiene i 5 vinili più recenti della collezione
  // Ordinati per anno di pubblicazione decrescente
  List<Vinyl> get newestVinyls {
    List<Vinyl> sorted = List.from(_vinyls);
    // Ordina per anno decrescente (più recenti prima)
    sorted.sort((a, b) => b.year.compareTo(a.year));
    // Restituisce i primi 5
    return sorted.take(5).toList();
  }
}