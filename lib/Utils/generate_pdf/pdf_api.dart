import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File?> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await path_provider.getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<File> loadNetworkFile(String? url) async {
    final response = await http.get(Uri.parse(url!));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  static Future<File> _storeFile(String? url, List<int>? bytes) async {
    final filename = path.basename(url!);
    final dir = await path_provider.getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$filename");
    await file.writeAsBytes(bytes!, flush: true);
    return file;
  }
}
