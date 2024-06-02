// // ignore_for_file: use_build_context_synchronously

// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, camel_case_types

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:ridobiko/screens/more/LicenseUpload.dart';
import 'package:ridobiko/controllers/more/more_controller.dart';
import 'package:ridobiko/utils/snackbar.dart';

import '../../data/documents.dart';

class AadharUpload extends ConsumerStatefulWidget {
  const AadharUpload({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return aadhar();
  }
}

class aadhar extends ConsumerState {
  var _width;
  XFile? _front;

  XFile? _back;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;

    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    bool pb = ref.watch(moreControllerProvider);

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
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
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    color: Colors.grey[200],
                    child: Wrap(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Uploaded Aadhaar Card',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0 / scaleFactor,
                                fontWeight: FontWeight.bold),
                          ),
                          Visibility(
                              visible: Documents.aadhar_verfied == '1',
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
                      const SizedBox(height: 40)
                      // Padding(
                      //     padding:
                      //         EdgeInsets.only(top: 10, right: 40, bottom: 20),
                      //     child: Text(
                      //       'Scan upload document images and send them to us for processing',
                      //       style:
                      //           TextStyle(color: Colors.grey, fontSize: 15.0),
                      //     )),
                    ])),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    GestureDetector(
                      onTap: () async {
                        // _front= await ImagePicker().pickImage(source: ImageSource.camera);
                        //  setState((){});
                        if (Documents.aadhar_verfied == "0") {
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
                                              _front = await ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery);
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
                                              _front = await ImagePicker()
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
                      child: SizedBox(
                        width: _width / 2,
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 7,
                          child: Column(children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                color: Colors.grey,
                                child: Center(
                                  child: _front == null &&
                                          Documents.adhaar_front != '-'
                                      ? Image.network(
                                          Documents.adhaar_front,
                                          width: _width * 0.35,
                                          height: 200,
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
                                      : _front == null
                                          ? Image.asset(
                                              "assets/images/aadharbg.png",
                                            )
                                          : Image.file(
                                              File(_front!.path),
                                              width: _width * 0.35,
                                              height: 200,
                                              fit: BoxFit.fill,
                                            ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Front',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16 / scaleFactor,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        // _back= await ImagePicker().pickImage(source: ImageSource.camera);
                        // setState((){});
                        if (Documents.aadhar_verfied == "0") {
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
                                              _back = await ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery);
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
                                              _back = await ImagePicker()
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
                      child: SizedBox(
                        width: _width / 2,
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 7,
                          child: Column(children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.grey,
                              child: Center(
                                child: _back == null &&
                                        Documents.adhaar_back != '-'
                                    ? Image.network(
                                        Documents.adhaar_back,
                                        fit: BoxFit.fill,
                                        width: _width * 0.35,
                                        height: 200,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
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
                                    : _back == null
                                        ? Image.asset(
                                            "assets/images/aadharbg.png",
                                          )
                                        : Image.file(
                                            File(_back!.path),
                                            width: _width * 0.35,
                                            height: 200,
                                            fit: BoxFit.fill,
                                          ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('Back',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16 / scaleFactor,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(
                              height: 10,
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ]),
                ),
              ]),
            ),
            InkWell(
              onTap: () {
                if (Documents.aadhar_verfied == '1' ||
                    (Documents.adhaar_back != "-" &&
                        Documents.adhaar_front != "-" &&
                        _back == null &&
                        _front == null)) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LicenseUpload()));
                  return;
                }
                _front == null || _back == null
                    ? Toast(context, "Please upload all the images")
                    : _uploadImageToServer();
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
        .updateAadhaar(context, _front, _back);

    // if (Documents.aadhar_verfied == "1") {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => LicenseUpload()));
    //   return;
    // }
    // setState(() {
    //   _pb = true;
    // });
    // var prefs = await SharedPreferences.getInstance();
    // var token = prefs.getString('token') ?? "";
    // var headers = {'token': token};
    // var request = http.MultipartRequest(
    //     'POST',
    //     Uri.parse(
    //         'https://www.ridobiko.com/android_app_customer/api/updateAdhaarData.php'));
    // request.files
    //     .add(await http.MultipartFile.fromPath('adhaar_front', _front!.path));
    // request.files
    //     .add(await http.MultipartFile.fromPath('adhaar_back', _back!.path));
    // request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();
    // setState(() {
    //   _pb = false;
    // });
    // if (response.statusCode == 200) {
    //   var json = jsonDecode(await response.stream.bytesToString());
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text(json['message'])));
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => LicenseUpload()));
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Some error occurred Try again..')));
    // }
  }
}
