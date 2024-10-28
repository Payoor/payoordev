import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:chat/utils/_themecolors.dart';

import 'package:chat/classes/_storagemanager.dart';
import 'package:chat/classes/_url.dart';

class AttachmentOptions extends StatefulWidget {
  const AttachmentOptions({super.key});

  @override
  _AttachmentOptionsState createState() => _AttachmentOptionsState();
}

class _AttachmentOptionsState extends State<AttachmentOptions> {
  PlatformFile? _pickedFile;
  late StorageManager _storageManager;
  static final PayoorUrl payoorUrl = PayoorUrl();
  static final String payoorBaseUri = payoorUrl.getBaseUri();

  late html.VideoElement _videoElement;
  late html.CanvasElement _canvasElement;
  bool _isCameraActive = false;
  String? _capturedImageUrl;

  String? userJWT = "";

  @override
  void initState() {
    super.initState();
    getJWT();

    _videoElement = html.VideoElement()
      ..autoplay = true
      ..style.width = '100%'
      ..style.height = '100%';
    _canvasElement = html.CanvasElement(width: 640, height: 480);
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 1500,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 1200,
                  width: MediaQuery.of(context).size.width,
                  child: HtmlElementView(viewType: _videoElement.id),
                ),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> getJWT() async {
    _storageManager = await StorageManager.create();
    final String? jwt = await _storageManager.getJwt();

    setState(() {
      userJWT = jwt;
    });

    return jwt;
  }

  Future<void> activateCamera(BuildContext context) async {
    try {
      final stream = await html.window.navigator.mediaDevices?.getUserMedia({
        'video': true,
      });

      _videoElement.srcObject = stream;
      setState(() {
        _isCameraActive = true;
      });

      showBottomSheet(context);
    } catch (e) {
      print('Error accessing camera: $e');
    }
  }

  Future<void> pickAndUploadImage() async {
    if (kIsWeb) {
      try {
        final html.FileUploadInputElement input = html.FileUploadInputElement()
          ..accept = 'image/*';
        input.click();

        await input.onChange.first;
        if (input.files!.isEmpty) return;

        final file = input.files!.first;
        final reader = html.FileReader();
        reader.readAsDataUrl(file);

        await reader.onLoad.first;
        final encoded = reader.result as String;
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        final url = Uri.parse(
            '$payoorBaseUri/upload'); // Replace with your actual API URL
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $userJWT', // Replace with actual JWT token
          },
          body: json.encode({
            'image': stripped,
            'filename': file.name,
          }),
        );

        if (response.statusCode == 200) {
          print('Image uploaded successfully');
          // Update your state here, e.g., display the uploaded image
        } else {
          print('Failed to upload image: ${response.statusCode}');
        }
      } catch (e) {
        print('Error picking or uploading image: $e');
      }
    } else {
      print('This function is intended for web use only.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              activateCamera(context);
              setState(() {
                // Update state variables as needed
              });
            },
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 20.0,
              color: ThemeColors.primaryColor,
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              pickAndUploadImage();
              // Handle photo tap here, potentially updating state
              setState(() {
                // Update state variables as needed
              });
            },
            child: const Icon(
              Icons.photo_outlined,
              size: 20.0,
              color: ThemeColors.primaryColor,
            ),
          ),
          const SizedBox(width: 20),
          /*GestureDetector(
            onTap: () {
              // Handle file tap here, potentially updating state
              setState(() {
                // Update state variables as needed
              });
            },
            child: const Icon(
              Icons.insert_drive_file_outlined,
              size: 20.0,
              color: ThemeColors.primaryColor,
            ),
          ),
          const SizedBox(width: 10),*/
        ],
      ),
    );
  }
}
