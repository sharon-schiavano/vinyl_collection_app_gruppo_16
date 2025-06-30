import 'package:flutter/material.dart';
import 'dart:typed_data';

enum GenereMusicale {
  rock,
  pop,
  jazz,
  hipHop,
  electronic,
  classical,
  blues,
  country,
  reggae,
  metal,
  rnb,
  folk,
  world,
  soundtrack,
  other,
}

class Vinile {
  String titolo;
  String artista;
  String anno;
  String etichetta;
  GenereMusicale genere;
  Uint8List immagineCopertina;
  int numeroCanzoni;

  Vinile(
    this.titolo,
    this.artista,
    this.anno,
    this.etichetta,
    this.genere,
    this.immagineCopertina,
    this.numeroCanzoni,
  );
}
