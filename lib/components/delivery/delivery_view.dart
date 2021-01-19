import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/components/delivery/delivery_view_model.dart';
import 'package:huen_delivery_mobile/exception/TokenException.dart';
import 'package:huen_delivery_mobile/models/delivery.dart';
import 'package:huen_delivery_mobile/notifiers/deliveries_notifier.dart';
import 'package:huen_delivery_mobile/styles/palette.dart';
import 'package:huen_delivery_mobile/util/dialog.dart';
import 'package:provider/provider.dart';

class DeliveryView extends StatefulWidget {
  final Delivery delivery;
  final Function moveCamera;

  DeliveryView({
    @required this.delivery,
    this.moveCamera,
  });

  @override
  State<StatefulWidget> createState() =>
      _DeliveryViewState(delivery, moveCamera);
}

class _DeliveryViewState extends State<DeliveryView> {
  Delivery delivery;
  Function moveCamera;

  DeliveryViewModel deliveryViewModel;

  _DeliveryViewState(this.delivery, this.moveCamera) {
    deliveryViewModel = new DeliveryViewModel();
    deliveryViewModel.setDelivery(delivery);
  }

  @override
  Widget build(BuildContext context) {
    DeliveriesNotifier deliveriesNotifier =
        Provider.of<DeliveriesNotifier>(context);

    generateStartButton() {
      return ButtonTheme(
        buttonColor: Palette.grayDCDCDC,
        minWidth: 60,
        height: 25,
        child: RaisedButton(
            child: Text(
              '출발',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              deliveryViewModel
                  .startDelivery()
                  .then((value) =>
                      deliveriesNotifier.updateDelivery(value.idx, value))
                  .catchError(
                (error) {
                  showCustomDialog(context, '세션 만료', '다시 로그인해주세요');
                },
                test: (e) => e is TokenException,
              ).catchError(
                (error) => showCustomDialog(context, '출발 실패', error.toString()),
                test: (e) => e is Exception,
              );
            }),
      );
    }

    generateEndButton() {
      return ButtonTheme(
        buttonColor: Palette.blue6685A8,
        minWidth: 60,
        height: 25,
        child: RaisedButton(
            child: Text(
              '도착',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            onPressed: () => {}),
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
                        deliveryViewModel.delivery.productName,
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
            delivery.startTime == null
                ? generateStartButton()
                : generateEndButton(),
          ],
        ),
      ),
    );
  }
}
