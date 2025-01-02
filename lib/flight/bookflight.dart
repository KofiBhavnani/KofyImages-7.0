import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/flight/createdflight.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Passenger {
  final String passenger;
  final String type;

  Passenger({required this.passenger, required this.type});
}

class PassengerDetails {
  final String id;
  String title;
  String given_name;
  String family_name;
  String gender;
  String born_on;
  String email;
  String phone_number;

  PassengerDetails({
    required this.id,
    required this.title,
    required this.given_name,
    required this.family_name,
    required this.gender,
    required this.born_on,
    required this.email,
    required this.phone_number,
  });

  factory PassengerDetails.fromJson(Map<String, dynamic> json) {
    return PassengerDetails(
      phone_number: json['phone_number'],
      born_on: json['born_on'],
      email: json['email'],
      title: json['title'],
      gender: json['gender'],
      family_name: json['family_name'],
      given_name: json['given_name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone_number'] = phone_number;
    data['born_on'] = born_on;
    data['email'] = email;
    data['title'] = title;
    data['gender'] = gender;
    data['family_name'] = family_name;
    data['given_name'] = given_name;
    data['id'] = id;
    return data;
  }
}

class BookFlight extends StatefulWidget {
  String image;
  BookFlight({Key? key, required this.image}) : super(key: key);

  @override
  State<BookFlight> createState() => _BookFlightState();
}

class _BookFlightState extends State<BookFlight> with OrientationMixin{
  List<PassengerDetails> passengerDetails = [];

  Future<List<Passenger>> getPassengerData() async {
    SharedPreferences flightDetails = await SharedPreferences.getInstance();
    String? passengerData = flightDetails.getString('passenger_ids_and_type');
    String? offer = flightDetails.getString('offer_id');

    List<Passenger> passengers = [];
    if (passengerData != null) {
      List<dynamic> decodedData = jsonDecode(passengerData);
      for (var data in decodedData) {
        Map<String, dynamic> passengerMap = data;
        passengers.add(
          Passenger(
            passenger: passengerMap['passenger'],
            type: passengerMap['type'],
          ),
        );
      }
    }

    print(offer);
    print(passengerData);

    return passengers;
  }

  static showConfirmDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
            Center(
              child: Column(children: const [
                SpinKitFadingCircle(
                  color: Colors.black,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Booking Flight...",
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
  void initState() {
    super.initState();
    lockPortrait();
    getPassengerData().then((passengers) {
      setState(() {
        for (Passenger passenger in passengers) {
          passengerDetails.add(
            PassengerDetails(
              id: passenger.passenger,
              title: 'mr',
              given_name: '',
              family_name: '',
              gender: 'm',
              born_on: '',
              email: '',
              phone_number: '',
            ),
          );
        }
      });
    });
  }

  Future<void> postRequest() async {
    SharedPreferences flightDetails = await SharedPreferences.getInstance();
// Convert passengerDetails to a List<Map<String, dynamic>> for easy serialization
    List<Map<String, dynamic>> passengers = passengerDetails
        .map((passenger) => {
              'id': passenger.id,
              'title': passenger.title,
              'given_name': passenger.given_name,
              'family_name': passenger.family_name,
              'gender': passenger.gender,
              'born_on': passenger.born_on,
              'email': passenger.email,
              'phone_number': passenger.phone_number,
            })
        .toList();

// Create the request body object
    var requestBody = {
      "offer_id": flightDetails.getString("offer_id"),
      "passengers": passengers, // Add the passengers list to the request body
    };

// Serialize the request body to JSON
    String jsonString = jsonEncode(requestBody);
    log(jsonString);
    http.Response response = await http.post(
        Uri.parse('${AppConstant.FLIGHT_BASE_URL}/book_flight/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonString);

    if (response.body.toString().contains('errors')) {
      final responseData = jsonDecode(response.body);
      final flightData = responseData['errors'];
      showConfirmDialog(context, false);
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: const [
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                      Text(
                        'Validation Error',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: "Montserrat",
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                content: SizedBox(
                  height: null ,
                  width: 300.0,// Change as per your requirement
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: flightData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          flightData[index]['title'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(flightData[index]['message']),
                      );
                    },
                  ),
                ));
          });
    }else if (!response.body.toString().contains('errors')){
      final responseData = jsonDecode(response.body);
       final orderData = responseData['data']['id'];
       final bookingData = responseData['data']['booking_reference'];
        log(bookingData.toString(), name:'Booking' );
       showConfirmDialog(context, false);
                           Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrderedFlight(
                                    image: widget.image,
                                    order: orderData,
                                    booking: bookingData)));
                                        const snackdemo = SnackBar(
                              content: Text(
                                "Booking Successful",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
            backgroundColor: Colors.green,
          );
                            ScaffoldMessenger.of(context).showSnackBar(snackdemo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
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
                            'Book Flight',
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
                "Basic necessary information about the passengers ",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
                textAlign: TextAlign.center,
              )),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: passengerDetails.length,
            itemBuilder: (context, index) {
              return PassengerForm(
                passengerDetails: passengerDetails[index],
                onSave: () {
                  setState(() {
                    passengerDetails[index] = passengerDetails[index];
                  });
                },
              );
            },
          ),
          GestureDetector(
            onTap: () {
              showConfirmDialog(context, true);
              postRequest();
            },
            child: Container(
              height: 60.0,
              width: 350.0,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: const Center(
                child: Text(
                  "Book Flight",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          )
        ])));
  }
}

class PassengerForm extends StatefulWidget {
  final PassengerDetails passengerDetails;
  final Function onSave;

  const PassengerForm({super.key, 
    required this.passengerDetails,
    required this.onSave,
  });

  @override
  _PassengerFormState createState() => _PassengerFormState();
}

class _PassengerFormState extends State<PassengerForm> {
  bool isExpanded = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController dateController = TextEditingController();

  void toggleFormVisibility() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    dateController.text = "yyyy-mm-dd";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      elevation: 1,
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      shadowColor: Colors.grey,
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text(
              'Passenger Info',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            subtitle: Text(widget.passengerDetails.id),
            trailing: IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.app_registration_rounded
                    : Icons.arrow_drop_down_circle,
                color: Colors.black,
                size: 25,
              ),
              onPressed: toggleFormVisibility,
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      focusColor: Colors.black,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                          focusColor: Colors.black,
                          labelText: "Title *",
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          prefixIcon: Icon(
                            Icons.title,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                              ))),
                      value: widget.passengerDetails.title,
                      onChanged: (value) {
                        setState(() {
                          widget.passengerDetails.title = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'mr',
                          child: Text('Mr.'),
                        ),
                        DropdownMenuItem(
                          value: 'mrs',
                          child: Text('Mrs.'),
                        ),
                        DropdownMenuItem(
                          value: 'ms',
                          child: Text('Ms.'),
                        ),
                        DropdownMenuItem(
                          value: 'miss',
                          child: Text('Miss'),
                        ),
                        DropdownMenuItem(value: 'dr', 
                        child: Text('Dr.'))
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      initialValue: widget.passengerDetails.given_name,
                      onChanged: (value) {
                        setState(() {
                          widget.passengerDetails.given_name = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'First Name *',
                        labelStyle: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      initialValue: widget.passengerDetails.family_name,
                      onChanged: (value) {
                        setState(() {
                          widget.passengerDetails.family_name = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Surname Name *',
                        labelStyle: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
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
                      validator: (value) {
                        if (value == '') {
                          return 'Please enter a last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<String>(
                      focusColor: Colors.black,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                          focusColor: Colors.black,
                          labelText: "Gender *",
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          prefixIcon: Icon(
                            Icons.supervised_user_circle_rounded,
                            color: Colors.black,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                              ))),
                      value: widget.passengerDetails.gender,
                      onChanged: (value) {
                        setState(() {
                          widget.passengerDetails.gender = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'm',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'f',
                          child: Text('Female'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a gender';
                        }
                        return null;
                      },
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
                        controller: dateController,
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
                          labelText: "Date of Birth",
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1800),
                            lastDate: DateTime.now(),
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
                              dateController.text = formattedDate;
                              widget.passengerDetails.born_on = formattedDate;
                            });
                          } else {
                            print("Date is not selected");
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      initialValue: widget.passengerDetails.email,
                      onChanged: (value) {
                        setState(() {
                          widget.passengerDetails.email = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Email *',
                        labelStyle: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      initialValue: widget.passengerDetails.phone_number,
                      onChanged: (value) {
                        setState(() {
                          widget.passengerDetails.phone_number = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "+1 617 7562626",
                        hintStyle: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          color: Colors.black26,
                        ),
                        labelText: 'Phone *',
                        labelStyle: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        prefixIcon: const Icon(
                          Icons.phone,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
