// ignore_for_file: use_build_context_synchronously, camel_case_types, prefer_typing_uninitialized_variables, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridobiko/controllers/more/more_controller.dart';
import 'package:ridobiko/screens/more/NewSecurityDeposit.dart';

import 'package:ridobiko/utils/snackbar.dart';

import '../../data/BookingFlow.dart';
import '../../data/documents.dart';

class LicenseUpload extends ConsumerStatefulWidget {
  const LicenseUpload({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return license();
  }
}

class license extends ConsumerState {
  XFile? _licence;
  var _width;
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    bool pb = ref.watch(moreControllerProvider);
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          // title: Align(
          //     alignment: Alignment.centerRight,
          //     child: Text('STEP 2/2',
          //         style: TextStyle(
          //             color: Colors.grey, fontSize: 15 / scaleFactor))),
          backgroundColor: Colors.grey[200],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.grey[200],
                    child: Wrap(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Upload Driving License',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0 / scaleFactor,
                                    fontWeight: FontWeight.bold),
                              )),
                          Visibility(
                              visible: Documents.dl_verfied == '1',
                              replacement: Flexible(
                                  child: Text(
                                'Verification Pending',
                                style: TextStyle(
                                    fontSize: 14 / scaleFactor,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.yellow[700]),
                              )),
                              child: Flexible(
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Image.asset(
                                        "assets/images/check-mark.png",
                                        height: 30,
                                        width: 30,
                                      )))),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 40, bottom: 20),
                          child: Text(
                            'Scan or upload document images and send them to us for processing',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0 / scaleFactor),
                          )),
                    ])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: _width * 0.8,
                      child: GestureDetector(
                        onTap: () async {
                          if (Documents.dl_verfied == "0") {
                            showDialog(
                                context: context,
                                builder: (BuildContext bcontext) {
                                  return AlertDialog(
                                      title: Text(
                                          "From where do you want to take the photo?",
                                          style: TextStyle(
                                              fontSize: 14 / scaleFactor)),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            GestureDetector(
                                              child: Text("Gallery",
                                                  style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor)),
                                              onTap: () async {
                                                Navigator.pop(bcontext);
                                                _licence = await ImagePicker()
                                                    .pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                setState(() {});
                                              },
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.all(8.0)),
                                            GestureDetector(
                                              child: Text("Camera",
                                                  style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor)),
                                              onTap: () async {
                                                Navigator.pop(bcontext);
                                                _licence = await ImagePicker()
                                                    .pickImage(
                                                        source:
                                                            ImageSource.camera);
                                                setState(() {});
                                              },
                                            )
                                          ],
                                        ),
                                      ));
                                });
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 7,
                          child: Column(children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.grey,
                              child: Center(
                                  child: Documents.dl != '-' && _licence == null
                                      ? Image.network(
                                          Documents.dl,
                                          width: _width * 0.7,
                                          height: 340,
                                          fit: BoxFit.fill,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        )
                                      : _licence == null
                                          ? Image.asset(
                                              "assets/images/aadharbg.png",
                                            )
                                          : Image.file(File(_licence!.path),
                                              width: _width * 0.7,
                                              height: 340,
                                              fit: BoxFit.fill)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'License Front',
                              style: TextStyle(fontSize: 14 / scaleFactor),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                // int? securityDeposit = BookingFlow.fromMore == false
                //     ? BookingFlow.selectedBikeSubs != null
                //         ? int.parse(BookingFlow.selectedBikeSubs!.deposit!)
                //         : int.parse(BookingFlow.selectedBike!.deposit!)
                //     : null;

                // if (Documents.dl_verfied == '1' ||
                //     (Documents.dl.isNotEmpty && _licence == null)) {
                //   BookingFlow.fromMore
                //       ? Navigator.pushAndRemoveUntil(
                //           context,
                //           MaterialPageRoute(builder: (b) => const DocUpload()),
                //           (route) => false)
                //       : Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (builder) =>
                //                   NewSecurityDepoPB(securityDeposit)));
                //   return;
                // }
                if (_licence != null) {
                  _uploadImageToServer();
                } else if (Documents.dl != "-") {
                  int? securityDeposit = BookingFlow.fromMore == false
                      ? BookingFlow.selectedBikeSubs != null
                          ? int.parse(BookingFlow.selectedBikeSubs!.deposit!)
                          : int.parse(BookingFlow.selectedBike!.deposit!)
                      : null;
                  BookingFlow.fromMore
                      ? Navigator.pop(context)
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) =>
                                  NewSecurityDepoPB(securityDeposit)));
                } else {
                  Toast(context, "Please a Licence first");
                }
              },
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color.fromRGBO(139, 0, 0, 1),
                            Colors.red.shade300,
                          ])),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        pb
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Save & Continue",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15 / scaleFactor),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadImageToServer() async {
    await ref
        .read(moreControllerProvider.notifier)
        .updateLicence(context, _licence);

    // setState(() {
    //   _pb = true;
    // });
    // var prefs = await SharedPreferences.getInstance();
    // var token = prefs.getString('token') ?? "";
    // var headers = {'token': token};
    // var request = http.MultipartRequest(
    //     'POST',
    //     Uri.parse(
    //         'https://www.ridobiko.com/android_app_customer/api/updateDrivingLicenseData.php'));

    // request.fields.addAll({
    //   'driving_id': 'driving_new_id',
    // });
    // request.files.add(
    //     await http.MultipartFile.fromPath('driving_license', _licence!.path));
    // request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();
    // setState(() {
    //   _pb = false;
    // });

    // if (response.statusCode == 200) {
    //   var json = jsonDecode(await response.stream.bytesToString());
    //   int? securityDeposit = BookingFlow.fromMore == false
    //       ? BookingFlow.selectedBikeSubs != null
    //           ? int.parse(BookingFlow.selectedBikeSubs!.deposit!)
    //           : int.parse(BookingFlow.selectedBike!.deposit!)
    //       : null;
    //   BookingFlow.fromMore
    //       ? Navigator.pushAndRemoveUntil(
    //           context,
    //           MaterialPageRoute(builder: (builder) => const DocUpload()),
    //           (route) => false)
    //       : Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //               builder: (builder) => NewSecurityDepoPB(securityDeposit)));
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Some error occurred Try again..')));
    // }
  }
}
