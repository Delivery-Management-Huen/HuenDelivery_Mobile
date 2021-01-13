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
  void initState() {
    DeliveriesNotifier deliveriesNotifier =
        Provider.of<DeliveriesNotifier>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      deliveriesNotifier.fetchDeliveries();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DeliveriesNotifier deliveriesNotifier =
        Provider.of<DeliveriesNotifier>(context);

    List<Delivery> deliveries = deliveriesNotifier.getDeliveries();

    return Scaffold(
      body: deliveriesNotifier == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                RaisedButton(
                    onPressed: () =>
                        deliveriesNotifier.addDelivery(Delivery())),
                Expanded(
                  child: ListView.builder(
                    itemCount: deliveries.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) =>
                        DeliveryView(delivery: deliveries[index]),
                  ),
                ),
              ],
            ),
    );
  }
}
