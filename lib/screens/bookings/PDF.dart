// ignore: file_names
// ignore: file_names

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDF extends StatelessWidget {
  final List<dynamic> path;
  const PDF(this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text('RIDOBIKO', style: TextStyle(fontSize: 14 / scaleFactor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: path.map((e) {
                  var downloading = false;
                  return StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      return Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          SizedBox(
                              height: 500,
                              child: SfPdfViewer.network(e.toString())),
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                downloading = true;
                              });
                              var res = await _downloadFile(e.toString(),
                                  "${BookingFlow.selectedBooking!.bikesId}_${e.toString().split('/').last}");
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Invoice Downloaded at : ${res.path}',
                                          style: TextStyle(
                                              fontSize: 14 / scaleFactor))));
                              setState(() {
                                downloading = false;
                              });
                            },
                            child: downloading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator())
                                : Text('Download',
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor)),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static var httpClient = HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = Platform.isAndroid
        ? '/storage/emulated/0/Download'
        : (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
