import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:huen_delivery_mobile/config/config.dart';

class UploadNetwork {
  Future<http.Response> upload(File image) async {
    final stream =
        new http.ByteStream(DelegatingStream.typed(image.openRead()));
    final length = await image.length();
    final uri = Uri.parse('$END_POINT/upload');
    final request = http.MultipartRequest('POST', uri);

    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(image.path));

    request.files.add(multipartFile);
    final res =
        await http.Response.fromStream(await request.send());

    return res;
  }
}
