import 'dart:async';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:huen_delivery_mobile/components/delivery/delivery_view.dart';
import 'package:huen_delivery_mobile/exception/TokenException.dart';
import 'package:huen_delivery_mobile/models/delivery.dart';
import 'package:huen_delivery_mobile/notifiers/deliveries_notifier.dart';
import 'package:huen_delivery_mobile/notifiers/end_delivery_notifier.dart';
import 'package:huen_delivery_mobile/util/dialog.dart';
import 'package:huen_delivery_mobile/util/token.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

// Socket connectSocket(String token) {
//   /**
//    * Socket
//    */
//   Socket socket = io(
//       'http://192.168.3.110:8080/driver',
//       OptionBuilder().setTransports(['websocket']).setQuery(
//           {'x-access-token': token}).build());
//
//   socket.connect();
//
//   return socket;
// }

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchDeliveries(context);
    });
    // _initSocket();
  }

  Future<void> _fetchDeliveries(BuildContext context) async {
    DeliveriesNotifier deliveriesNotifier =
        Provider.of<DeliveriesNotifier>(context, listen: false);

    try {
      await deliveriesNotifier.fetchDeliveries();
    } catch (err) {
      if (err is TokenException) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (router) => false);
        showCustomDialog(context, '세션 만료', '다시 로그인해주세요');
      } else {
        showCustomDialog(context, '오류 발생', err.toString());
      }
    }
  }

  // _initSocket() {
  //   Socket socket = connectSocket(getToken());
  //   Timer.periodic(Duration(seconds: 5), (timer) {
  //     getCurrentPosition().then(
  //       (value) => socket.emit('send-driver-location',
  //           {'lat': value.latitude, 'long': value.longitude}),
  //     );
  //   });
  // }

  _initMarkers(List<Delivery> deliveries) {
    _markers.clear();
    for (Delivery delivery in deliveries) {
      Marker marker = Marker(
        markerId: MarkerId(delivery.idx.toString()),
        position: delivery.addressPoint,
        infoWindow: InfoWindow(
          title: delivery.productName,
          snippet: delivery.customer.address,
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
    setState(() {
      _mapController = controller;
    });
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

    List<Delivery> deliveries = deliveriesNotifier.getDeliveries();

    Size deviceSize = MediaQuery.of(context).size;

    _initMarkers(deliveries);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.loose,
        children: [
          Column(
            children: [
              Container(
                height: deviceSize.height * 0.65,
                child: getGoogleMap(),
              ),
              Expanded(
                child: deliveries.length <= 0
                    ? Center(
                        child: Text('오늘 배송할 물품이 없습니다'),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _fetchDeliveries(context),
                        child: ListView.builder(
                          itemCount: deliveries.length,
                          itemBuilder: (BuildContext context, int index) =>
                              ChangeNotifierProvider(
                            create: (context) => EndDeliveryNotifier(),
                            child: DeliveryView(
                              key: ObjectKey(deliveries[index]),
                              delivery: deliveries[index],
                              moveCamera: _moveCamera,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
          getLoading(deviceSize.width, deviceSize.height),
        ],
      ),
    );
  }

  Widget getGoogleMap() {
    return GoogleMap(
      markers: _markers.toSet(),
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(37.576183893224865, 126.97665492505988),
        zoom: 10.0,
      ),
    );
  }

  getLoading(width, height) {
    if (_mapController == null) {
      print("loading");
      return Container(
        color: Colors.white,
        width: width,
        height: height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container();
  }
}
