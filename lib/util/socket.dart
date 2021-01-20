import 'dart:io';

import 'package:huen_delivery_mobile/config/config.dart';
import 'package:socket_io_client/socket_io_client.dart';

Socket connectDeliverySocket(String token, Function handleDeliveryCreated) {
  Socket socket = io(
      '$SERVER_IP/delivery',
      OptionBuilder().setTransports(['websocket']).setQuery(
          {'x-access-token': token}).build());

  socket.connect();

  socket.on('create-new-delivery', handleDeliveryCreated);

  return socket;
}
