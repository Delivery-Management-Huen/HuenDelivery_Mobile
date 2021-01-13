import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/components/delivery/delivery_view.dart';
import 'package:huen_delivery_mobile/models/Delivery.dart';
import 'package:huen_delivery_mobile/notifiers/deliveries_notifier.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    DeliveriesNotifier deliveriesNotifier = Provider.of<DeliveriesNotifier>(
        context);

    return Scaffold(
      body: Column(
        children: [
          RaisedButton(onPressed: () => deliveriesNotifier.addDelivery(Delivery())),
          Expanded(
            child: ListView.builder(
                itemCount: deliveriesNotifier
                    .getDeliveries()
                    .length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) =>
                    DeliveryView(
                        delivery: deliveriesNotifier.getDeliveries()[index]),
            ),
          ),
        ],
      ),
    );
  }
}
