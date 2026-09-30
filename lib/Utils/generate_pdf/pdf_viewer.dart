import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../constants.dart';

class PFDViewerPage extends StatefulWidget {
  final File? file;
  const PFDViewerPage({
    super.key,
    this.file,
  });

  @override
  PFDViewerPageState createState() => PFDViewerPageState();
}

class PFDViewerPageState extends State<PFDViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          'PDF',
          style: TextStyle(color: primaryColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Share.shareXFiles([XFile(widget.file!.path)],
                    text: 'Great picture');
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: PDFView(
        filePath: widget.file!.path,
      ),
    );
  }
}
