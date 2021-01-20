import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/components/delivery/delivery_view_model.dart';
import 'package:huen_delivery_mobile/exception/TokenException.dart';
import 'package:huen_delivery_mobile/models/delivery.dart';
import 'package:huen_delivery_mobile/notifiers/deliveries_notifier.dart';
import 'package:huen_delivery_mobile/notifiers/end_delivery_notifier.dart';
import 'package:huen_delivery_mobile/styles/palette.dart';
import 'package:huen_delivery_mobile/util/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DeliveryView extends StatefulWidget {
  final Delivery delivery;
  final Function moveCamera;
  final Key key;

  DeliveryView({
    @required this.delivery,
    @required this.key,
    this.moveCamera,
  });

  @override
  State<StatefulWidget> createState() =>
      _DeliveryViewState(delivery, moveCamera);
}

class _DeliveryViewState extends State<DeliveryView> {
  Delivery delivery;
  Function moveCamera;
  File _image;

  DeliveryViewModel deliveryViewModel;

  _DeliveryViewState(this.delivery, this.moveCamera) {
    deliveryViewModel = new DeliveryViewModel();
    deliveryViewModel.setDelivery(delivery);
  }

  @override
  Widget build(BuildContext context) {
    EndDeliveryNotifier endDeliveryNotifier =
        Provider.of<EndDeliveryNotifier>(context);

    DeliveriesNotifier deliveriesNotifier =
        Provider.of<DeliveriesNotifier>(context);

    generateEndButton() {
      return ButtonTheme(
        buttonColor: Palette.blue6685A8,
        minWidth: 60,
        height: 25,
        child: RaisedButton(
            child: Text(
              '배송 완료',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              endDeliveryNotifier.setDelivery(deliveryViewModel.delivery);
              await getImage();
              if (_image != null) {
                try {
                  endDeliveryNotifier.setImage(_image);
                  await endDeliveryNotifier.endDelivery();
                  deliveriesNotifier.removeDelivery(deliveryViewModel.delivery);
                } catch (err) {
                  if (err is TokenException) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (router) => false);
                    showCustomDialog(context, '세션 만료', '다시 로그인해주세요');
                  } else {
                    showCustomDialog(context, '배송 완료 실패', err.toString());
                  }
                }
              }
            }),
      );
    }

    return GestureDetector(
      onTap: () {
        moveCamera(deliveryViewModel.delivery.idx);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Palette.grayDCDCDC,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        deliveryViewModel.delivery.productName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Palette.gray141414,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        deliveryViewModel.delivery.customer.id,
                        style: TextStyle(
                          fontSize: 11,
                          color: Palette.gray444444,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    deliveryViewModel.delivery.customer.address,
                    style: TextStyle(
                      fontSize: 10,
                      color: Palette.gray444444,
                    ),
                  ),
                ],
              ),
            ),
            generateEndButton(),
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
}
