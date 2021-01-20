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
import 'package:huen_delivery_mobile/styles/palette.dart';
import 'package:huen_delivery_mobile/util/dialog.dart';
import 'package:huen_delivery_mobile/util/socket.dart';
import 'package:huen_delivery_mobile/util/token.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

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

  handleDeliveryCreated(data) {
    DeliveriesNotifier deliveriesNotifier =
        Provider.of<DeliveriesNotifier>(context, listen: false);

    List deliveries =
        (data['data'] as List).map((e) => Delivery.fromJson(e)).toList();

    deliveriesNotifier.addDeliveries(deliveries);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      showCustomDialog(context, '알림', '새로운 배송이 접수되었어요');
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchDeliveries(context);
    });

    getToken()
        .then((value) => connectDeliverySocket(value, handleDeliveryCreated));
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
              Stack(children: [
                Container(
                  height: deviceSize.height * 0.65,
                  child: getGoogleMap(),
                ),
                Positioned(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/order'),
                    child: Icon(
                      Icons.settings,
                      size: 28,
                      color: Palette.gray141414,
                    ),
                  ),
                  top: 30,
                  left: 10,
                ),
              ]),
              Expanded(
                child: deliveries.length <= 0
                    ? RefreshIndicator(
                        onRefresh: () => _fetchDeliveries(context),
                        child: Stack(
                          children: [
                            ListView(),
                            Center(
                              child: Text('오늘 배송할 물품이 없습니다'),
                            ),
                          ],
                        ),
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
