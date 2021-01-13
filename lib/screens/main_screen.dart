import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    Size deviceSize = MediaQuery.of(context).size;
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
                Container(
                  height: deviceSize.height * 0.6,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(35.82765238011889, 128.61770061419432),
                        zoom: 16.0),
                  ),
                ),
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
