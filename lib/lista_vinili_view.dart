import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinyl_collection_app_gruppo_16/utils/constants.dart';
import '../services/vinyl_provider.dart';
import 'screens/add_edit_vinyl_screen.dart'; 
import 'dart:io';


class ListaViniliView extends StatefulWidget {
  const ListaViniliView({super.key});

  @override
  State<ListaViniliView> createState() => _ListaViniliViewState();
}


class _ListaViniliViewState extends State<ListaViniliView> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('I Tuoi Vinili'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Consumer<VinylProvider>(
        builder: (context, provider, child) {
          final userVinyls = provider.recentVinyls;
          if (userVinyls.isEmpty) {
            return const Center(
              child: Text('Nessun vinile aggiunto.'),
            );
          }
          return ListView.builder(
            itemCount: userVinyls.length,
            itemBuilder: (context, index) {
              final vinyl = userVinyls[index];
              return GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    '/dettaglio_vinile',
                    arguments: vinyl,
                  );
                },
                child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: vinyl.imagePath != null
                                ? Image.file(
                                    File(vinyl.imagePath!),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    color: AppConstants.primaryColor
                                        .withOpacity(0.1),
                                    child: Icon(Icons.album,
                                        color: AppConstants.primaryColor
                                            .withOpacity(0.5)),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vinyl.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Artista: ${vinyl.artist}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Anno: ${vinyl.year}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.star_border),
                            onPressed: () {
                              print('Star tapped for ${vinyl.title}');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // NAVIGATION
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditVinylScreen(),
            ),
          );

         
          if (result == true && mounted) {
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Vinile aggiunto alla collezione!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        backgroundColor: AppConstants.primaryColor,
        tooltip: 'Aggiungi nuovo vinile',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}