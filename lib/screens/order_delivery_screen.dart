import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huen_delivery_mobile/config/config.dart';
import 'package:huen_delivery_mobile/exception/TokenException.dart';
import 'package:huen_delivery_mobile/models/delivery.dart';
import 'package:huen_delivery_mobile/notifiers/order_delivery_notifier.dart';
import 'package:huen_delivery_mobile/screens/main_screen.dart';
import 'package:huen_delivery_mobile/styles/palette.dart';
import 'package:huen_delivery_mobile/util/dialog.dart';
import 'package:provider/provider.dart';

class OrderDeliveryScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderDeliveryNotifier(),
      child: OrderDeliveryScreen(),
    );
  }
}

class OrderDeliveryScreen extends StatefulWidget {
  @override
  _OrderDeliveryScreenState createState() => _OrderDeliveryScreenState();
}

class _OrderDeliveryScreenState extends State<OrderDeliveryScreen> {
  List<Delivery> _deliveries;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchDeliveries(context);
    });
  }

  _fetchDeliveries(BuildContext context) async {
    OrderDeliveryNotifier orderDeliveryNotifier =
        Provider.of<OrderDeliveryNotifier>(context, listen: false);

    try {
      await orderDeliveryNotifier.fetchDeliveries();
    } catch (err) {
      if (err is TokenException) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (router) => false);
        showCustomDialog(context, '세션 만료', '다시 로그인해주세요');
      } else {
        showCustomDialog(context, '오류 발생', err.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    OrderDeliveryNotifier orderDeliveryNotifier =
        Provider.of<OrderDeliveryNotifier>(context);

    List<Delivery> deliveries = orderDeliveryNotifier.getDeliveries();

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 20),
            decoration: BoxDecoration(
              color: Palette.gray141414,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '순서대로 정렬해주세요',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await orderDeliveryNotifier.updateOrder();
                          showCustomDialog(context, '수정 성공!', '배송 순서를 변경했습니다');
                        } catch (err) {
                          if (err is TokenException) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (router) => false);
                            showCustomDialog(context, '세션 만료', '다시 로그인해주세요');
                          } else {
                            showCustomDialog(context, '수정 실패', err.toString());
                          }
                        }
                      },
                      child: Text(
                        '수정',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Palette.gray141414,
                          minimumSize: Size(60, 30)),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Palette.gray141414,
                          minimumSize: Size(60, 30)),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _fetchDeliveries(context),
              child: ReorderableListView(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                children: [
                  for (final item in deliveries)
                    GestureDetector(
                      key: ValueKey(item),
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                              width: 200,
                              height: 400,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage('$SERVER_IP/static/${item.image}'),
                                  fit: BoxFit.cover,
                                )
                              ),
                            ),
                          );
                        },
                      ),
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Palette.grayDCDCDC,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item.productName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Palette.gray141414,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  item.customer.id,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Palette.gray444444,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              item.customer.address,
                              style: TextStyle(
                                fontSize: 14,
                                color: Palette.gray444444,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
                onReorder: orderDeliveryNotifier.reorderData,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
