# Vinyl Collection App - Gruppo 16

Un'applicazione Flutter per la gestione di una collezione di vinili con funzionalità complete di catalogazione, ricerca e analisi.

## 📱 Caratteristiche

- **Gestione Collezione**: Aggiungi, modifica ed elimina vinili dalla tua collezione
- **Ricerca Avanzata**: Cerca per titolo, artista, etichetta o genere
- **Categorie**: Organizza i vinili per genere musicale
- **Preferiti**: Marca i tuoi vinili preferiti
- **Statistiche**: Visualizza analisi della tua collezione
- **Interfaccia Responsive**: Ottimizzata per diverse dimensioni di schermo
- **Persistenza Dati**: Database SQLite locale

## 🚀 Stato del Progetto

### ✅ Fase 1 Completata - Setup e Architettura

- [x] Configurazione progetto Flutter
- [x] Aggiunta dipendenze (sqflite, provider, image_picker, fl_chart)
- [x] Struttura cartelle organizzata
- [x] Modelli dati (Vinyl, Category)
- [x] Servizio database con SQLite
- [x] Provider per gestione stato
- [x] Configurazione tema e costanti
- [x] Splash screen e navigazione base

### 🔄 Prossime Fasi

#### Fase 2 - Interfacce Utente
- [ ] Schermata principale con lista vinili
- [ ] Schermata dettaglio vinile
- [ ] Schermata aggiunta/modifica vinile
- [ ] Schermata categorie
- [ ] Schermata ricerca
- [ ] Widget riutilizzabili

#### Fase 3 - Funzionalità Avanzate
- [ ] Integrazione fotocamera per copertine
- [ ] Grafici e statistiche
- [ ] Filtri avanzati
- [ ] Esportazione dati

#### Fase 4 - Test e Ottimizzazione
- [ ] Test unitari
- [ ] Test widget
- [ ] Ottimizzazione performance
- [ ] Documentazione completa

## 🛠️ Tecnologie Utilizzate

- **Flutter**: Framework UI multipiattaforma
- **Dart**: Linguaggio di programmazione
- **SQLite**: Database locale (sqflite)
- **Provider**: Gestione stato
- **FL Chart**: Grafici e statistiche
- **Image Picker**: Selezione immagini

## 📁 Struttura del Progetto

```
lib/
├── models/
│   ├── vinyl.dart          # Modello dati vinile
│   └── category.dart       # Modello dati categoria
├── services/
│   ├── database_service.dart   # Servizio database SQLite
│   └── vinyl_provider.dart     # Provider gestione stato
├── screens/
│   └── (da implementare in Fase 2)
├── widgets/
│   └── (da implementare in Fase 2)
├── utils/
│   └── constants.dart      # Costanti applicazione
└── main.dart              # Entry point applicazione
```

## 🚀 Come Avviare l'Applicazione

### Prerequisiti
- Flutter SDK (versione 3.8.1 o superiore)
- Dart SDK
- IDE (VS Code, Android Studio, ecc.)

### Installazione

1. **Installa le dipendenze**
   ```bash
   flutter pub get
   ```

2. **Verifica i dispositivi disponibili**
   ```bash
   flutter devices
   ```

3. **Avvia l'applicazione**
   ```bash
   # Per Windows
   flutter run -d windows
   
   # Per Web
   flutter run -d chrome
   
   # Per Android (con emulatore/dispositivo connesso)
   flutter run -d android
   ```

### Da VS Code

1. Apri il progetto in VS Code
2. Assicurati di avere le estensioni Flutter e Dart installate
3. Seleziona il dispositivo target dalla barra di stato
4. Premi `F5` o usa `Ctrl+Shift+P` → "Flutter: Run Flutter App"

## 📊 Database Schema

### Tabella Vinili
```sql
CREATE TABLE vinyls (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  artist TEXT NOT NULL,
  year INTEGER NOT NULL,
  genre TEXT NOT NULL,
  label TEXT NOT NULL,
  condition TEXT NOT NULL,
  isFavorite INTEGER NOT NULL DEFAULT 0,
  imagePath TEXT,
  dateAdded TEXT NOT NULL,
  notes TEXT
);
```

### Tabella Categorie
```sql
CREATE TABLE categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  vinylCount INTEGER NOT NULL DEFAULT 0,
  dateCreated TEXT NOT NULL
);
```

## 🎨 Design System

- **Colore Primario**: Deep Purple
- **Tema**: Material Design 3
- **Tipografia**: Roboto (default Flutter)
- **Icone**: Material Icons
- **Elevazione**: Card con ombra sottile
- **Border Radius**: 12px per consistenza

## 👥 Team

**Gruppo 16** - Mobile Programming

---

*Ultima modifica: Fase 1 completata*
