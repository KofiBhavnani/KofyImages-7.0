import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/events/events.dart';
import 'package:kofyimages/events/update_event.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EventCard extends StatefulWidget {
  String id;
  String image;
  String city;
  String owner;
  String country;
  String name;
  String location;
  String date;
  String time;
  String description;
  int likes;
  bool liked;
  String ownerId;

  EventCard({
    super.key,
    required this.id,
    required this.image,
    required this.city,
    required this.owner,
    required this.country,
    required this.name,
    required this.location,
    required this.date,
    required this.time,
    required this.likes,
    required this.liked,
    required this.description,
    required this.ownerId
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> with OrientationMixin {
  String eventName = "";
  String eventCity = "";
  String eventCountry = "";
  String eventLoc = "";
  String eventdesc = "";
  bool isLiked = false;
  bool _likesNumber = false;
  bool  _isAuth = false;
  String userId = "";

  @override
  void initState() {
    super.initState();

    name();
    city();
    description();
    country();
    lockPortrait();
    location();
    checkforDetails();
    getUserId();
    isLiked = widget.liked;
  }

  void getUserId() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    String? id = Authprefs.getString("id");
    setState(() {
      userId = id!;
    });
  }

  void checkforDetails() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    var tokenId = Authprefs.getString("token");
    print(tokenId);

    if (tokenId == null) {
      print("i am null");
      setState(() {
        _isAuth = false;
      });
    } else {
      print("i am not null");
      setState(() {
        _isAuth = true;
      });
    }
  }

  void name() async {
    String utf8Encoded = widget.name;
    var utf8Runes = utf8Encoded.runes.toList();
    eventName = utf8.decode(utf8Runes);
  }

  void city() async {
    String utf8Encoded = widget.city;
    var utf8Runes = utf8Encoded.runes.toList();
    eventCity = utf8.decode(utf8Runes);
  }

  void country() async {
    String utf8Encoded = widget.country;
    var utf8Runes = utf8Encoded.runes.toList();
    eventCountry = utf8.decode(utf8Runes);
  }

  void location() async {
    String utf8Encoded = widget.location;
    var utf8Runes = utf8Encoded.runes.toList();
    eventLoc = utf8.decode(utf8Runes);
  }

  void description() async {
    String utf8Encoded = widget.description;
    var utf8Runes = utf8Encoded.runes.toList();
    eventdesc = utf8.decode(utf8Runes);
  }

  showSessionDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
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
                  "Login Required",
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
                  "Please Login",
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        child: Container(
                          child: const Center(
                            child: Text(
                              "Dismiss",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                      child: const SizedBox(
                        width: 100,
                        height: 40,
                        child: Center(
                          child: Text(
                            "LogIn",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  showDescDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    eventName,
                    style: const TextStyle(
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
                    "Event Description",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        color:Colors.black38
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(
                    thickness: 1,
                  ),

                  Text(
                    eventdesc,
                    style: const TextStyle(
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


                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showDeleteDialog(BuildContext context) {
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
            height: 130,
            child: Column(
              children: [
                const Text(
                  "Delete",
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
                  "Are you sure you want to DELETE this Event?",
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        child: Container(
                          child: const Center(
                            child: Text(
                              "Dismiss",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                      child: const SizedBox(
                        width: 100,
                        height: 40,
                        child: Center(
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        deleteEvent();
                        showProgressDialog(context, true);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> likePicture() async {
    try {
      SharedPreferences Authprefs = await SharedPreferences.getInstance();
      http.Response response = await http.post(
        Uri.parse('${AppConstant.BASE_URL}/events/${widget.id}/likes/'),
        headers: {
          'Authorization': Authprefs.getString("token").toString(),
        },
      );
      log(response.body);
      print(response.statusCode);
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 201 && data["liked"] == true) {
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UpComingEvents()));
          const snackdemo = SnackBar(
            content: Text(
              "Successfully Liked Event",
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
      } else if (response.statusCode == 201 && data["liked"] == false) {
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UpComingEvents()));
          const snackdemo = SnackBar(
            content: Text(
              "Successfully Unliked Event",
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
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static showLikesDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
            Center(
              child: Column(children: [
                SpinKitPumpingHeart(
                  color: Colors.red,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10,
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
    if (widget.likes == 0) {
      setState(() {
        _likesNumber = false;
      });
    } else if (widget.likes != 0) {
      _likesNumber = true;
    }

    final timeString = widget.time.substring(0, 6);
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          //color: Colors.blue,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.image),
                      fit: BoxFit.cover),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent
                      ],
                      stops: const [0.0, 0.4],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            child: Container(
                                width: null,
                                decoration: const BoxDecoration(
                                  //color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 40,
                                          width: null,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(left: 5),
                                                child: Icon(
                                                  isLiked
                                                      ? Icons.favorite
                                                      : Icons
                                                      .favorite_border_outlined,
                                                  color: Colors.red,
                                                  size: 30,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Visibility(
                                                visible: _likesNumber,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    widget.likes.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 19.0,
                                                        fontFamily:
                                                        "Montserrat",
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.w600),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                )),
                            onTap: () {

                              if(_isAuth== false){
                                showSessionDialog(context);
                              }else{

                                likePicture();
                                showLikesDialog(context, true);

                              }




                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 180),
                            child: Text(eventName,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  const Icon(Icons.person, color: Colors.black, size: 20),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    widget.owner,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  const Icon(Icons.location_city,
                      color: Colors.black, size: 20),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "$eventCity, $eventCountry",
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  const Icon(Icons.location_on, color: Colors.black, size: 20),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    eventLoc,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.black,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    widget.date,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.watch,
                    color: Colors.black,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    timeString,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      child: Container(
                        width: 90,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.remove_red_eye, color: Colors.white),
                            SizedBox(width: 2,),
                            Text("View",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      onTap: () {
                        showDescDialog(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  userId == widget.ownerId ?
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                        child: Container(
                          width: 90,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, color: Colors.black),
                              Text("Edit",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateEvent(
                                      id: widget.id,
                                      name: eventName,
                                      city: eventCity,
                                      country: eventCountry,
                                      location: eventLoc,
                                      date: widget.date,
                                      time: widget.time,
                                      description: eventdesc
                                  )));
                        }),
                  ) : const SizedBox(),
                  const SizedBox(
                    width: 5,
                  ),
                  userId == widget.ownerId ?
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      child: Container(
                        width: 90,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.red),
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            Text("Delete",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      onTap: () {
                        showDeleteDialog(context);
                      },
                    ),
                  ) : const SizedBox(),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteEvent() async {
    try {
      SharedPreferences Authprefs = await SharedPreferences.getInstance();
      http.Response response = await http.delete(
          Uri.parse('${AppConstant.BASE_URL}/events/${widget.id}/'),
          headers: {
            'Authorization': Authprefs.getString("token").toString(),
          });
      print(response.body);
      print(response.statusCode);
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UpComingEvents()));
          const snackdemo = SnackBar(
            content: Text(
              "Successfully Deleted Event! ",
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
      } else if (response.statusCode == 401 &&
          data['detail'] == "Authentication credentials were not provided.") {
        setState(() {
          showProgressDialog(context, false);
          showLoginDialog(context);
        });
      } else if (response.statusCode == 401 &&
          data['detail'] == "Invalid Authentication token") {
        setState(() {
          showProgressDialog(context, false);
          showLoginDialog(context);
        });
      } else {
        setState(() {
          showProgressDialog(context, false);
          final snackdemo = SnackBar(
            content: Text(
              "${data['message']}",
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
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  showLoginDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
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
                    "LogIn",
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

  void clearpref() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    await Authprefs.remove("name");
    await Authprefs.remove("last");
    await Authprefs.remove("email");
    await Authprefs.remove("token");
    await Authprefs.remove("id");
  }

  static showProgressDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
            Center(
              child: Column(children: [
                SpinKitFadingCircle(
                  color: Colors.black,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Deleting Event...",
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
}
