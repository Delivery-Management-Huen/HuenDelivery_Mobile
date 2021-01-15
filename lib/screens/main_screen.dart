import 'dart:async';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huen_delivery_mobile/components/delivery/delivery_view.dart';
import 'package:huen_delivery_mobile/models/delivery.dart';
import 'package:huen_delivery_mobile/notifiers/deliveries_notifier.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

Socket connectSocket(String token) {
  /**
   * Socket
   */
  Socket socket = io(
      'http://192.168.3.110:8080/driver',
      OptionBuilder().setTransports(['websocket']).setQuery(
          {'x-access-token': token}).build());

  socket.connect();

  return socket;
}

class MainScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeliveriesNotifier(),
      child: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Marker> _markers = [];
  GoogleMapController _mapController;
  LocalStorage _localStorage = new LocalStorage('auth');

  @override
  void initState() {
    DeliveriesNotifier deliveriesNotifier =
        Provider.of<DeliveriesNotifier>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      deliveriesNotifier.fetchDeliveries();
    });

    _initSocket();
    super.initState();
  }

  _initSocket() {
    Socket socket = connectSocket(_localStorage.getItem('token'));
    Timer.periodic(Duration(seconds: 5), (timer) {
      getCurrentPosition().then(
        (value) => socket.emit('send-driver-location',
            {'lat': value.latitude, 'long': value.longitude}),
      );
    });
  }

  _initMarkers(List<Delivery> deliveries) {
    _markers.clear();
    for (Delivery delivery in deliveries) {
      Marker marker = Marker(
        markerId: MarkerId(delivery.id.toString()),
        position: delivery.addressPoint,
        infoWindow: InfoWindow(
          title: delivery.productName,
          snippet: delivery.address,
        ),
      );

      setState(() {
        if (marker.position != null) {
          _markers.add(marker);
        }
      });
    }
  }

  _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  _moveCamera(num deliveryId) {
    Marker marker;
    for (Marker item in _markers) {
      if (item.markerId.value == deliveryId.toString()) {
        marker = item;
        break;
      }
    }
    if (marker == null) return;

    _mapController.moveCamera(CameraUpdate.newLatLng(marker.position));
    _mapController.showMarkerInfoWindow(marker.markerId);
  }

  @override
  Widget build(BuildContext context) {
    DeliveriesNotifier deliveriesNotifier =
        Provider.of<DeliveriesNotifier>(context);

    Size deviceSize = MediaQuery.of(context).size;
    List<Delivery> deliveries = deliveriesNotifier.getDeliveries();

    _initMarkers(deliveries);

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
                    markers: _markers.toSet(),
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(37.576183893224865, 126.97665492505988),
                      zoom: 10.0,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: deliveries.length,
                    itemBuilder: (BuildContext context, int index) =>
                        DeliveryView(
                      delivery: deliveries[index],
                      moveCamera: _moveCamera,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
