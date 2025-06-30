import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'Canzone.dart';
import 'Vinile.dart';

class ViewDisco extends StatelessWidget {
  final Vinile vinile;
  const ViewDisco({super.key, required this.vinile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ensure column only takes necessary space
        children: [
          SizedBox(
            width: 200.0,
            height: 200.0,
            child: Image.network(
              'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
              fit: BoxFit.cover, // Cover the box while maintaining aspect ratio
            ),
          ),
          //const SizedBox(height: 8.0),
          Text(
            vinile.titolo, // Use actual data from vinile
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4.0),
          Text(
            vinile.artista, // Use actual data from vinile
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}


abstract class ListItem {
  Widget buildTopPart(BuildContext context);
  Widget buildBottomPart(BuildContext context);
}

class CanzoniItem implements ListItem {
  final Canzone canzone;
  CanzoniItem(this.canzone);

  @override
  Widget buildTopPart(BuildContext context) => Text(canzone.titolo);

  @override
  Widget buildBottomPart(BuildContext context) =>
      Text('Artista: ${canzone.artista} \nAnno: ${canzone.anno}');
}

void main() {
  final List<Canzone> canzoni = [
    Canzone('Bohemian Rhapsody', 'Queen', '1975'),
    Canzone('Imagine', 'John Lennon', '1971'),
    Canzone('Smells Like Teen Spirit', 'Nirvana', '1991'),
    Canzone('Billie Jean', 'Michael Jackson', '1982'),
    Canzone('Hotel California', 'Eagles', '1976'),
    Canzone('Like a Rolling Stone', 'Bob Dylan', '1965'),
    Canzone('Hey Jude', 'The Beatles', '1968'),
    Canzone('Rolling in the Deep', 'Adele', '2010'),
  ];

  final vin = Vinile(
    'The Dark Side of the Moon',
    'Pink Floyd',
    '1973',
    'Harvest Records',
    GenereMusicale.rock,
    Uint8List.fromList([0, 1, 2, 3, 4, 5]),
    8,
  );

  runApp(
    SchermataDettaglio(
      items: List<ListItem>.generate(
        canzoni.length,
        (i) => CanzoniItem(canzoni[i % canzoni.length]),
      ),
      vinile: vin,
    ),
  );
}

class SchermataDettaglio extends StatelessWidget {
  final List<ListItem> items;
  final Vinile vinile;
  const SchermataDettaglio({super.key, required this.items, required this.vinile});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dettaglio Vinile',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dettaglio Vinile'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ViewDisco(vinile: vinile),
            Expanded(
              // Expanded ensures ListView.builder gets a bounded height
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final ListItem item = items[index];

                  return ListTile(
                    leading: Icon(Icons.music_note),
                    title: item.buildTopPart(context),
                    subtitle: item.buildBottomPart(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
