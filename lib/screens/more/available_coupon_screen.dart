import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ridobiko/controllers/more/more_controller.dart';
import 'package:ridobiko/data/coupon.dart';

class AvailableCouponsScreen extends ConsumerStatefulWidget {
  const AvailableCouponsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AvailableCouponsScreenState();
}

class _AvailableCouponsScreenState
    extends ConsumerState<AvailableCouponsScreen> {
  TextEditingController controller = TextEditingController();
  List<CouponModel> couponList = [];
  bool isLoading = true;

  _getCoupons() async {
    final response =
        await ref.read(moreControllerProvider.notifier).getCoupons(context);
    couponList = response;
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getCoupons();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Available Coupons',
              style: TextStyle(fontSize: 17 / scaleFactor)),
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, -1),
          ),
        ),
        body: Container(
          color: Colors.grey.shade200,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                child: TextField(
                  controller: controller,
                  onChanged: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    for (int i = 0; i < couponList.length; i++) {
                      if (couponList[i].coupon.toLowerCase() ==
                          value.toLowerCase()) {
                        Navigator.pop(context, i);
                      }
                    }
                  },
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    constraints: const BoxConstraints(
                      maxHeight: 60,
                    ),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 0, color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 0, color: Colors.white),
                    ),
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Type coupon code here',
                    suffix: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: controller.text.isNotEmpty
                            ? Colors.blueAccent
                            : Colors.grey.shade300,
                      ),
                      onPressed: () {
                        for (int i = 0; i < couponList.length; i++) {
                          if (couponList[i].coupon.toLowerCase() ==
                              controller.text.toLowerCase()) {
                            Navigator.pop(context, i);
                          }
                        }
                      },
                      child: Text('Apply',
                          style: TextStyle(fontSize: 14 / scaleFactor)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (isLoading == false && couponList.isEmpty)
                Text(
                  'No Coupons Available',
                  style:
                      TextStyle(fontSize: 15 / scaleFactor, color: Colors.grey),
                ),
              isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: CircularProgressIndicator(
                            color: Color.fromRGBO(139, 0, 0, 1)),
                      ),
                    )
                  : Flexible(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          CouponModel data = couponList.elementAt(index);
                          return Visibility(
                            visible: data.coupon
                                .toLowerCase()
                                .contains(controller.text.toLowerCase()),
                            child: OfferTile(
                              data: data,
                              index: index,
                            ),
                          );
                        },
                        itemCount: couponList.length,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class OfferTile extends StatefulWidget {
  const OfferTile({
    super.key,
    required this.data,
    required this.index,
  });

  final CouponModel data;
  final int index;

  @override
  State<OfferTile> createState() => _OfferTileState();
}

class _OfferTileState extends State<OfferTile> {
  bool view = false;

  Widget greyText(String s) => Flexible(
        child: Text(
          '- $s',
          style: const TextStyle(
            color: Colors.blueGrey,
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white,
      child: Container(
        constraints: const BoxConstraints(minHeight: 80),
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Icon(Icons.discount, color: Colors.green),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      '₹${widget.data.amount} OFF',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const SizedBox(width: 36),
                  Flexible(
                    child: Text(
                      'For order worth ₹${widget.data.startPrice} or more',
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  const SizedBox(width: 36),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text(
                      widget.data.coupon,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => setState(() {
                      view = !view;
                    }),
                    child: const Text(
                      'T&C Apply',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            Visibility(
                visible: view,
                child: const Divider(
                  thickness: 1,
                )),
            Visibility(
              visible: view,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(50, 5, 10, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    greyText(
                      'Limited Time Offer *',
                    ),
                    greyText(
                      'Minimum order amount: ₹${widget.data.startPrice} or more',
                    ),
                    greyText('Only available in ${widget.data.city} city'),
                    greyText('Maximum claim: ${widget.data.maxCount} times'),
                    greyText('Other T&C may apply'),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}
