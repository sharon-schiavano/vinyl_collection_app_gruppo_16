import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_view.dart';
import 'search_view.dart';
import 'analisi_view.dart';
import 'services/vinyl_provider.dart';
import 'utils/constants.dart';
import 'DettaglioVinile.dart';
import 'models/vinyl.dart';
import 'listaVinili_view.dart';
import 'profile_view.dart';

class SchermataP extends StatefulWidget {
  const SchermataP({super.key});

  @override
  State<SchermataP> createState() => _SchermataPState();
}

class _SchermataPState extends State<SchermataP> {
  int realIndex = 0;

  void onSelection(int index) {
    setState(() => realIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VinylProvider()..initialize(),
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: AppConstants.primaryColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/search_View': (context) => const SearchView(),
          'analisi_view': (context) => const AnalisiView(),
          '/home_view': (context) => const HomeView(),
          '/profile_view': (context) => const ProfileView(),
          '/listaVinili_view': (context) => const ListaViniliView(),
          '/DettaglioVinile': (context) {
            final vinyl = ModalRoute.of(context)!.settings.arguments as Vinyl;
            return SchermataDettaglio(
              vinile: vinyl,
              items: [], // Pass the list of songs if you have them, or leave empty
            );
            },
        },
        home: Scaffold(
          body: IndexedStack(
            index: realIndex,
            children: const [HomeView(), SearchView(), AnalisiView()],
          ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: realIndex,
                onDestinationSelected: onSelection,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.search),
                    label: 'Ricerca',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.analytics),
                    label: 'Analisi',
                  ),
                ],
              ),
            ),
        ),
      );
  }
}
