
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kofyimages/flight/widget/returnflightCard.dart';
import 'package:kofyimages/orientation_mixin.dart';

class ReturnFlights extends StatefulWidget {
 List<dynamic>responseData;
 String image;
 String next;

ReturnFlights({
  super.key, 
  required this.responseData, 
  required this. image, 
  required this.next, 
 
});

  @override
  State<ReturnFlights> createState() => _ReturnFlightsState();
}

class _ReturnFlightsState extends State<ReturnFlights> with OrientationMixin{
  List<dynamic>dataList = [];
  String _nextUrl = "null";
  String _prevUrl = "null";

    bool showbtn = false;

  ScrollController scrollController = ScrollController();


    @override
  void initState() {
    lockPortrait();
    print(dataList);
    dataList = widget.responseData;
    _nextUrl = widget.next;

      scrollController.addListener(() {
      //scroll listener
      double showoffset = 10; //Back to top botton will show on scroll offset 10.0
      if (scrollController.offset > showoffset) {
        showbtn = true;
      } else {
        showbtn = false;
      }
    });

    super.initState();
  }


  void getFlight(url) async {
   showProgressDialog(context, true);
   final response = await http.get(Uri.parse(url));
    print(url);
    if (response.statusCode == 200) {
      showProgressDialog(context, false);
       setState(() {
       final responseData = jsonDecode(response.body);
        dataList = responseData['results']['flight_offers'];

        if (responseData['next'] is String) {
          setState(() {
             _nextUrl = responseData['next'];
            print(_nextUrl); 
          });

          } else {
            setState(() {
              _nextUrl = "null";
            });
          }
          if (responseData['previous'] is String) {
            setState(() {
               _prevUrl = responseData['previous'];
            });
           
          } else {
            setState(() {
              _prevUrl = "null";
            });
            
          }
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
      ScaffoldMessenger.of(context).showSnackBar(snackdemo);
    }
  }

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
                SpinKitDoubleBounce(
                  color: Colors.black,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Loading Flights..",
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

    log(widget.responseData.toString());
    return Scaffold(
      
        floatingActionButton: AnimatedOpacity(
          duration: const Duration(milliseconds: 1000), //show/hide animation
          opacity: showbtn ? 1.0 : 0.0, //set obacity to 1 on visible, or hide
          child: FloatingActionButton(
            onPressed: () {
              scrollController.animateTo(
                  //go to top of scroll
                  0, //scroll offset to go
                  duration: const Duration(milliseconds: 500), //duration of scroll
                  curve: Curves.fastOutSlowIn //scroll type
                  );
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.arrow_upward),
          )),
      body:SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.image
                ),
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
                padding: const EdgeInsets.only(left: 16, right: 16, ),
                height: 80,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available Flights',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                         Row(
                          children: [
                            const Icon(
                              Icons.trip_origin,
                              color: Colors.white,
                              size: 15,
                            ),
                          const SizedBox(
                          height: 20,
                        ),
                            Text(
                             " ${widget.responseData[0]['origin']['airport_name']}",
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 15,
                            ),
                            Text(
                               " ${widget.responseData[0]['destination']['airport_name']}",
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  const Text("Select an Offer",
                      style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(
                    width: 100,
                  ),
                   GestureDetector(
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.arrow_back_sharp,
                            color: Colors.white,
                          ),
                          Text(" Back",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
        ),
                    Column(
              children: [
            Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: ListView.builder(
                          scrollDirection: Axis.vertical,
                             shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount:dataList.length,
                   itemBuilder: (BuildContext context, int index) =>ReturnFlightListCard(
                    offerId:'${dataList[index]['offer_id']}',
                    airline:'${dataList[index]['airline']}',
                    logo:'${dataList[index]['airline_logo']}',
                    dep_date: DateTime.parse(dataList[index]['departure_date']),
                    dep_time:'${widget.responseData[index]['departure_time']}',
                    arr_date:DateTime.parse(dataList[index]['arrival_date']),
                    arr_time:'${dataList[index]['arrival_time']}',
                    duration:'${dataList[index]['duration']}',
                    price:'${dataList[index]['price']}',
                    currency:'${dataList[index]['currency']}',
                    cabin:'${dataList[index]['cabin_class']}',
                    origin:'${dataList[index]['origin']['city_name']}',
                    origin_code:'${dataList[index]['origin']['iata_code']}',
                    origin_airport:'${dataList[index]['origin']['airport_name']}',
                    destination:'${dataList[index]['destination']['city_name']}',
                    destination_code:'${dataList[index]['destination']['iata_code']}',
                    destination_airport:'${dataList[index]['destination']['airport_name']}',
                    aircraft:'${dataList[index]['aircraft_name']}',
                    image : widget.image,
                    return_dep_date: DateTime.parse(dataList[index]['return_departure_date']),
                    return_dep_time:'${widget.responseData[index]['return_departure_time']}',
                    return_arr_date:DateTime.parse(dataList[index]['return_arrival_date']),
                    return_arr_time:'${dataList[index]['return_arrival_time']}',
                    return_duration:'${dataList[index]['return_duration']}',

                  )),
            
                      ),
            ]),
                      Padding(
                      padding: const EdgeInsets.only(left: 100, bottom: 50),
                      child: Row(
                        children: [
                          TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(15)),
                                overlayColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.black26),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(Colors.black),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: const BorderSide(
                                            color: Colors.black, width: 2)))),
                            onPressed: () {
                                print(_prevUrl);
                              if (_prevUrl == null) {
                              } else if (_prevUrl.contains('https')) {
                                setState(() {
                                  scrollController.animateTo(
                                      //go to top of scroll
                                      0, //scroll offset to go
                                      duration: const Duration(
                                          milliseconds: 500), //duration of scroll
                                      curve: Curves.fastOutSlowIn //scroll type
                                      );
                                  getFlight(_prevUrl);
                                });
                              }
                            },
                            child: const Text(
                              'Previous',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(15)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(Colors.black),
                                overlayColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.black26),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: const BorderSide(
                                            color: Colors.black, width: 2)))),
                            onPressed: () {
                              print(_nextUrl);
                             if (_nextUrl == null) {
                              } else if (_nextUrl.contains('https')) {
                                setState(() {
                                  scrollController.animateTo(
                                      //go to top of scroll
                                      0, //scroll offset to go
                                      duration: const Duration(
                                          milliseconds: 500), //duration of scroll
                                      curve: Curves.fastOutSlowIn //scroll type
                                      );
                                  getFlight(_nextUrl);
                                });
                              }
                            },
                            child: const Text(
                              "Next",
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w700),
                            ),
                            
                          ),
                        ],
                      ),
                    )]),
        )

      
    );
  }
}