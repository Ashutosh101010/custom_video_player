import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

class FileEncryptor {
  static void encryptFile(File inputFile, File outputFile, String key) {
    final keyBytes = utf8.encode(key);
    final keyDigest = sha256.convert(keyBytes);

    final inputBytes = inputFile.readAsBytesSync();
    final encryptedBytes = xorEncrypt(inputBytes, keyDigest.bytes);

    outputFile.writeAsBytesSync(encryptedBytes);
  }

  static void decryptFile(File inputFile, File outputFile, String key) {
    try {
      final keyBytes = utf8.encode(key);
      print(keyBytes);
      final keyDigest = sha256.convert(keyBytes);
      print(keyDigest.bytes);
      final inputBytes = inputFile.readAsBytesSync();
      final decryptedBytes = xorDecrypt(inputBytes, keyDigest.bytes);

      outputFile.writeAsBytesSync(decryptedBytes);
    } catch (e) {
      print('error in decrypting file $e');
    }
  }

  static List<int> xorEncrypt(List<int> inputBytes, List<int> keyBytes) {
    final result = List<int>.filled(inputBytes.length, 0);
    for (var i = 0; i < inputBytes.length; i++) {
      result[i] = inputBytes[i] ^ keyBytes[i % keyBytes.length];
    }
    return result;
  }

  static List<int> xorDecrypt(List<int> inputBytes, List<int> keyBytes) {
    final result = List<int>.filled(inputBytes.length, 0);
    for (var i = 0; i < inputBytes.length; i++) {
      result[i] = inputBytes[i] ^ keyBytes[i % keyBytes.length];
    }
    return result;
  }
}

class VideoEncypt extends StatefulWidget {
  final String url;
  const VideoEncypt({super.key, required this.url});

  @override
  State<VideoEncypt> createState() => _VideoEncyptState();
}

class _VideoEncyptState extends State<VideoEncypt> {
  void downloadFile() async {
    try {
      final inFile = File('C:/Users/krish/Desktop/Softkites/video_encrypter/src/OutVideo.mp4');

      final outFile = File('C:/Users/krish/Desktop/Softkites/video_encrypter/src/dec_OutVideo.mp4');

      bool outFileExists = await outFile.exists();

      if (!outFileExists) {
        await outFile.create();
      }

      final videoFileContents = inFile.readAsBytesSync();

      final key = encrypt.Key.fromBase64('Ym4XMkb8YGlaEvyEdikYOzEWPwP2Wwuz/UPmKrvbMi8=');
      // final iv = encrypt.IV.fromLength(16);

      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb, padding: 'PKCS7'));

      final encryptedFile = encrypt.Encrypted(videoFileContents);
      final decrypted = encrypter.decryptBytes(encryptedFile);

      // final decryptedBytes = latin1.encode(decrypted);
      outFile.writeAsBytesSync(decrypted, mode: FileMode.append);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                downloadFile();
              },
              child: const Text('Download'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
