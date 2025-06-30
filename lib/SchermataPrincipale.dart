import 'package:flutter/material.dart';
import 'homeView.dart';
import 'searchView.dart';
import 'analisiView.dart';

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
          '/searchView': (context) => const searchView(),
          '/detailsView': (context) => const detailsView(),
          '/homeView': (context) => const homeView(),
        },
        home: Scaffold(
            body: IndexedStack(
              index: realIndex,
              children: const [
                homeView(),
                searchView(),
                detailsView(),
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