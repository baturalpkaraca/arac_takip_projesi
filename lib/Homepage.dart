import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddRecordPage.dart';
import 'Constant.dart';
import 'EditRecordPage.dart';
import 'ImageDetailPage.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Record> records = [];

  @override
  void initState() {
    super.initState();
    // Uygulama başladığında kaydedilmiş kayıtları yükle
    loadRecords();
  }

  Future<void> loadRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? recordsJsonList = prefs.getStringList('records');

    if (recordsJsonList != null) {
      setState(() {
        // Kaydedilmiş kayıtları JSON formatından çevirerek yükle
        records = recordsJsonList
            .map((json) => Record.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }

  Future<void> saveRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Kayıtları JSON formatına çevirerek kaydet
    List<String> recordsJsonList =
        records.map((record) => jsonEncode(record.toJson())).toList();
    prefs.setStringList('records', recordsJsonList);
  }

  void addRecord(Record record) {
    setState(() {
      records.add(record);
    });
    // Yeni kayıt eklenirken kaydet
    saveRecords();
  }

  void editRecord(int index, Record newRecord) {
    setState(() {
      records[index] = newRecord;
    });
    // Kayıt düzenlendiğinde kaydet
    saveRecords();
  }

  void deleteRecord(int index) {
    setState(() {
      records.removeAt(index);
    });
    // Kayıt silindiğinde kaydet
    saveRecords();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(Constant().homeScreenText),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: Constant().settingsText,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${Constant().plate}: ${records[index].plate}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${Constant().productText}: ${records[index].product}'),
                        Text(
                            '${Constant().weightText}: ${records[index].weight} Kg.'),
                        Text('${Constant().date}: ${records[index].date}'),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageDetailPage(
                                  images: records[index].images,
                                ),
                              ),
                            );
                          },
                          child: ImageList(images: records[index].images),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditRecordPage(
                                  index: index,
                                  initialRecord: records[index],
                                  editRecord: editRecord,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(Constant().deleteRecord),
                                  content: Text(Constant().deleteRecordText),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(Constant().cancel),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteRecord(index);
                                        Navigator.pop(context);
                                      },
                                      child: Text(Constant().delete),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text('${Constant().totalWeight}: '),
            const SizedBox(height: 20),
            SizedBox(
              width: width,
              height: height / 15,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddRecordPage(addRecord),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: Text(Constant().addNewRecord),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
