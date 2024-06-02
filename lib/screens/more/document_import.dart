// ignore_for_file: use_build_context_synchronously

import 'package:digilocker_client/digilocker_client.dart';
import 'package:digilocker_client/model/document.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentImportScreen extends ConsumerStatefulWidget {
  const DocumentImportScreen({
    required this.orgid,
    required this.name,
    required this.client,
    super.key,
  });
  final String orgid;
  final String name;
  final DigiLocker client;

  @override
  ConsumerState<DocumentImportScreen> createState() =>
      _DocumentImportScreenState();
}

class _DocumentImportScreenState extends ConsumerState<DocumentImportScreen> {
  List<Document>? list = [];
  String doctype = 'DRVLC';
  bool consent = false;
  String example = '';
  bool isLoading = false;

  @override
  void initState() {
    getCos();
    super.initState();
  }

  Future getCos() async {
    final data = await widget.client.getParam(widget.orgid, doctype);
    if (data != null) {
      example = data[0]['example'].toString();
    }
    setState(() {});
  }

  String dlno = '';
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text('Driving License',
                style: TextStyle(fontSize: 14 / scaleFactor)),
            subtitle:
                Text(widget.name, style: TextStyle(fontSize: 14 / scaleFactor)),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextField(
                  onChanged: (v) => dlno = v,
                  onSubmitted: (v) => setState(() {}),
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    label: Text('Driving License No',
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  example,
                  style:
                      TextStyle(fontSize: 14 / scaleFactor, color: Colors.grey),
                ),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: consent,
                    onChanged: (v) {
                      setState(() {
                        consent = !consent;
                      });
                    },
                  ),
                  SizedBox(
                    width: size.width * 0.8,
                    child: Text(
                        'I provide my consent to share my Aadhaar Number, Date of Birth and Name from my Aadhaar eKYC information with the ${widget.name} for the purpose of fetching my driving License into Digilocker',
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                  ),
                ],
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: consent && dlno.isNotEmpty
                    ? const Color(0xff2196f3)
                    : Colors.grey,
                margin: const EdgeInsets.all(12),
                child: InkWell(
                  onTap: () async {
                    if (isloading) return;
                    setState(() {
                      isloading = true;
                    });
                    final data = await widget.client.pullDocument({
                      'orgid': widget.orgid,
                      'doctype': 'DRVLC',
                      'consent': 'Y',
                      'dlno': dlno,
                    });
                    if (data != null) {
                      Navigator.pop(context, data['uri']);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text(' Error! Try again. '),
                        backgroundColor: Colors.red.withOpacity(0.7),
                        duration: const Duration(seconds: 1),
                      ));
                    }
                    setState(() {
                      isloading = false;
                    });
                  },
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Get Document',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18 / scaleFactor,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
