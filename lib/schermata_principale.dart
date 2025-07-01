import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_view.dart';
import 'search_view.dart';
import 'analisi_view.dart';
import 'services/vinyl_provider.dart';
import 'utils/constants.dart';

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
          '/searchView': (context) => const SearchView(),
          '/detailsView': (context) => const DetailsView(),
          '/homeView': (context) => const HomeView(),
        },
        home: Scaffold(
          body: IndexedStack(
            index: realIndex,
            children: const [HomeView(), SearchView(), DetailsView()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: realIndex,
            onTap: onSelection,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppConstants.primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Ricerca',
              ),
              BottomNavigationBarItem(
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
