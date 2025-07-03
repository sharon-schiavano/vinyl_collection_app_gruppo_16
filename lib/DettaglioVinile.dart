import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'models/Song.dart';
import 'models/category.dart';
import 'models/vinyl.dart';

class ViewDisco extends StatelessWidget {
  final Vinyl vinile;
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
             vinile.imagePath ?? 'https://via.placeholder.com/200', // Fallback image if null
              fit: BoxFit.cover, // Cover the box while maintaining aspect ratio
            ),
          ),
          //const SizedBox(height: 8.0),
          Text(
            vinile.title, // Use actual data from vinile
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4.0),
          Text(
            vinile.artist, // Use actual data from vinile
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
  final Song canzone;
  CanzoniItem(this.canzone);

  @override
  Widget buildTopPart(BuildContext context) => Text(canzone.titolo);

  @override
  Widget buildBottomPart(BuildContext context) =>
      Text('Artista: ${canzone.artista} \nAnno: ${canzone.anno}');
}

void main() {
  final List<Song> canzoni = [
    Song('Bohemian Rhapsody', 'Queen', '1975'),
    Song('Imagine', 'John Lennon', '1971'),
    Song('Smells Like Teen Spirit', 'Nirvana', '1991'),
    Song('Billie Jean', 'Michael Jackson', '1982'),
    Song('Hotel California', 'Eagles', '1976'),
    Song('Like a Rolling Stone', 'Bob Dylan', '1965'),
    Song('Hey Jude', 'The Beatles', '1968'),
    Song('Rolling in the Deep', 'Adele', '2010'),
  ];

  final vin = Vinyl(
    title:'The Dark Side of the Moon',
    artist: 'Pink Floyd',
    year: 1973,
    label: 'Harvest Records',
    imagePath: "https://m.media-amazon.com/images/I/610RGJlG1ZL._UF1000,1000_QL80_.jpg",
    song: canzoni,
    genre: 'Progressive Rock', // Add a suitable genre
    condition: 'Excellent',    // Add a suitable condition
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
  final Vinyl vinile;
  const SchermataDettaglio({super.key, required this.items, required this.vinile});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dettaglio Vinile',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton( 
            icon: Icon(Icons.arrow_back),
            onPressed:(){
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
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
