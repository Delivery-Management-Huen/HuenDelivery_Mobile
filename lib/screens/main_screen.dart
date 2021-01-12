import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/components/delivery/delivery_view.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) => DeliveryView(),
          ),
        ],
      ),
    );
  }
}
