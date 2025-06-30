import 'package:sqflite/sqflite.dart';
// Importazioni necessarie per la gestione del database SQLite
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vinyl.dart';
import '../models/category.dart' as models;
import '../utils/constants.dart';

// === SERVIZIO DATABASE ===
// Gestisce tutte le operazioni di database per l'app Vinyl Collection
// Implementa il pattern Singleton per garantire una sola istanza
class DatabaseService {
  // Istanza singleton del servizio database
  static final DatabaseService _instance = DatabaseService._internal();
  // Factory constructor che restituisce sempre la stessa istanza
  factory DatabaseService() => _instance;
  // Constructor privato per il pattern Singleton
  DatabaseService._internal();

  // Istanza del database SQLite (nullable fino all'inizializzazione)
  static Database? _database;

  // Getter per ottenere l'istanza del database
  // Inizializza il database se non ancora fatto
  Future<Database> get database async {
    // Se il database è già inizializzato, lo restituisce
    if (_database != null) return _database!;
    // Altrimenti inizializza il database
    _database = await _initDatabase();
    return _database!;
  }

  // Metodo privato per inizializzare il database
  // Crea il file del database e definisce la struttura delle tabelle
  Future<Database> _initDatabase() async {
    // Ottiene il percorso per il database usando le costanti dell'app
    String path = join(await getDatabasesPath(), AppConstants.databaseName);
    // Apre/crea il database con la versione specificata
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDatabase, // Callback per creare le tabelle
    );
  }

  // Metodo per creare la struttura del database
  // Viene chiamato solo alla prima creazione del database
  Future<void> _createDatabase(Database db, int version) async {
    // === CREAZIONE TABELLA VINILI ===
    // Tabella principale per memorizzare i dati dei vinili
    await db.execute('''
      CREATE TABLE ${AppConstants.vinylTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,  -- ID univoco auto-incrementale
        title TEXT NOT NULL,                   -- Titolo dell'album
        artist TEXT NOT NULL,                  -- Nome dell'artista
        year INTEGER NOT NULL,                 -- Anno di pubblicazione
        genre TEXT NOT NULL,                   -- Genere musicale
        label TEXT NOT NULL,                   -- Casa discografica
        condition TEXT NOT NULL,               -- Condizione del vinile
        isFavorite INTEGER NOT NULL DEFAULT 0, -- Flag preferito (0/1)
        imagePath TEXT,                        -- Percorso immagine copertina
        dateAdded TEXT NOT NULL,               -- Data aggiunta alla collezione
        notes TEXT                             -- Note aggiuntive
      )
    ''');

    // === CREAZIONE TABELLA CATEGORIE ===
    // Tabella per organizzare i vinili in categorie personalizzate
    await db.execute('''
      CREATE TABLE ${AppConstants.categoryTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,  -- ID univoco auto-incrementale
        name TEXT NOT NULL UNIQUE,
        description TEXT,
        vinylCount INTEGER NOT NULL DEFAULT 0,
        dateCreated TEXT NOT NULL
      )
    ''');

    // Inserimento categorie predefinite
    for (String genre in AppConstants.defaultGenres) {
      await db.insert(AppConstants.categoryTable, {
        'name': genre,
        'description': 'Genere musicale $genre',
        'vinylCount': 0,
        'dateCreated': DateTime.now().toIso8601String(),
      });
    }
  }

  // CRUD Operations per Vinyl
  Future<int> insertVinyl(Vinyl vinyl) async {
    final db = await database;
    int id = await db.insert(AppConstants.vinylTable, vinyl.toMap());
    await _updateCategoryCount(vinyl.genre, 1);
    return id;
  }

  Future<List<Vinyl>> getAllVinyls() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.vinylTable,
      orderBy: 'dateAdded DESC',
    );
    return List.generate(maps.length, (i) => Vinyl.fromMap(maps[i]));
  }

  Future<Vinyl?> getVinylById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.vinylTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Vinyl.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Vinyl>> getRecentVinyls({int limit = 5}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.vinylTable,
      orderBy: 'dateAdded DESC',
      limit: limit,
    );
    return List.generate(maps.length, (i) => Vinyl.fromMap(maps[i]));
  }

  Future<List<Vinyl>> getFavoriteVinyls() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.vinylTable,
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'dateAdded DESC',
    );
    return List.generate(maps.length, (i) => Vinyl.fromMap(maps[i]));
  }

  Future<List<Vinyl>> searchVinyls(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.vinylTable,
      where: 'title LIKE ? OR artist LIKE ? OR label LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'dateAdded DESC',
    );
    return List.generate(maps.length, (i) => Vinyl.fromMap(maps[i]));
  }

  Future<List<Vinyl>> getVinylsByGenre(String genre) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.vinylTable,
      where: 'genre = ?',
      whereArgs: [genre],
      orderBy: 'dateAdded DESC',
    );
    return List.generate(maps.length, (i) => Vinyl.fromMap(maps[i]));
  }

  Future<void> updateVinyl(Vinyl vinyl) async {
    final db = await database;
    await db.update(
      AppConstants.vinylTable,
      vinyl.toMap(),
      where: 'id = ?',
      whereArgs: [vinyl.id],
    );
  }

  Future<void> deleteVinyl(int id) async {
    final db = await database;
    // Ottieni il vinile per conoscere il genere
    final vinyl = await getVinylById(id);
    if (vinyl != null) {
      await db.delete(
        AppConstants.vinylTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      await _updateCategoryCount(vinyl.genre, -1);
    }
  }

  // CRUD Operations per Category
  Future<List<models.Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.categoryTable,
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => models.Category.fromMap(maps[i]));
  }

  Future<void> _updateCategoryCount(String categoryName, int delta) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE ${AppConstants.categoryTable} SET vinylCount = vinylCount + ? WHERE name = ?',
      [delta, categoryName],
    );
  }

  // Statistiche
  Future<int> getTotalVinylCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM ${AppConstants.vinylTable}');
    return result.first['count'] as int;
  }

  Future<Map<String, int>> getGenreDistribution() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT genre, COUNT(*) as count FROM ${AppConstants.vinylTable} GROUP BY genre ORDER BY count DESC'
    );
    
    Map<String, int> distribution = {};
    for (var row in result) {
      distribution[row['genre']] = row['count'];
    }
    return distribution;
  }

  Future<List<Vinyl>> getOldestVinyls({int limit = 5}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.vinylTable,
      orderBy: 'year ASC',
      limit: limit,
    );
    return List.generate(maps.length, (i) => Vinyl.fromMap(maps[i]));
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}