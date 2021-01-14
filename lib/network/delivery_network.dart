import 'package:huen_delivery_mobile/models/delivery.dart';

class DeliveryNetwork {
  Future<List<Delivery>> getDeliveries() async {
    var d1 = Delivery();
    var d2 = Delivery();
    var d3 = Delivery();
    var d4 = Delivery();

    d1.id = 1;

    d2.id = 2;
    d2.address = '서울시 마포구 영등포역';

    d3.id = 3;
    d3.address = '서울시 광화문';

    d4.id = 4;
    d4.address = '서울시 경복궁';

    var list = [
      d1,
      d2,
      d3,
      d4,
    ];

    return list;
  }
}
