import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_tesing/home_page.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.purple[50],
        primaryColor: Colors.purple.shade400,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  // controller for textfield
  final TextEditingController _urlController = TextEditingController(text: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4');

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
          ],
        ),
      ),
    );
  }
}
