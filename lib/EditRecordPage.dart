import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Constant.dart';
import 'ImageDetailPage.dart';
import 'main.dart';

class EditRecordPage extends StatefulWidget {
  final int index;
  final Record initialRecord;
  final Function(int, Record) editRecord;

  const EditRecordPage({
    super.key,
    required this.index,
    required this.initialRecord,
    required this.editRecord,
  });

  @override
  _EditRecordPageState createState() => _EditRecordPageState();
}

class _EditRecordPageState extends State<EditRecordPage> {
  TextEditingController plateController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  List<File> images = [];
  String formattedDate =
      "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}";

  @override
  void initState() {
    super.initState();
    plateController.text = widget.initialRecord.plate;
    productController.text = widget.initialRecord.product;
    weightController.text = widget.initialRecord.weight.toString();
    images.addAll(widget.initialRecord.images);
  }

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        images.add(File(imageFile.path));
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _editRecord() async {
    if (plateController.text.isEmpty ||
        productController.text.isEmpty ||
        weightController.text.isEmpty) {
      showSnackbar(context, Constant().errorEmptyMessage, Colors.red);
    } else {
      Record editedRecord = Record(
        plate: plateController.text,
        product: productController.text,
        weight: double.parse(weightController.text),
        date: formattedDate,
        images: List.from(images),
      );
      widget.editRecord(widget.index, editedRecord);
      Navigator.pop(context);
    }
  }

  void showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(Constant().editRecord),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: plateController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(labelText: Constant().plateText),
            ),
            TextField(
              controller: productController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(labelText: Constant().productText),
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: Constant().weightText),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Text(Constant().pickGalleryImage),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _takePicture,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Text(Constant().pickImage),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: width,
              height: height / 15,
              child: ElevatedButton(
                onPressed: _editRecord,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: Text(Constant().saveRecord),
              ),
            ),
            const SizedBox(height: 20),
            ImageList(images: images),
          ],
        ),
      ),
    );
  }
}
