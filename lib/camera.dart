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
  Future<List<String>> future;
  String finalRes = ''' ''';

  @override
  Widget build(BuildContext context) {
    Future<List<String>> _upload(File image, String url) async {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('file', image.path,
            contentType: MediaType('application', 'jpeg'),
            filename: basename(image.path)),
      );
      var response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print(responseBody);
      var castBody = json.decode(responseBody)['body'];
      var castName = json.decode(castBody);
      for (Map<String, dynamic> element in castName) {
        results.add(element["Name"]);
      }
      for (var i = 0; i < results.length; i++) {
        finalRes += results[i] + "\n";
      }
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          child: new AlertDialog(
            title: Text("results"),
            content: Text(finalRes == "" || finalRes == null
                ? "Can’t reconize object, try again!"
                : finalRes),
          ),
        );
      });
      return results;
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
              Text('Pick an image to recognize it')
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
                      finalRes = "";
                      for (var i = 0; i < results.length; i++) {
                        finalRes += results[i] + "\n";
                      }
                      if (finalRes == "") {
                        return Text("Can’t reconize object, try again!");
                      }
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
