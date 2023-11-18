
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_tesing/encrypter.dart';
import 'package:video_tesing/home_page.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  Home({super.key});

  // controller for textfield
  final TextEditingController _urlController = TextEditingController(text: 'https://s3.ap-southeast-1.wasabisys.com/classio/krishnapal/OutVideo.mp4');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter your Url',
                labelStyle: TextStyle(
                  color: Colors.purple.shade400,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Icon(
                  Icons.video_file_rounded,
                  color: Colors.purple.shade400,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.purple.shade400,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.purple.shade400,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(url: _urlController.text)),
                  );
                },
                child: const Text('Go to HomePage'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                focusNode: FocusNode(),
                onPressed: () async {
                  var status = await Permission.videos.status;
                  print(status.toString());
                  if (!status.isGranted) {
                    await Permission.videos.request();
                  } else {
                    //pick file
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['mp4', 'mkv', 'avi'],
                    );
                    print(result);
                    if (result != null) {
                      Get.to(() => HomePage(url: result.files.single.path!));
                    } else {}
                  }
                },
                child: const Text('Take File'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                focusNode: FocusNode(),
                onPressed: () async {
                  Get.to(() => VideoEncypt(url: _urlController.text));
                },
                child: const Text('Go To Video Encryption'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
