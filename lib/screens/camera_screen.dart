import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File _image;

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      getImage();
    }

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            showImage(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => getImage(),
                    child: Text('다시 찍기'),
                  ),
                  ElevatedButton(
                    onPressed: () => getImage(),
                    child: Text('배송 완료'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    final image = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  Widget showImage() {
    if (_image == null) {
      return Container();
    } else {
      return Image.file(_image);
    }
  }
}
