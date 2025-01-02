import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/flight/returnselectedFlight.dart';
import 'package:kofyimages/flight/selectedFlight.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReturnFlightListCard extends StatefulWidget {
  String offerId;
  String airline;
  String logo;
  DateTime dep_date;
  String dep_time;
  DateTime arr_date;
  String arr_time;
  String duration;
  String price;
  String currency;
  String cabin;
  String origin;
  String origin_code;
  String origin_airport;
  String destination;
  String destination_code;
  String destination_airport;
  String aircraft;
  String image;
   DateTime return_dep_date;
   String return_dep_time;
   DateTime return_arr_date;
   String return_arr_time;
   String return_duration;

  ReturnFlightListCard({
    super.key,
    required this.offerId,
    required this.airline,
    required this.logo,
    required this.dep_date,
    required this.dep_time,
    required this.arr_date,
    required this.arr_time,
    required this.duration,
    required this.price,
    required this.currency,
    required this.cabin,
    required this.origin,
    required this.origin_code,
    required this.origin_airport,
    required this.destination,
    required this.destination_code,
    required this.destination_airport,
    required this.aircraft,
    required this.image, 
    required this.return_dep_date, 
    required this.return_dep_time, 
    required this.return_arr_date, 
    required this.return_arr_time, 
    required this.return_duration,
  });

  @override
  State<ReturnFlightListCard> createState() => _ReturnFlightListCardState();
}

class _ReturnFlightListCardState extends State<ReturnFlightListCard> {
  final bool _isLoading = true;

  static showProgressDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
            Center(
              child: Column(children: const [
                SpinKitWave(
                  color: Colors.black,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Selecting Flight Offer...",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 5,
                ),
              ]),
            )
          ]);
        },
      );
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String depDay = DateFormat('dd').format(widget.dep_date);
    String depMonth = DateFormat('MMM').format(widget.dep_date);



    String returnDepDay = DateFormat('dd').format(widget.return_dep_date);
    String  returnDepMonth = DateFormat('MMM').format(widget.return_dep_date);

    return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 380,
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
                        padding: const EdgeInsets.only(left: 100),
                        child: GestureDetector(
                          child: Container(
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 2),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("SELECT",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white))
                              ],
                            ),
                          ),
                          onTap: () async {
                            showProgressDialog(context, true);
                            final response = await http.post(
                                Uri.parse(
                                    "${AppConstant.FLIGHT_BASE_URL}/payment_intent/"),
                                body: {"offer_id": widget.offerId});

                            if (response.statusCode == 200) {
                              final responseData = jsonDecode(response.body);
                              log(response.body);
                              var clientID =
                                  responseData['data']['client_token'];
                              SharedPreferences flightDetails =
                                  await SharedPreferences.getInstance();
                              await flightDetails.setString(
                                  "offer_id", widget.offerId);
                              SharedPreferences Payment =
                                  await SharedPreferences.getInstance();
                              await Payment.setString("client",
                                  responseData['data']['client_token']);
                              await Payment.setString("pit",
                                  responseData['data']['payment_intent_id']);
                              setState(() {
                                showProgressDialog(context, false);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReturnSelectedFlight(
                                      image: widget.image,
                                      airport: widget.destination_airport,
                                      cabin: widget.cabin,
                                      price: widget.price,
                                      currency: widget.currency,
                                      dep_date: widget.dep_date,
                                      logo: widget.logo,
                                      dep_time: widget.dep_time,
                                      origin_code: widget.origin_code,
                                      arr_time: widget.arr_time,
                                      destination_code: widget.destination_code,
                                      duration: widget.duration,
                                      origin_airport: widget.origin_airport,
                                      token: clientID,
                                          return_dep_date:widget.return_dep_date,
                                           return_dep_time:widget.return_dep_time,
                                            return_arr_date:widget. return_arr_date,
                                            return_arr_time:widget. return_arr_time,
                                            return_duration:widget.return_duration

                                    ),
                                  ),
                                );
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Flight Offer Selected Succesfully",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.green,
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackdemo);
                              });
                            } else {
                              showProgressDialog(context, false);
                              const snackdemo = SnackBar(
                                content: Text(
                                  "Error. Kindly try again!",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackdemo);
                            }
                          },
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
                        border: Border.all(width: 1, color: Colors.black12),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    padding: const EdgeInsets.only(right: 0, top: 0),
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
                                    padding: const EdgeInsets.only(right: 0, top: 0),
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
                                    padding: const EdgeInsets.only(right: 0, top: 0),
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
                                    padding: const EdgeInsets.only(right: 0, top: 0),
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
/////////////////////////////////////////////////////////////////////////////////////////////////////////
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(width: 1, color: Colors.black12),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Text(returnDepDay,
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black38))),
                                Padding(
                                    padding: const EdgeInsets.only(right: 0, top: 0),
                                    child: Text(returnDepMonth.toUpperCase(),
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
                                        widget.return_dep_time
                                            .toString()
                                            .substring(0, 5),
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black))),
                                Padding(
                                    padding: const EdgeInsets.only(right: 0, top: 0),
                                    child: Text(widget.destination_code,
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
                                    padding: const EdgeInsets.only(right: 0, top: 0),
                                    child: Text(widget.return_duration,
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
                                        widget.return_arr_time
                                            .toString()
                                            .substring(0, 5),
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black))),
                                Padding(
                                    padding: const EdgeInsets.only(right: 0, top: 0),
                                    child: Text(widget.origin_code,
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black))),
                              ],
                            ),
                          ]),
                    )),

                Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.airline,
                      style: const TextStyle(
                          color: Colors.black45,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    )),
              ],
            )));
  }
}
