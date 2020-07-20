import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File imageFile;
  Future<String> future;

  // Change this var value to current url.
  String url = "http://192.168.43.16:8080/api/upload/5f0d22f5f41c643ac4908eb5/5f0d22f5f41c643ac4908eb6";
  //  Change this var value to current url.
// camera 0 http://192.168.43.16:8080/api/upload/5f0d22f5f41c643ac4908eb5/5f0d22f5f41c643ac4908eb6
// camera 1 http://192.168.43.16:8080/api/upload/5f0d22f5f41c643ac4908eb5/5f0d22f5f41c643ac4908eb7
  @override
  Widget build(BuildContext context) {

    Future<String> _upload(File image, String url) async {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath('image', image.path,
            filename: basename(image.path)),
      );
      var response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print(responseBody);
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          child: new AlertDialog(
            title: Text("Number of Persons"),
            content: Text(responseBody),
          ),
        );
      });
      return responseBody;
    }

    Future getImage(ImageSource source) async {
      final pickedFile = await ImagePicker()
          .getImage(source: source, maxHeight: 300, maxWidth: 300);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          future = _upload(imageFile, url);
        });
      }
    }

    // ignore: missing_return
    Future _imageChoiceDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("From where do you want to take the photo?"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      InkWell(
                        child: Text("Gallery"),
                        onTap: () {
                          imageFile = null; 
                          future = null;
                          getImage(ImageSource.gallery);
                          Navigator.pop(context);
                        },
                      ),
                      Padding(padding: EdgeInsets.all(12.0)),
                      InkWell(
                        child: Text("Camera"),
                        onTap: () {
                          imageFile = null; 
                          future = null;
                          getImage(ImageSource.camera);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ));
          });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _imageChoiceDialog,
        child: Icon(Icons.add_a_photo),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(
          top: 300,
        ),
        child: Column(
          children: <Widget>[
            imageFile == null ? Text('Choose Image') : Image.file(imageFile),
            SizedBox(
              height: 50,
            ),
            if (imageFile == null || future == null)
              Text('')
            else
              FutureBuilder(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return Text("");
                    } else if (snapshot.hasError) {
                      return Text("Try Again!");
                    } else if (snapshot.hasData) {
                      return Text("Uploaded Success...!");
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