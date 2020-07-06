import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File imageFile;
  List<String> results = new List<String>();
  Future<String> future;
  String finalRes = ''' ''';

  @override
  Widget build(BuildContext context) {
    Future<String> _upload(File image, String url) async {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('image', image.path,
            contentType: MediaType('application', 'jpeg'),
            filename: basename(image.path)),
      );
      var response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print(responseBody);

      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          child: new AlertDialog(
            title: Text("results"),
            content: Text(finalRes == "" || finalRes == null
                ? "Can’t reconize object, try again!"
                : responseBody),
          ),
        );
      });
      return responseBody;
    }

    Future getImage() async {
      final pickedFile = await ImagePicker()
          .getImage(source: ImageSource.camera, maxHeight: 300, maxWidth: 300);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          future = _upload(imageFile, "192.168.43.59");
        });
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          children: <Widget>[
            imageFile == null ? Text('not found') : Image.file(imageFile),
            if (imageFile == null || future == null)
              Text('Pick an image')
            else
              FutureBuilder(
                  future: future,
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return Text("");
                    } else if (snapshot.hasError) {
                      return Text("error");
                    } else if (snapshot.hasData) {
                      return Text("$snapshot.data");
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
          ],
        ),
      )),
    );
  }
}
