import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:huen_delivery_mobile/config/config.dart';
import 'package:socket_io_client/socket_io_client.dart';

Socket connectSocket(String token, Function handleDeliveryCreated) {
  Socket deliverySocket = io(
      '$SERVER_IP/delivery',
      OptionBuilder().setTransports(['websocket']).setQuery(
          {'x-access-token': token}).build());

  Socket driverSocket = io(
      '$SERVER_IP/driver',
      OptionBuilder().setTransports(['websocket']).setQuery(
          {'x-access-token': token}).build());

  deliverySocket.connect();
  driverSocket.connect();

  deliverySocket.on('create-new-delivery', handleDeliveryCreated);

  Timer.periodic(Duration(seconds: 10), (timer) async {
    Position position = await Geolocator.getCurrentPosition();

    driverSocket.emit('send-driver-location', {
      'lat': position.latitude,
      'long': position.longitude,
    });
  });

  return deliverySocket;
}
