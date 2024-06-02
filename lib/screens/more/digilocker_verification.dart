// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:digilocker_client/digilocker_client.dart';
import 'package:digilocker_client/model/Aadhaar.dart';
import 'package:digilocker_client/model/issue.model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/screens/more/widgets/aadhaar_widget.dart';
import 'package:ridobiko/utils/snackbar.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:ridobiko/screens/more/issuer_screen.dart';
import 'package:ridobiko/screens/more/widgets/loading_aadhaar_widget.dart';
import 'package:ridobiko/utils/cred.dart';

final digilockerClientProvider = StateProvider<DigiLocker?>((ref) => null);

class DigilockerVerififcationScreen extends ConsumerStatefulWidget {
  const DigilockerVerififcationScreen({super.key});

  @override
  ConsumerState<DigilockerVerififcationScreen> createState() =>
      _DigilockerVerififcationScreenState();
}

class _DigilockerVerififcationScreenState
    extends ConsumerState<DigilockerVerififcationScreen> {
  int page = 0;
  List<Issuer> listOfIssuer = [];
  late DigiLocker digiLocker;
  late Aadhaar aadhaarData;

  ScreenshotController screenshotController = ScreenshotController();
  ScreenshotController controller1 = ScreenshotController();

  @override
  void initState() {
    super.initState();
    digiLocker = DigiLocker(
      clientID: Cred().digilockerClientId,
      clientSecret: Cred().digilockerClientSecret,
      callbackUrl: Cred().digilockerRedirectUri,
    );
    getListOfIssuer();
  }

  bool isFirst = false;

  bool aadhaarCheck = false;
  bool licenseCheck = false;
  bool licenseUploadedOnce = false;

  StepState stepState(int index) {
    if (index == 1) {
      return page > index
          ? (!aadhaarCheck ? StepState.error : StepState.complete)
          : (page == index ? StepState.indexed : StepState.disabled);
    } else if (index == 2) {
      return page > index
          ? (!licenseCheck ? StepState.error : StepState.complete)
          : (page == index ? StepState.indexed : StepState.disabled);
    }
    return page > index
        ? StepState.complete
        : (page == index ? StepState.indexed : StepState.disabled);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    TextStyle stepHeading = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18 / scaleFactor,
      color: Colors.black.withOpacity(0.8),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Digilocker Verification',
            style: TextStyle(fontSize: 16 / scaleFactor)),
        backgroundColor: const Color.fromRGBO(130, 0, 0, 1),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Theme(
            data: ThemeData(
              canvasColor: Colors.yellow,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: const Color.fromARGB(255, 157, 27, 27),
                    background: Colors.red,
                    secondary: const Color.fromARGB(255, 42, 145, 46),
                  ),
            ),
            child: Stepper(
              physics: const ClampingScrollPhysics(),
              elevation: 0,
              type: StepperType.vertical,
              currentStep: page,
              controlsBuilder: (context, details) => const Row(),
              onStepTapped: (v) => setState(
                () {
                  page = v;
                  if (kDebugMode) {
                    print(digiLocker.token);
                  }
                },
              ),
              steps: [
                Step(
                  state: stepState(0),
                  isActive: page >= 0,
                  title: Text(
                    'Login with Digilocker',
                    style: stepHeading,
                  ),
                  content: Column(
                    children: [
                      Text(
                          'Fetch documents from Digilocker and send them to us for processing.',
                          style: TextStyle(fontSize: 14 / scaleFactor)),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side:
                              BorderSide(color: Colors.red.shade900, width: 1),
                          foregroundColor: Colors.red.shade900,
                          fixedSize: const Size.fromHeight(42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: TextStyle(
                            fontSize: 20 / scaleFactor,
                            fontWeight: FontWeight.w500,
                          ),
                          shadowColor: Colors.grey.withOpacity(0.5),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          String authrizationUrl = Uri.https(
                            'digilocker.meripehchaan.gov.in',
                            '/public/oauth2/1/authorize',
                            {
                              'response_type': 'code',
                              'client_id': Cred().digilockerClientId,
                              'redirect_uri': Cred().digilockerRedirectUri,
                              'state': 'inflow',
                            },
                          ).toString();
                          final result = await FlutterWebAuth2.authenticate(
                            url: authrizationUrl,
                            callbackUrlScheme: 'myapp',
                          );
                          var code = Uri.parse(result).queryParameters['code'];
                          if (kDebugMode) {
                            print('Dcode $code');
                          }
                          String? error =
                              await digiLocker.authenticate(authCode: code!);
                          if (kDebugMode) {
                            print('error ${error ?? 'no error'}');
                          }
                          if (error != null) {
                            Toast(context, error);
                          }
                          isFirst = false;
                          setState(() => page++);
                        },
                        child: Text('DigiLocker',
                            style: TextStyle(fontSize: 14 / scaleFactor)),
                      ),
                    ],
                  ),
                ),
                Step(
                  state: stepState(1),
                  title: Text(
                    'Aadhaar Card',
                    style: stepHeading,
                  ),
                  isActive: page >= 1,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<Aadhaar?>(
                        future: digiLocker.getAadhaar(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            Timer(const Duration(milliseconds: 1500), () {
                              if (!isFirst) {
                                isFirst = true;
                                setState(() {});
                              }
                            });
                            return const LoadingAadhaarWidget();
                          } else if (snapshot.hasData &&
                              snapshot.data == null) {
                            return const Text('404');
                          } else {
                            aadhaarData = snapshot.data!;
                            return AadhaarWidget(
                              screenshotController: screenshotController,
                              aadhaarData: aadhaarData,
                            );
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor:
                                    const Color.fromRGBO(139, 0, 0, 1),
                              ),
                              onPressed: () async {
                                await sendAadhaarToServer();
                                setState(() {
                                  if (page < 4) page++;
                                });
                              },
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Step(
                  state: stepState(2),
                  isActive: page >= 2,
                  title: Text(
                    'Driving License',
                    style: stepHeading,
                  ),
                  content: FutureBuilder<String?>(
                    future: digiLocker.hasLicense(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LottieBuilder.asset(
                          'assets/animations/loading.json',
                          width: size.width * 0.8,
                        );
                      } else if (snapshot.data == null) {
                        return SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => getListOfIssuer(),
                                child: Text(
                                    'No Driving License found on your issued Document.',
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor)),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )),
                                    onPressed: () async {
                                      await getListOfIssuer();
                                      final data = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return IssueScreen(
                                              issuer: listOfIssuer,
                                              client: digiLocker,
                                            );
                                          },
                                        ),
                                      );
                                      if (data != null) {
                                        setState(() {});
                                      }
                                    },
                                    child: Text('Import Driving License',
                                        style: TextStyle(
                                            fontSize: 14 / scaleFactor)),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                              StepController(),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              width: size.width * 0.8,
                              height: size.width,
                              child: Builder(builder: (context) {
                                sendLicenseToServer(snapshot.data!);
                                return SfPdfViewer.network(
                                  'https://digilocker.meripehchaan.gov.in/public/oauth2/1/file/${snapshot.data!}',
                                  headers: {
                                    "Authorization":
                                        "Bearer ${digiLocker.token}"
                                  },
                                );
                              }),
                            ),
                            StepController(),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Step(
                  state: stepState(3),
                  isActive: page >= 3,
                  title: Text(
                    'Final Status',
                    style: stepHeading,
                  ),
                  content: Column(
                    children: <Widget>[
                      Visibility(
                        visible: (aadhaarCheck && licenseCheck),
                        child: LottieBuilder.asset(
                            'assets/animations/verified.json'),
                      ),
                      const SizedBox(height: 8),
                      Visibility(
                        visible: !(aadhaarCheck && licenseCheck),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.blueGrey),
                          ),
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Visibility(
                                  visible: !aadhaarCheck,
                                  child: Text(
                                    'Aadhaar not verified',
                                    style: TextStyle(
                                      fontSize: 20 / scaleFactor,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Visibility(
                                  visible: !licenseCheck,
                                  child: Text(
                                    'License not verified',
                                    style: TextStyle(
                                      fontSize: 20 / scaleFactor,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Visibility(
                        visible: (aadhaarCheck && licenseCheck),
                        child: Text(
                          'You\'re Verified!',
                          style: TextStyle(
                            fontSize: 20 / scaleFactor,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff2196f3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
                          fixedSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: TextStyle(
                            fontSize: 20 / scaleFactor,
                            fontWeight: FontWeight.w500,
                          ),
                          shadowColor: Colors.grey.withOpacity(0.5),
                          elevation: 5,
                        ),
                        onPressed: () async {
                          await ref
                              .read(authControllerProvider.notifier)
                              .getUserDetails();
                          Navigator.pop(context);
                        },
                        child: Text('GO BACK',
                            style: TextStyle(fontSize: 14 / scaleFactor)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding StepController() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
            ),
            onPressed: () => setState(
              () {
                if (page < 4) page++;
              },
            ),
            child: const Text(
              "Next",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getListOfIssuer() async {
    List<Issuer>? list = await digiLocker.listOfIssuer();
    if (list != null) {
      listOfIssuer = [];
      for (var i in list) {
        if (i.issuerid!.toLowerCase().contains('in.gov.transport')) {
          if (kDebugMode) {
            print(i.name);
          }
          listOfIssuer.add(i);
        }
      }
    }
  }

  Future<void> sendAadhaarToServer() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Saving Aadhaar ...'),
      duration: Duration(seconds: 1),
      backgroundColor: Colors.blue,
    ));

    final im = await screenshotController.capture();
    send(image) async {
      var directory = '';
      if (Platform.isIOS) {
        directory = (await getApplicationSupportDirectory()).path;
      } else {
        directory = (await getExternalStorageDirectory())?.path ?? '';
      }
      // final directory = (await getTemporaryDirectory())?.path;
      String location = '$directory/aadhaar_ridoboko.png';
      File imgFile = File(location);
      await imgFile.writeAsBytes(image!);
      String token = ref.read(userProvider)!.token!;

      var headers = {'token': token};
      var i = await XFile(location).readAsBytes();
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${Constants().url}android_app_customer/api/updateAdhaarData.php'));
      request.fields.addAll({
        'adhaar_id': aadhaarData.uid.replaceAll('x', 'X'),
      });
      request.files.add(http.MultipartFile.fromBytes(
        'adhaar_front',
        i,
        filename: location,
        contentType: MediaType("file", "png"),
      ));
      request.headers.addAll(headers);
      final response = await request.send();
      if (response.statusCode == 200) {
        var json = jsonDecode(await response.stream.bytesToString());

        if (kDebugMode) {
          print(json);
        }

        aadhaarCheck = true;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(' E-Aadhaar saved successful'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ));
      } else {
        aadhaarCheck = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(' Some error occurred Try again '),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ));
      }
    }

    await send(im);
  }

  Future<void> sendLicenseToServer(String uri) async {
    if (kDebugMode) {
      print("uri:$uri");
    }

    final res = await http.get(
      Uri.parse(
          'https://digilocker.meripehchaan.gov.in/public/oauth2/1/file/$uri'),
      headers: {"Authorization": "Bearer ${digiLocker.token}"},
    );
    if (res.statusCode != 200) return;
    Uint8List dl = res.bodyBytes;

    // isDLUploaded = false;
    String token = ref.read(userProvider)!.token!;

    var headers = {'token': token};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${Constants().url}android_app_customer/api/updateDrivingLicenseData.php'));
    request.fields.addAll({
      'driving_id': 'XXXXX',
    });
    request.files.add(http.MultipartFile.fromBytes(
      'driving_license',
      dl,
      filename: '$uri.pdf',
      contentType: MediaType("file", "pdf"),
    ));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      licenseCheck = true;
      if (licenseUploadedOnce == false) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('License Uploaded !'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ));
      }
      licenseUploadedOnce = true;
    } else {
      aadhaarCheck = false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(' Some error occurred Try again !'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    }
  }
}
