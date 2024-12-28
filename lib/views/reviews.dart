import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/reviewCard.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Destination {
  final String id;
  final String name;
  final String country;

  Destination(this.id, this.name, this.country);
}

class SubmitReview extends StatefulWidget {
  const SubmitReview({super.key});

  @override
  State<SubmitReview> createState() => _SubmitReviewState();
}

class _SubmitReviewState extends State<SubmitReview> with OrientationMixin{
  TextEditingController reviewController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  List<Destination> _destinations = [];
  Destination? _selectedDestination;
  String? globalCityId;
  String? globalCityName;
  bool _isLoading = true;
  int currentPage = 1;

  List<Map<String, dynamic>> dataList = [];

  void _onDestinationChanged(Destination? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedDestination = newValue;
        globalCityId = _selectedDestination?.id;
        globalCityName = _selectedDestination?.name;
      });
    }
  }

  void clearpref() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    await Authprefs.remove("name");
    await Authprefs.remove("last");
    await Authprefs.remove("email");
    await Authprefs.remove("token");
    await Authprefs.remove("id");
  }


  bool showbtn = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    lockPortrait();
    getCategory("${AppConstant.BASE_URL}/cities/");
    getReviews("${AppConstant.BASE_URL}/reviews/");
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
    super.initState();
  }
   bool _isShow = false;

  Map<String, dynamic> categoryMap = {};
  List<dynamic> cateList = [];
  String _nextUrl = "null";
  String _prevUrl = "null";

  Future getReviews(url) async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(url),
        headers: {'Authorization': Authprefs.getString("token").toString()});
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        categoryMap = jsonDecode(response.body);
        cateList = categoryMap['results'];
        if (categoryMap['next'] is String) {
          _nextUrl = categoryMap['next'];
        } else {
          setState(() {
            _nextUrl = "null";
          });
        }
        if (categoryMap['previous'] is String) {
          _prevUrl = categoryMap['previous'];
        } else {
          _prevUrl = "null";
        }
      }
      print(cateList);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getCategory(String url) async {

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
    
      if (mounted) {
        setState(() {
          String jsonString = response.body;
          Map<String, dynamic> data = jsonDecode(jsonString);
          List<dynamic> results = data['results'];
          List<Destination> destinations = results.map((result) {
          String utf8EncodedCountry = result['country'];
          var utf8Runes = utf8EncodedCountry.runes.toList();
          String decodedCountry = utf8.decode(utf8Runes);

          return Destination(result['_id'], result['name'], decodedCountry);
        }).toList();
          
  
          _isShow = true;
          _destinations = destinations;
        });
      }
    }
  }




  @override
  final spinkit = const SpinKitFadingCircle(
    color: Colors.black,
    size: 40.0,
  );

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
                  "Submitting Review...",
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


  showSessionDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              //color: Colors.red,
              borderRadius: BorderRadius.circular(12.0),
            ),
            width: 100,
            height: 120,
            child: Column(
              children: [
                const Text(
                  "Session Expired",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Your session has expired. You must sign in again.",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  child: const Text(
                    "Dismiss",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    clearpref();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                )
              ],
            ),
          ),
        );
      },
    );
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
        controller: scrollController,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            height: 80.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.0), color: Colors.black),
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
                                    builder: (context) => const HomeView()));
                          },
                        ),
                        const Text(
                          " Reviews",
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
              padding: EdgeInsets.only(top: 15),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Review",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ))),
          const Align(
              alignment: Alignment.center,
              child: Text(
                "Write a Review about the Cities",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              )),
          Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Container(
                height: 500,
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
                            FilteringTextInputFormatter.allow(RegExp(r'[0-5]')),
                          ],
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.star,
                              color: Colors.black,
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
                            hintStyle: const TextStyle(fontFamily: 'Montserrat'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
                            hintStyle:
                                const TextStyle(fontFamily: 'Montserrat'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 40, 10),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                              height: 60,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Submit Review',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              )),
                        ),
                        onTap: () async {
                          SharedPreferences Authprefs =
                              await SharedPreferences.getInstance();
                          var tokenId = Authprefs.getString("token");

                          if (tokenId == null) {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginView()));
                            const snackdemo = SnackBar(
                              content: Text(
                                "User LogIn Required!",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            );
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackdemo);
                          } else if (globalCityId == null) {
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
                            // ignore: use_build_context_synchronously
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
                            // ignore: use_build_context_synchronously
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
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackdemo);
                          } else {
                            // ignore: use_build_context_synchronously
                            showProgressDialog(context, true);
                            submitReview(rateController.toString(),
                                reviewController.toString());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(
              width: 350,
              child: Divider(
                color: Colors.black,
              )),
          const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 20),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "User Reviews",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ))),
          Column(children: [
            _isLoading
                ? Center(
                    child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 90),
                            child: Row(
                              children: [
                                spinkit,
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  'Loading Reviews...',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ))))
                : cateList.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'No Reviews Submitted!',
                            style: TextStyle(
                                color: Color.fromARGB(255, 227, 35, 21),
                                fontSize: 20,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: cateList.length,
                        itemBuilder: (BuildContext context, int index) {
                          try {
                            return ReviewCard(
                                id: cateList[index]['_id'],
                                city_id: globalCityId.toString(),
                                review: cateList[index]['review'],
                                review_id: cateList[index]['_id'],
                                fname: cateList[index]['user']['first_name'],
                                lname: cateList[index]['user']['last_name'],
                                city: cateList[index]['city'],
                                liked: cateList[index]['liked'],
                                likes: cateList[index]['likes_count'],
                                date: cateList[index]['created_at'],
                                rate: cateList[index]['rating']);
                          } catch (e) {
                            return Text("$e");
                          }
                        }),
            Padding(
              padding: const EdgeInsets.only(left: 100, bottom: 40),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(
                                        color: Colors.black, width: 2)))),
                    onPressed: () {
                      print(_prevUrl);
                      if (_prevUrl.contains('null')) {
                      } else if (_prevUrl.contains('https')) {
                        setState(() {
                          scrollController.animateTo(
                              //go to top of scroll
                              0, //scroll offset to go
                              duration: const Duration(
                                  milliseconds: 500), //duration of scroll
                              curve: Curves.fastOutSlowIn //scroll type
                              );
                          getReviews(_prevUrl);
                          _isLoading = true;
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(
                                        color: Colors.black, width: 2)))),
                    onPressed: () {
                      print(_nextUrl);
                      if (_nextUrl.contains('null')) {
                      } else if (_nextUrl.contains('https')) {
                        setState(() {
                          scrollController.animateTo(
                              //go to top of scroll
                              0, //scroll offset to go
                              duration: const Duration(
                                  milliseconds: 500), //duration of scroll
                              curve: Curves.fastOutSlowIn //scroll type
                              );
                          getReviews(_nextUrl);
                          _isLoading = true;
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
            )
          ]),
        ]),
      ),
    );
  }

  Future<void> submitReview(String rate, String review) async {
    try {
      SharedPreferences Authprefs = await SharedPreferences.getInstance();
      http.Response response = await http.post(
          Uri.parse('${AppConstant.BASE_URL}/reviews/'),
          headers: {
            'Authorization': Authprefs.getString("token").toString(),
          },
          body: {
            "city": globalCityId.toString(),
            "rating": rateController.text,
            "review": reviewController.text,
          });

      if (response.statusCode == 400) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          showProgressDialog(context, false);
          final snackdemo = SnackBar(
            content: Text(
              "User already posted a review about $globalCityName",
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
      } else if (response.statusCode == 401) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          showProgressDialog(context, false);
          showSessionDialog(context);
        });
      } else {
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SubmitReview()));
          const snackdemo = SnackBar(
            content: Text(
              "Review Successfully Submitted! ",
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
        });
        reviewController.clear();
        rateController.clear();
      }
    } catch (e) {
      //print(e.toString());
    }
  }
}
