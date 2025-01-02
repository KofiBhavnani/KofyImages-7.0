import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/flight/flights.dart';
import 'package:kofyimages/flight/returnflights.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchFlight extends StatefulWidget {
  String id;
  String name;
  String country;
  String thumbnailUrl;
  String code;

  SearchFlight(
      {super.key,
      required this.id,
      required this.country,
      required this.name,
      required this.thumbnailUrl,
      required this.code});

  @override
  State<SearchFlight> createState() => _SearchFlightState();
}

class _SearchFlightState extends State<SearchFlight> with OrientationMixin{



  Future<void> oneWayFlight(url) async {
    showProgressDialog(context, true);
    final response = await http.get(Uri.parse(url));
    print(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      final flightData = responseData['results']['flight_offers'];
      final passengerData = responseData['results']['passenger_ids_and_type'];
      SharedPreferences flightDetails = await SharedPreferences.getInstance();
      await flightDetails.setString(
          "passenger_ids_and_type", jsonEncode(passengerData));
      print(passengerData);
      setState(() {
        showProgressDialog(context, false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Flights(
                responseData: flightData,
                image: widget.thumbnailUrl,
                next: responseData['next']),
          ),
        );
      });
    } else {
      showProgressDialog(context, false);
      const snackdemo = SnackBar(
        content: Text(
          "Error. Kindly try again.",
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


    Future<void> returnFlight(url) async {
    showProgressDialog(context, true);
    final response = await http.get(Uri.parse(url));
    print(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      final flightData = responseData['results']['flight_offers'];
      final passengerData = responseData['results']['passenger_ids_and_type'];
      SharedPreferences flightDetails = await SharedPreferences.getInstance();
      await flightDetails.setString(
          "passenger_ids_and_type", jsonEncode(passengerData));
      print(passengerData);
      setState(() {
        showProgressDialog(context, false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReturnFlights(
                responseData: flightData,
                image: widget.thumbnailUrl,
                next: responseData['next']),
          ),
        );
      });
    } else {
      showProgressDialog(context, false);
      const snackdemo = SnackBar(
        content: Text(
          "Error. Kindly try again.",
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

  final GlobalKey<ScaffoldState> _messageKey = GlobalKey<ScaffoldState>();
  String dropdownValue = "";
  List<Map<String, dynamic>> items = [];
  final TextEditingController _destination = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _returnController = TextEditingController();
  final DateTime _departureDate = DateTime.now();
  final DateTime _returneDate = DateTime.now();
  String _cabinClass = '';
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  bool isReturn = false;
  bool isOneWay = true;

    String country = "";
   void main() async {
    String utf8Encoded = widget.country;
    var utf8Runes = utf8Encoded.runes.toList();
    country = utf8.decode(utf8Runes);
    print(country);
  }

  @override
  void initState() {
    super.initState();
    lockPortrait();
    loadAsset();
    main();
    print(widget.code);
    _destination.text = '${widget.name},$country';
    _dateController.text = "yyyy-mm-dd";
    _returnController.text = "yyyy-mm-dd";
  }

  int adult = 1;
  int child = 0;
  int infant = 0;

  final List<String> _cabinClasses = [
    '',
    'first',
    'business',
    'premium economy',
    'economy'
  ];

  void showErrorAlert() {
    QuickAlert.show(
        context: context,
        barrierDismissible: true,
        animType: QuickAlertAnimType.slideInDown,
        type: QuickAlertType.error,
        title: "Field Error",
        text: 'All fields are Required',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.black);
  }

  Future<void> loadAsset() async {
    final data = await rootBundle.loadString('assets/airport.csv');
    final List<List<dynamic>> csvTable = const CsvToListConverter().convert(data);
    items = csvTable
        .map((row) => {
              'code': row[0],
              'name': row[1],
            })
        .toList();
    setState(() {
      dropdownValue = items[0]['code'];
    });
  }

  static showProgressDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
            Center(
              child: Column(children: const [
                SpinKitSquareCircle(
                  color: Colors.black,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Searching...",
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
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.thumbnailUrl,
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
                padding: const EdgeInsets.only(left: 16, right: 16),
                height: 70,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.name}, $country',
                          style: const TextStyle(
                              fontSize: 24.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 15,
                            ),
                            Text(
                              " Destination",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white38),
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
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        sliver: SliverToBoxAdapter(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(right: 50, bottom: 10),
                        child: Text(
                          "Select Journey Type:",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        )),
                    GestureDetector(
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isReturn ? Colors.white : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 2),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.airplane_ticket,
                                color: isReturn ? Colors.black : Colors.white),
                            Text(" One Way Jouney",
                                style: isReturn
                                    ? const TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)
                                    : const TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white))
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isReturn = false;
                          isOneWay = true;
                        });
                      },
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          color: isReturn ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.airplane_ticket,
                                color: isReturn ? Colors.white : Colors.black),
                            Text(" Return Journey",
                                style: isReturn
                                    ? const TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)
                                    : const TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isReturn = true;
                          isOneWay = false;
                        });
                      },
                    ),
                  ],
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
      ),
      SliverPadding(
        padding: const EdgeInsets.only(left: 30),
        sliver: SliverToBoxAdapter(
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                const Text("Let's book your flight",
                    style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w700,
                        color: Colors.black)),
                const SizedBox(
                  width: 5,
                ),
                SvgPicture.asset(
                  'assets/plane.svg',
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                const Padding(
                    padding: EdgeInsets.only(right: 290, bottom: 10),
                    child: Text(
                      "Origin *",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    )),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: SearchChoices.single(
                    displayClearIcon: false,
                    hint: "Select Origin",
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.black,
                    ),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    items: items.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                          value: item['code'],
                          child: Text(
                            item['name'],
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ));
                    }).toList(),
                    value: dropdownValue,
                    searchInputDecoration: const InputDecoration(
                      labelText: "Search for Origin",
                      labelStyle: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.black,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.black,
                          )),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        print(newValue);
                      });
                    },
                    isExpanded: true,
                    dialogBox: false,
                    menuConstraints: BoxConstraints.tight(const Size.fromHeight(600)),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  readOnly: true,
                  controller: _destination,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Destination *',
                    labelStyle: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    prefixIcon: const Icon(
                      Icons.location_pin,
                      color: Colors.black,
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.black,
                        )),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.black,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    controller: _dateController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                        color: Colors.black,
                      )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.black,
                          )),
                      labelText: "Departure date",
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2010),
                        lastDate: DateTime(5090),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Colors.black, // <-- SEE HERE
                                onPrimary: Colors.white, // <-- SEE HERE
                                onSurface: Colors.black, // <-- SEE HERE
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2022-07-04
                        //You can format date as per your need

                        setState(() {
                          _dateController.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    }),
                Visibility(
                    visible: isReturn,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextField(
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            controller: _returnController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                width: 2,
                                color: Colors.black,
                              )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.black,
                                  )),
                              labelText: "Return date",
                              labelStyle: TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedreturnDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2010),
                                lastDate: DateTime(5090),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.black, // <-- SEE HERE
                                        onPrimary: Colors.white, // <-- SEE HERE
                                        onSurface: Colors.black, // <-- SEE HERE
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedreturnDate != null) {
                                print(pickedreturnDate);
                                String formattedreturnDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(pickedreturnDate);
                                print(
                                    formattedreturnDate); //formatted date output using intl package =>  2022-07-04
                                //You can format date as per your need
                                setState(() {
                                  _returnController.text = formattedreturnDate;
                                });
                              } else {
                                print("Date is not selected");
                              }
                            }))),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  focusColor: Colors.black,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  value: _cabinClass,
                  items: _cabinClasses
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (val) {
                    _cabinClass = val as String;
                    print(val);
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down_circle,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                      focusColor: Colors.black,
                      labelText: "Carbin Class *",
                      labelStyle: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      prefixIcon: Icon(
                        Icons.hotel_class,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.black,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.black,
                          ))),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 300,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Passengers *',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          const Text('Adult',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                          const SizedBox(width: 72.0),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  adult++;
                                });
                              },
                              icon: const Icon(
                                Icons.add_circle_rounded,
                                color: Colors.white,
                              )),
                          const SizedBox(width: 16.0),
                          Text(adult.toString(),
                              style: const TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(width: 16.0),
                          IconButton(
                              onPressed: () {
                                if (adult != 1) {
                                  setState(() {
                                    adult--;
                                  });
                                } else {
                                  const snackdemo = SnackBar(
                                    content: Text(
                                      "Number of adults cannot be less 1",
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
                              icon: const Icon(
                                Icons.remove_circle_rounded,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          const Text('Child',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                          const SizedBox(width: 78.0),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  child++;
                                });
                              },
                              icon: const Icon(
                                Icons.add_circle_rounded,
                                color: Colors.white,
                              )),
                          const SizedBox(width: 16.0),
                          Text(child.toString(),
                              style: const TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(width: 16.0),
                          IconButton(
                              onPressed: () {
                                if (child != 0) {
                                  setState(() {
                                    child--;
                                  });
                                } else {
                                  const snackdemo = SnackBar(
                                    content: Text(
                                      "Number of children cannot be less 0",
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
                              icon: const Icon(
                                Icons.remove_circle_rounded,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          const Text('Infant',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                          const SizedBox(width: 72.0),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  infant++;
                                });
                              },
                              icon: const Icon(
                                Icons.add_circle_rounded,
                                color: Colors.white,
                              )),
                          const SizedBox(width: 16.0),
                          Text(infant.toString(),
                              style: const TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(width: 14.0),
                          IconButton(
                              onPressed: () {
                                if (infant != 0) {
                                  setState(() {
                                    infant--;
                                  });
                                } else {
                                  const snackdemo = SnackBar(
                                    content: Text(
                                      "Number of infants cannot be less 0",
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
                              icon: const Icon(
                                Icons.remove_circle_rounded,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Visibility(
                    visible: isOneWay,
                    child: GestureDetector(
                      onTap: () {
                        if (dropdownValue == "NIL") {
                          const snackdemo = SnackBar(
                            content: Text(
                              "Origin cannot be empty",
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
                        } else if (_dateController.text == "yyyy-mm-dd") {
                          const snackdemo = SnackBar(
                            content: Text(
                              "Depature Date cannot be empty",
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
                        } else if (widget.code == "null") {
                          const snackdemo = SnackBar(
                            content: Text(
                              "No Destination Code Found.",
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
                        } else {
                          oneWayFlight(
                              "${AppConstant.FLIGHT_BASE_URL}/flights/?origin=$dropdownValue&destination=${widget.code}&departure_date=${_dateController.text}&adult=$adult&journey_type=oneway&cabin_class=$_cabinClass&infant=$infant&child=$child");
                        }
                      },
                      child: Container(
                        height: 60.0,
                        width: 350.0,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: const Center(
                          child: Text(
                            "Find available flights",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )),
                Visibility(
                    visible: isReturn,
                    child: GestureDetector(
                      onTap: () {
                        if (dropdownValue == "NIL") {
                          const snackdemo = SnackBar(
                            content: Text(
                              "Origin cannot be empty",
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
                        } else if (_dateController.text == "yyyy-mm-dd") {
                          const snackdemo = SnackBar(
                            content: Text(
                              "Depature Date cannot be empty",
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
                        }else if (_returnController.text == "yyyy-mm-dd"){
                            const snackdemo = SnackBar(
                            content: Text(
                              "Return Date cannot be empty",
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
                        } else if (widget.code == "null") {
                          const snackdemo = SnackBar(
                            content: Text(
                              "No Destination Code Found.",
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
                        } else {
                          returnFlight(
                              "${AppConstant.FLIGHT_BASE_URL}/flights/?origin=$dropdownValue&destination=${widget.code}&departure_date=${_dateController.text}&return_date=${_returnController.text}&adult=$adult&journey_type=return&cabin_class=$_cabinClass&infant=$infant&child=$child");
                        }
                      },
                      child: Container(
                        height: 60.0,
                        width: 350.0,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: const Center(
                          child: Text(
                            "Find available flights",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 40,
                )
              ]))),
    ]));
  }
}
