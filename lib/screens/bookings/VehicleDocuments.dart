// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ridobiko/data/VehicleDocumentData.dart';
import 'package:http/http.dart' as http;

class VehicleDocuments extends StatelessWidget {
  final VehicleDocumentData? vehicleDocumentData;
  VehicleDocuments(this.vehicleDocumentData, {super.key});

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    List docs = [
      [vehicleDocumentData?.rc, "RC"],
      [vehicleDocumentData?.insurance, "Insurance"],
      [vehicleDocumentData?.puc, "PUC"],
      //  [vehicleDocumentData?.purchaseBill, "Purchase Bill"],
      [vehicleDocumentData?.permitA, "Permit A"],
      [vehicleDocumentData?.permitB, "Permit B"],
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Documents',
            style: TextStyle(fontSize: 14 / scaleFactor)),
        backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            bool visible = false;
            bool isloading = false;
            return StatefulBuilder(
              builder: (context, setState) => Container(
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: Center(
                        child: FullScreenWidget(
                          child: CachedNetworkImage(
                            imageUrl: docs[index][0] ?? '',
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, progress) {
                              if (progress.progress == null) {
                                return const CircularProgressIndicator();
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.progress,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) => Stack(
                              children: [
                                Image.asset('assets/images/ZIp-Code.png'),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    margin: const EdgeInsets.only(bottom: 40),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: const Color(0xffdadada),
                                    ),
                                    child: Text(
                                      'ERROR 404',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14 / scaleFactor,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 25,
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10)),
                          color: Colors.black12,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Text(docs[index][1],
                                style: TextStyle(fontSize: 14 / scaleFactor)
                                // style: const TextStyle(color: Colors.white),
                                ),
                            const Spacer(),
                            InkWell(
                              onTap: () async {
                                setState(() => isloading = true);
                                try {
                                  var response =
                                      await http.get(Uri.parse(docs[index][0]));
                                  if (response.statusCode == 200) {
                                    var documentDirectory =
                                        await getApplicationDocumentsDirectory();
                                    var firstPath =
                                        "${documentDirectory.path}/images";
                                    var filePathAndName =
                                        '${documentDirectory.path}/images/${docs[index][1].toString().replaceAll(' ', '_')}.png';
                                    await Directory(firstPath)
                                        .create(recursive: true);
                                    File file2 = File(filePathAndName);
                                    file2.writeAsBytesSync(response.bodyBytes);
                                    await OpenFilex.open(file2.path);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Download Successful')),
                                    );
                                    setState(() => isloading = false);
                                    return;
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Download Failed !')),
                                    );
                                    setState(() => isloading = false);
                                    return;
                                  }
                                } catch (e) {
                                  setState(() => isloading = false);
                                }
                              },
                              child: const Icon(
                                Icons.download,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      child: Visibility(
                        visible: isloading,
                        child: const Center(
                          child: SizedBox(
                            width: 60,
                            child: LinearProgressIndicator(
                              minHeight: 7,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: 5,
        ),
      ),
    );
  }
}

class DocumentWidget extends StatelessWidget {
  const DocumentWidget({
    super.key,
    required this.vehicleDocument,
    required this.type,
  });

  final String? vehicleDocument;
  final String type;

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(139, 0, 0, 1).withOpacity(0.4),
      ),
      child: Flexible(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(
                vehicleDocument ?? "",
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      '400',
                      style: TextStyle(
                        fontSize: 25 / scaleFactor,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 25,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                  color: Colors.black12,
                ),
                child: Center(
                    child: Text(
                  type,
                  style: TextStyle(
                      color: Colors.white, fontSize: 14 / scaleFactor),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
