import 'dart:io';

import 'package:flutter/material.dart';

import 'Homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}

class Record {
  final String plate;
  final String product;
  final double weight;
  final String date;

  final List<File> images;

  Record({
    required this.plate,
    required this.product,
    required this.weight,
    required this.date,
    required this.images,
  });

  @override
  String toString() {
    return '$plate - $product - $weight - $date';
  }

  Map<String, dynamic> toJson() {
    return {
      'plate': plate,
      'product': product,
      'weight': weight,
      'date': date,
      'images': images.map((image) => image.path).toList(),
    };
  }

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      plate: json['plate'],
      product: json['product'],
      weight: json['weight'],
      date: json['date'],
      images:
          (json['images'] as List<dynamic>).map((path) => File(path)).toList(),
    );
  }
}
