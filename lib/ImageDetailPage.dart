import 'dart:io';

import 'package:flutter/material.dart';

import 'Constant.dart';

class ImageDetailPage extends StatelessWidget {
  final List<File> images;

  const ImageDetailPage({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constant().photoDetail),
      ),
      body: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Center(
            child: Image.file(images[index]),
          );
        },
      ),
    );
  }
}

class ImageList extends StatelessWidget {
  final List<File> images;

  const ImageList({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.file(
              images[index],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
