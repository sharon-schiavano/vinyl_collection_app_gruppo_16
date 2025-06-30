import 'package:flutter/material.dart';
import 'home_view.dart';
import 'search_view.dart';
import 'analisi_view.dart';

void main(){
  runApp(const SchermataP());
}

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
      return MaterialApp(
        title: 'app name !!',
        initialRoute: '/',
        routes: {
          '/searchView': (context) => const SearchView(),
          '/detailsView': (context) => const DetailsView(),
          '/homeView': (context) => const HomeView(),
        },
        home: Scaffold(
            body: IndexedStack(
              index: realIndex,
              children: const [
                HomeView(),
                SearchView(),
                DetailsView(),
              ]),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: realIndex,
              onTap: onSelection,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Colors.blue,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'search',
                  backgroundColor: Colors.blue,  
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Dettagli',
                  backgroundColor: Colors.blue,
                )
              ]
            )),
            );
      }
}