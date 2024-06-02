import 'package:cached_network_image/cached_network_image.dart';
import 'package:digilocker_client/digilocker_client.dart';
import 'package:digilocker_client/model/issue.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ridobiko/screens/more/document_import.dart';

class IssueScreen extends ConsumerStatefulWidget {
  const IssueScreen({this.issuer, required this.client, super.key});
  final List<Issuer>? issuer;
  final DigiLocker client;

  @override
  ConsumerState<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends ConsumerState<IssueScreen> {
  late final List<Issuer>? issuer;
  @override
  void initState() {
    issuer = widget.issuer;
    if (issuer != null) {
      for (int i = 0; i < (issuer?.length ?? 0); i++) {
        if (issuer?.elementAt(i).name?.toLowerCase() ==
            'ministry of road transport and highways') {
          Issuer t = issuer![0];
          issuer?[0] = issuer![i];
          issuer![i] = t;
        }
      }
    }

    super.initState();
  }

  onClick(int index) async {
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DocumentImportScreen(
            orgid: issuer?.elementAt(index).orgid ?? '',
            name: issuer?.elementAt(index).name ?? '',
            client: widget.client,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Issuer', style: TextStyle(fontSize: 14 / scaleFactor)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            shadowColor: Colors.black,
            elevation: 16,
            margin: const EdgeInsets.all(16),
            child: SizedBox(
              height: 100,
              child: InkWell(
                onTap: () async {
                  await onClick(0);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox.square(
                        dimension: 60,
                        child: CachedNetworkImage(
                          imageUrl: issuer?.elementAt(0).logo ?? '',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          issuer?.elementAt(0).name ?? '',
                          style: TextStyle(fontSize: 14 / scaleFactor),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GridView.builder(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 4 / 6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: widget.issuer?.length ?? 0,
            itemBuilder: (context, index) {
              return Card(
                shadowColor: Colors.black,
                elevation: 16,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () async {
                    await onClick(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox.square(
                          dimension: 80,
                          child: CachedNetworkImage(
                            imageUrl:
                                widget.issuer?.elementAt(index).logo ?? '',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Text(
                          widget.issuer?.elementAt(index).name ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12 / scaleFactor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
