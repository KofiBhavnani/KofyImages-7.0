import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kofyimages/flight/bookflight.dart';
import 'package:kofyimages/orientation_mixin.dart';

class PaymentSuccess extends StatefulWidget {
  String image;
  Map<String, dynamic> response;

  PaymentSuccess({super.key, required this.image, required this.response});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> with OrientationMixin{
  @override
  void initState() {
    lockPortrait();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String createdString = widget.response['created_at'];
    DateTime createddateTime = DateTime.parse(createdString);
    String createdformattedDate =
        DateFormat('EEE, MMM d, y hh:mm a').format(createddateTime);

    String confirmString = widget.response['confirmed_at'];
    DateTime confirmdateTime = DateTime.parse(confirmString);
    String confirmformattedDate =
        DateFormat('EEE, MMM d, y hh:mm a').format(confirmdateTime);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.image),
                    fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    stops: const [0.0, 0.4],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Payment Details',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Align(
                alignment: Alignment.center,
                child: Text(
                  "Successful Payment Details ",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(
              height: 25,
            ),
            Card(
              margin: const EdgeInsets.only(left: 15, right: 15),
              elevation: 2,
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              shadowColor: Colors.grey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading:
                        const Icon(Icons.verified, color: Colors.green, size: 45),
                    title: const Text(
                      "Payment Status",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    subtitle: Text('${widget.response['status']}'.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.green,
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.verified, color: Colors.green, size: 45),
                    title: const Text(
                      "Net Amount ",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      '${widget.response['net_amount']}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.verified, color: Colors.green, size: 45),
                    title: const Text(
                      "Fees Amount",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      '${widget.response['fees_amount']}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.verified, color: Colors.green, size: 45),
                    title: const Text(
                      "Total Amount Paid",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      '${widget.response['amount']}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.verified, color: Colors.green, size: 45),
                    title: const Text(
                      "Currency",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      '${widget.response['currency']}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.verified, color: Colors.green, size: 45),
                    title: const Text(
                      "Card Type",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      '${widget.response['card_network']}'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.verified, color: Colors.green, size: 45),
                    title: const Text(
                      "Date of Payment",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    subtitle: Text(createdformattedDate.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.verified, color: Colors.green, size: 45),
                    title: const Text(
                      "Date of Confirmation",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    subtitle: Text(confirmformattedDate.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: Container(
                      width: 270,
                      height: 60,
                      decoration: BoxDecoration( 
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [

                          Text("Book Flight",
                              style: TextStyle(
                                  fontSize: 23.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                                                            SizedBox(
                            width: 15,
                          ),
                                                            Icon(
                            Icons.arrow_forward_ios,
                            size: 30,
                            color: Colors.white,
                          ),

                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BookFlight(image: widget.image)));
                    },
                  )),
            ),
           
          ],
        ),
      ),
    );
  }
}
