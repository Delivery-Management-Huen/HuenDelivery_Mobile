import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/styles/palette.dart';

class DeliveryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                      '물품1',
                      style: TextStyle(
                        fontSize: 14,
                        color: Palette.gray141414,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'chlwlsdn',
                      style: TextStyle(
                        fontSize: 11,
                        color: Palette.gray444444,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  '서울 특별시 어디구 어디동 어디빌딩 어디층 어디호',
                  style: TextStyle(
                    fontSize: 10,
                    color: Palette.gray444444,
                  ),
                ),
              ],
            ),
          ),
          ButtonTheme(
            buttonColor: Palette.blue6685A8,
            minWidth: 60,
            height: 25,
            child: RaisedButton(
              child: Text('출발',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              onPressed: () => {},
            ),
          ),
        ],
      ),
    );
  }
}
