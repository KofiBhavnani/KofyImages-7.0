import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/reviews.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class Destination {
  final String id;
  final String name;
  final String country;

  Destination(this.id, this.name, this.country);
}

class UpdateReview extends StatefulWidget {
  String review;
  int rate;
  final String city;
  final String id;
  final String reviewID;

  UpdateReview({
    super.key,
    required this.review,
    required this.city,
    required this.id,
    required this.reviewID,
    required this.rate,
  });

  @override
  State<UpdateReview> createState() => _UpdateReviewState();
}

class _UpdateReviewState extends State<UpdateReview> with OrientationMixin {
  TextEditingController reviewController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  List<Destination> _destinations = [];
  Destination? _selectedDestination;
  String? globalCityId;
  String? globalCityName;
  String? globalCountry;
  bool _isShow = false;

  bool showbtn = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    setState(() {
      lockPortrait();
      getCategory("${AppConstant.BASE_URL}/cities/");
      reviewController.text = widget.review;
      rateController.text = widget.rate.toString();

      scrollController.addListener(() {
        //scroll listener
        double showoffset =
            10; //Back to top botton will show on scroll offset 10.0
        if (scrollController.offset > showoffset) {
          showbtn = true;
        } else {
          showbtn = false;
        }
      });
    });
    super.initState();
  }

  Future<void> getCategory(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (mounted) {
        String jsonString = response.body;
        Map<String, dynamic> data = jsonDecode(jsonString);
        List<dynamic> results = data['results'];
        List<Destination> destinations = results.map((result) {
          String utf8EncodedCountry = result['country'];
          var utf8Runes = utf8EncodedCountry.runes.toList();
          String decodedCountry = utf8.decode(utf8Runes);

          return Destination(result['_id'], result['name'], decodedCountry);
        }).toList();

        setState(() {
          _isShow = true;
          _destinations = destinations;
        });
      }
    }
  }

  void _onDestinationChanged(Destination? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedDestination = newValue;
        globalCityId = _selectedDestination?.id;
        globalCityName = _selectedDestination?.name;
        globalCountry = _selectedDestination?.country;
      });
    }
  }
  bool isLoading = false;
  static showProgressDialog(BuildContext context, bool isLoading) {
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
                  "Updating User Review...",
                  style:  TextStyle(
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
        backgroundColor: Colors.white,
       appBar: const PreferredSize(
    preferredSize: Size.fromHeight(60),
    child: appBar(),
  ),
        drawer: const SideBar(),
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
        body: SingleChildScrollView(
          child: SizedBox(
            height: 1500,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        color: Colors.black),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: const Text(
                                    "Home  >",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeView()));
                                  },
                                ),
                                const Text(
                                  " Update Review",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            " Update Review",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ))),
                  const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Update your Review about a City",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Container(
                        height: 800,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                visible: _isShow,
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: DropdownButtonFormField<Destination>(
                                      focusColor: Colors.black,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      value: _selectedDestination,
                                      hint: const Text('Select a City'),
                                      onChanged: _onDestinationChanged,
                                      items: _destinations.map((destination) {
                                        return DropdownMenuItem(
                                          value: destination,
                                          child: Text("${destination.name}, ${destination.country}"),
                                        );
                                      }).toList(),
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: Colors.black,
                                      ),
                                      decoration: const InputDecoration(
                                          focusColor: Colors.black,
                                          labelText: "Select a City",
                                          labelStyle: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.travel_explore,
                                            color: Colors.black,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              borderSide: BorderSide(
                                                width: 2,
                                                color: Colors.black,
                                              )),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              borderSide: BorderSide(
                                                width: 2,
                                                color: Colors.black,
                                              ))),
                                    )),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  controller: rateController,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-5]')),
                                  ],
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.star,
                                      color: Colors.black,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.black,
                                        )),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    )),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Rate the City out of 5.0",
                                    hintStyle:
                                        const TextStyle(fontFamily: 'Montserrat'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  controller: reviewController,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  maxLines: 7,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Colors.black,
                                        )),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    )),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Leave a Review",
                                    hintStyle: const TextStyle(
                                        fontFamily: 'Montserrat'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 40, 10),
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Container(
                                      height: 60,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Update Review',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                      )),
                                ),
                                onTap: () async {
                                  if (globalCityId == null) {
                                    const snackdemo = SnackBar(
                                      content: Text(
                                        "Select a City to Review",
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
                                  } else if (rateController.text.isEmpty) {
                                    const snackdemo = SnackBar(
                                      content: Text(
                                        "Rate is Required!",
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
                                  } else if (reviewController.text.isEmpty) {
                                    const snackdemo = SnackBar(
                                      content: Text(
                                        "Review is Required!",
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
                                  } else {
                                    showProgressDialog(context, true);
                                    updateReview(reviewController.toString(),
                                        rateController.toString());
                                  }
                                },
                              ),
                              GestureDetector(
                                child: const Padding(
                                    padding: EdgeInsets.only(
                                        top: 20, left: 25, right: 25),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                    )),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      )),
                ]),
          ),
        ));
  }

  Future<void> updateReview(String review, String rate) async {
    try {
      SharedPreferences Authprefs = await SharedPreferences.getInstance();
      http.Response response = await http.put(
          Uri.parse(
              '${AppConstant.BASE_URL}/reviews/${widget.reviewID}/'),
          headers: {
            'Authorization': Authprefs.getString("token").toString(),
          },
          body: {
            "city": globalCityId.toString(),
            "rating": rateController.text,
            "review": reviewController.text,
          });
      print(Authprefs.getString("token").toString());
      // var pdfText= await json.decode(json.encode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const SubmitReview()));
          const snackdemo = SnackBar(
            content: Text(
              "Review Successfully Updated!",
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
          //errormsg = data['non_field_errors'].toString();
        });
      } else {
        var data = jsonDecode(response.body.toString());
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const SubmitReview()));
          final snackdemo = SnackBar(
            content: Text(
              data['message'],
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackdemo);
          //errormsg = data['non_field_errors'].toString();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
