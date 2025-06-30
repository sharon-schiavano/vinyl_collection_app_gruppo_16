import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nome App <3",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    letterSpacing: 2,
                  ),
                ),
                Icon(Icons.account_circle)
              ]
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lista vinili recenti aggiunti dall'utente",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    letterSpacing: 2,
                  ),
                ),
                Icon(Icons.arrow_forward_ios)
              ]
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal, 
                itemCount: 10, // numero di vinili da mostrare, useremo list.length
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemBuilder: (context, index) => Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                  ),
                  child: Center(
                    child: Text(
                      'Vinile ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lista vinili consigliati casualmente",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal, 
                itemCount: 10, // numero di vinili da mostrare, useremo list.length
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemBuilder: (context, index) => Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                  ),
                  child: Center(
                    child: Text(
                      'Vinile ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() => Navigator.pushNamed(context, '/searchView'), //per ora! deve portare all'aggiungi elemento
        child: Icon(Icons.add),
      )
    );
  }
}