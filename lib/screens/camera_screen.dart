import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/notifiers/deliveries_notifier.dart';
import 'package:huen_delivery_mobile/notifiers/end_delivery_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CameraScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: EndDeliveryNotifier()),
        ChangeNotifierProvider.value(value: DeliveriesNotifier()),
      ],
      child: CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File _image;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    EndDeliveryNotifier endDeliveryNotifier =
        Provider.of<EndDeliveryNotifier>(context);

    if (_image == null) {
      getImage();
    }

    return Scaffold(
      body: _image == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: [
                  showImage(deviceSize.width, deviceSize.height * 0.8),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => getImage(),
                          child: Text('다시 찍기'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            endDeliveryNotifier.setImage(_image);
                            endDeliveryNotifier.endDelivery();
                          },
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

  Widget showImage(width, height) {
    if (_image == null) {
      return SizedBox(
        width: width,
        height: height,
      );
    } else {
      return Container(
        width: width,
        height: height,
        child: Image.file(_image),
      );
    }
  }
}
