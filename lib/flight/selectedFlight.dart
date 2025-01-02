
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kofyimages/flight/flightpayment.dart';
import 'package:kofyimages/orientation_mixin.dart';

class SelectedFlight extends StatefulWidget {
  String image;
  String airport;
  String cabin;
  String price;
  String currency;
  DateTime dep_date;
  String logo;
  String dep_time;
  String origin_code;
  String arr_time;
  String destination_code;
  String duration;
  String origin_airport;
  String token;

  SelectedFlight(
      {super.key,
      required this.image,
      required this.airport,
      required this.cabin,
      required this.price,
      required this.currency,
      required this.dep_date,
      required this.logo,
      required this.dep_time,
      required this.origin_code,
      required this.arr_time,
      required this.destination_code,
      required this.duration,
      required this.origin_airport,
      required this.token,});

  @override
  State<SelectedFlight> createState() => _SelectedFlightState();
}

class _SelectedFlightState extends State<SelectedFlight> with OrientationMixin{

 String? paymentIntentId;

   @override
  void initState() {
    super.initState();
    lockPortrait();
  }

  @override
  Widget build(BuildContext context) {
    String depDay = DateFormat('dd').format(widget.dep_date);
    String depMonth = DateFormat('MMM').format(widget.dep_date);

    return Scaffold(
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
                              'Selected Flight Offer',
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
              height: 20,
            ),
                      const Align(
                alignment: Alignment.center,
                child: Text(
                  "You have selected an Offer",
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
                      Padding(
                padding: const EdgeInsets.only(bottom: 25, left: 15, right: 15),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(width: 1.5, color: Colors.black38),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  width: 150,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(19),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(widget.cabin.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black))
                                    ],
                                  ),
                                )),
                                                          Padding(
                                padding: const EdgeInsets.only(left: 70),
                                child: GestureDetector(
                                  child: SizedBox(
                                    width: 130,
                                    height: 40,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.verified,
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Selected",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                             Padding(
                            padding: const EdgeInsets.only(right: 200, top: 8),
                            child: Text("${widget.currency} ${widget.price}",
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black))),
                                                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 110,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(0),
                                border:
                                    Border.all(width: 1, color: Colors.black12),
                              ),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(top: 30),
                                            child: Text(depDay,
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black38))),
                                                   Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0, top: 0),
                                            child: Text(depMonth.toUpperCase(),
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black))),
      
                                      ],
                                    ),
                                         Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: SizedBox(
                                          height: 40.0,
                                          width: 40.0,
                                          child: SvgPicture.network(
                                            widget.logo,
                                          ),
                                        )),
                                            Column(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(top: 30),
                                            child: Text(
                                                widget.dep_time
                                                    .toString()
                                                    .substring(0, 5),
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black))),
                                                                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0, top: 0),
                                            child: Text(widget.origin_code,
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black))),
                                      ],
                                    ),
                                                                      Column(
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.only(top: 29),
                                            child: Text("NON-STOP",
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green))),
                                        const SizedBox(
                                            width: 100,
                                            child: Divider(
                                              thickness: 3,
                                              color: Colors.black,
                                            )),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0, top: 0),
                                            child: Text(widget.duration,
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black))),
                                      ],
                                    ),
                                                                      Column(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(top: 30),
                                            child: Text(
                                                widget.arr_time
                                                    .toString()
                                                    .substring(0, 5),
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black))),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0, top: 0),
                                            child: Text(widget.destination_code,
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black))),
                                      ],
                                    ),
                                  ]),
                            )),
                                               Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: GestureDetector(
                              child: Container(
                                width: 250,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: 2),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: const [
                                        Text("Proceed to Payment ",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  FlightPayment(
                                        id: widget.token,
                                        image: widget.image,
                                        price: widget.price,
                                        currency: widget.currency
                                      ),
                                    ),
                                  );
                              },
                            )),
                      ],
                    ))),
                              const SizedBox(height: 30),
            const Align(
                alignment: Alignment.center,
                child: Text(
                  "Want to change offer?",
                  style: TextStyle(
                      color: Colors.black45,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(
              height: 10,
            ),
                      Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  child: Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        Text("Back to Flight Offers",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.white))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )),
          ],
        ),
      ),
    );
  }
}