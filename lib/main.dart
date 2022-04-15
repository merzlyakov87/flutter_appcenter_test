import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hive_test/file_model.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const secureStorage = FlutterSecureStorage();
  final encryprionKey = await secureStorage.read(key: 'key');
  if (encryprionKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'key',
      value: base64UrlEncode(key),
    );
  }
  Hive.initFlutter();

  Hive.registerAdapter(FileModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Hive Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? image;
  TextEditingController controller = TextEditingController();
  late LazyBox<FileModel> files;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                  final key =
                      await const FlutterSecureStorage().read(key: 'key');
                  final encryptionKey = base64Url.decode(key!);
                  final byteData = await rootBundle.load('images/image.jpg');

                  final startDate = DateTime.now();
                  files = await Hive.openLazyBox<FileModel>('files',
                      encryptionCipher: HiveAesCipher(encryptionKey));
                  files.clear;
                  setState(() {
                    loading = true;
                  });
                  for (var i = 1; i < 1000; i++) {
                    await files.put(
                        i,
                        FileModel(
                            'image$i.jpg', byteData.buffer.asUint8List()));
                  }
                  setState(() {
                    loading = false;
                  });
                  await files.flush();
                  await files.close();

                  final endDate = DateTime.now();

                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                            child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Column(
                            children: [
                              Text(
                                  'Box writed, duration = ${endDate.difference(startDate).inMilliseconds} ms')
                            ],
                          ),
                        ));
                      });
                },
                child: const Text('Save 1000 images to HIVE')),
            loading
                ? const CircularProgressIndicator()
                : const SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 30,
                  child: TextField(
                    controller: controller,
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      final key =
                          await const FlutterSecureStorage().read(key: 'key');
                      final encryptionKey = base64Url.decode(key!);
                      final index = int.tryParse(controller.value.text);
                      if (index != null) {
                        setState(() {
                          loading = true;
                        });
                        final startDate = DateTime.now();
                        files = await Hive.openLazyBox<FileModel>('files',
                            encryptionCipher: HiveAesCipher(encryptionKey));

                        final fileModel = await files.get(index);
                        final endDate = DateTime.now();
                        setState(() {
                          loading = false;
                        });

                        if (fileModel != null) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    child: SizedBox(
                                  width: 400,
                                  height: 500,
                                  child: Column(
                                    children: [
                                      Image.memory(
                                        fileModel.file,
                                        width: 300,
                                        height: 300,
                                      ),
                                      Text(
                                          'Box readed, duration = ${endDate.difference(startDate).inMilliseconds} ms, filename = ${fileModel.fileName}')
                                    ],
                                  ),
                                ));
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    child: SizedBox(
                                  width: 400,
                                  height: 500,
                                  child: Column(
                                    children: [
                                      Text(
                                          'Box readed, duration = ${endDate.difference(startDate).inMilliseconds} ms, item not found')
                                    ],
                                  ),
                                ));
                              });
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const Dialog(
                                  child: SizedBox(
                                width: 400,
                                height: 500,
                                child: Center(child: Text('Enter Id')),
                              ));
                            });
                      }
                    },
                    child: const Text('Read from HIVE')),
              ],
            ),
            TextButton(
                onPressed: () async {
                  final key =
                      await const FlutterSecureStorage().read(key: 'key');
                  final encryptionKey = base64Url.decode(key!);
                  final byteData = await rootBundle.load('images/image.jpg');
                  final startDate = DateTime.now();
                  files = await Hive.openLazyBox<FileModel>('files',
                      encryptionCipher: HiveAesCipher(encryptionKey));

                  final index = int.tryParse(controller.value.text);
                  if (index != null) {
                    await files.put(
                        index,
                        FileModel(
                            'image$index.jpg', byteData.buffer.asUint8List()));

                    final endDate = DateTime.now();

                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                              child: SizedBox(
                            width: 400,
                            height: 500,
                            child: Center(
                              child: Text(
                                  'Box write 1 record, duration = ${endDate.difference(startDate).inMilliseconds} ms'),
                            ),
                          ));
                        });
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                              child: SizedBox(
                            width: 400,
                            height: 500,
                            child: Column(
                              children: const [Text('Enter Id')],
                            ),
                          ));
                        });
                  }
                },
                child: const Text('Write 1 record'))
          ],
        ),
      ),
    );
  }
}
