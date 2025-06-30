// Import delle librerie Flutter necessarie per l'interfaccia utente
import 'package:flutter/material.dart';
// Import del package Provider per la gestione dello stato dell'applicazione
import 'package:provider/provider.dart';
// Import del nostro provider personalizzato per la gestione dei dati dei vinili
import 'services/vinyl_provider.dart';
// Import delle costanti dell'applicazione (colori, dimensioni, stringhe)
import 'utils/constants.dart';

// Funzione main: punto di ingresso dell'applicazione Flutter
void main() {
  // Avvia l'applicazione Flutter con il widget root VinylCollectionApp
  runApp(const VinylCollectionApp());
}

// Widget principale dell'applicazione - estende StatelessWidget perché non ha stato interno
class VinylCollectionApp extends StatelessWidget {
  // Costruttore const per ottimizzazioni delle performance
  const VinylCollectionApp({super.key});

  // Metodo build: definisce la struttura dell'interfaccia utente
  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider: fornisce il VinylProvider a tutti i widget figli
    // Questo permette la gestione centralizzata dello stato dell'applicazione
    return ChangeNotifierProvider(
      // create: crea una nuova istanza di VinylProvider e la inizializza
      // L'operatore .. (cascade) permette di chiamare initialize() sull'istanza appena creata
      create: (context) => VinylProvider()..initialize(),
      // child: definisce l'app Flutter vera e propria
      child: MaterialApp(
        // Titolo dell'applicazione (visibile nel task manager e nelle impostazioni)
        title: AppConstants.appName,
        // Nasconde il banner "DEBUG" nell'angolo in alto a destra durante lo sviluppo
        debugShowCheckedModeBanner: false,
        // Configurazione del tema dell'applicazione per un design consistente
        theme: ThemeData(
          // Colore primario del Material Design (palette di colori predefinita)
          primarySwatch: Colors.deepPurple,
          // Colore primario personalizzato definito nelle nostre costanti
          primaryColor: AppConstants.primaryColor,
          // Schema di colori generato automaticamente dal colore primario
          // Crea una palette completa di colori complementari
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor,
            brightness: Brightness.light, // Tema chiaro
          ),
          // Tema personalizzato per tutte le AppBar dell'applicazione
          appBarTheme: const AppBarTheme(
            backgroundColor: AppConstants.primaryColor, // Colore di sfondo
            foregroundColor: Colors.white, // Colore del testo e delle icone
            elevation: 0, // Rimuove l'ombra per un design più moderno
          ),
          // Tema personalizzato per tutte le Card dell'applicazione
          cardTheme: CardThemeData(
            elevation: AppConstants.cardElevation, // Altezza dell'ombra delle card
            // Forma delle card con bordi arrotondati
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          // Tema personalizzato per tutti i campi di input (TextField, TextFormField)
          inputDecorationTheme: InputDecorationTheme(
            // Bordo con outline e angoli arrotondati
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            filled: true, // Abilita il riempimento del background
            fillColor: Colors.grey[50], // Colore di sfondo molto chiaro
          ),
          // Tema personalizzato per tutti i pulsanti ElevatedButton
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor, // Colore di sfondo
              foregroundColor: Colors.white, // Colore del testo
              // Forma del pulsante con bordi arrotondati
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              // Padding interno del pulsante per una migliore usabilità
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium, // Padding orizzontale
                vertical: AppConstants.paddingSmall, // Padding verticale
              ),
            ),
          ),
        ),
        // Schermata iniziale dell'applicazione: mostra la SplashScreen
        home: const SplashScreen(),
      ),
    );
  }
}

// SplashScreen: schermata di caricamento mostrata all'avvio dell'app
// Estende StatefulWidget perché deve gestire la navigazione temporizzata
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  // Crea lo stato associato al widget
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Classe di stato per SplashScreen - gestisce il ciclo di vita e la logica
class _SplashScreenState extends State<SplashScreen> {
  // initState: chiamato una sola volta quando il widget viene creato
  @override
  void initState() {
    super.initState(); // Chiama il metodo della classe padre
    _navigateToHome(); // Avvia il timer per la navigazione
  }

  // Metodo privato per gestire la navigazione temporizzata alla home
  _navigateToHome() async {
    // Aspetta 2 secondi prima di procedere (simula caricamento)
    await Future.delayed(const Duration(seconds: 2));
    // Verifica che il widget sia ancora montato prima di navigare
    // Questo previene errori se l'utente esce dall'app durante il caricamento
    if (mounted) {
      // Naviga alla HomeScreen sostituendo la SplashScreen nello stack
      // pushReplacement rimuove la splash screen dalla cronologia
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  // build: costruisce l'interfaccia utente della splash screen
  @override
  Widget build(BuildContext context) {
    // Scaffold: struttura base della schermata con background e body
    return Scaffold(
      // Sfondo con il colore primario dell'app
      backgroundColor: AppConstants.primaryColor,
      // Body centrato per posizionare il contenuto al centro dello schermo
      body: const Center(
        // Column: dispone i widget verticalmente
        child: Column(
          // Centra i widget verticalmente nello spazio disponibile
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icona del vinile come logo dell'app
            Icon(
              Icons.album, // Icona Material Design per album/vinile
              size: 100, // Dimensione grande per impatto visivo
              color: Colors.white, // Colore bianco per contrasto
            ),
            // Spazio verticale tra icona e titolo
            SizedBox(height: AppConstants.spacingMedium),
            // Titolo principale dell'applicazione
            Text(
              AppConstants.appName, // Nome dell'app dalle costanti
              style: TextStyle(
                fontSize: 28, // Font grande per il titolo
                fontWeight: FontWeight.bold, // Testo in grassetto
                color: Colors.white, // Colore bianco
              ),
            ),
            // Spazio più piccolo tra titolo e sottotitolo
            SizedBox(height: AppConstants.spacingSmall),
            // Sottotitolo descrittivo
            Text(
              'La tua collezione di vinili', // Descrizione dell'app
              style: TextStyle(
                fontSize: 16, // Font più piccolo del titolo
                color: Colors.white70, // Bianco semi-trasparente
              ),
            ),
            // Spazio più grande prima dell'indicatore di caricamento
            SizedBox(height: AppConstants.spacingLarge),
            // Indicatore di caricamento circolare per mostrare l'attività
            CircularProgressIndicator(
              color: Colors.white, // Colore bianco per contrasto
            ),
          ],
        ),
      ),
    );
  }
}

// HomeScreen: schermata principale placeholder per la Fase 1
// Sarà completamente implementata nella Fase 2 con le funzionalità reali
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // build: costruisce l'interfaccia placeholder della home
  @override
  Widget build(BuildContext context) {
    // Scaffold con AppBar e contenuto centrato
    return Scaffold(
      // AppBar con il titolo dell'applicazione
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      // Body con messaggio di benvenuto centrato
      body: const Center(
        // Column per disporre i widget verticalmente
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icona del vinile più piccola rispetto alla splash
            Icon(
              Icons.album,
              size: 80, // Dimensione ridotta per la home
              color: AppConstants.primaryColor, // Colore primario
            ),
            // Spazio tra icona e testo
            SizedBox(height: AppConstants.spacingMedium),
            // Messaggio di benvenuto principale
            Text(
              'Benvenuto nella tua collezione!',
              style: TextStyle(
                fontSize: 20, // Font medio per il messaggio
                fontWeight: FontWeight.bold, // Testo in grassetto
              ),
            ),
            // Spazio più piccolo tra messaggio principale e nota
            SizedBox(height: AppConstants.spacingSmall),
            // Nota informativa sullo stato di sviluppo
            Text(
              'Le schermate saranno implementate nella Fase 2',
              style: TextStyle(
                fontSize: 16, // Font più piccolo per la nota
                color: Colors.grey, // Colore grigio per indicare info secondaria
              ),
            ),
          ],
        ),
      ),
    );
  }
}
