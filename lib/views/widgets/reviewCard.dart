import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/reviews.dart';
import 'package:kofyimages/views/updateReview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;


class ReviewCard extends StatefulWidget {
String id;
String review;
String city;
String fname;
String lname;
String city_id;
String review_id;
int rate;
String date;
int likes;
 bool liked;

   ReviewCard({
    super.key, 
    required this.id, 
    required this.review, 
    required this.fname, 
    required this.lname, 
    required this.city, 
    required this.rate, 
    required this.city_id, 
    required this. review_id, 
    required this.likes,
    required this.liked,
    required this.date});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {

   bool isLess = true;
   String caption = "";
    String city = "";
   bool isLiked = false;
  bool _likesNumber = false;
  bool  _isAuth = false;

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



  Future<void> likePicture() async {
    try {
      SharedPreferences Authprefs = await SharedPreferences.getInstance();
      http.Response response = await http.post(
        Uri.parse('${AppConstant.BASE_URL}/reviews/${widget.review_id}/likes/'),
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
              MaterialPageRoute(builder: (context) => const SubmitReview()));
          const snackdemo = SnackBar(
            content: Text(
              "Successfully Liked Review",
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
              MaterialPageRoute(builder: (context) => const SubmitReview()));
          const snackdemo = SnackBar(
            content: Text(
              "Successfully Unliked Review",
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
              child: Column(children: const [
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


   @override
  void initState() {
    main();
    cityMain();
    isLiked = widget.liked;
    checkforDetails();
    super.initState();
  }

  void main() async {
    String utf8Encoded = widget.review;
    var utf8Runes = utf8Encoded.runes.toList();
    caption = utf8.decode(utf8Runes);
  }


    void cityMain() async {
    String utf8Encoded = widget.city;
    var utf8Runes = utf8Encoded.runes.toList();
    city = utf8.decode(utf8Runes);
  }



 Future<void> deleteReview() async {
    try {
      SharedPreferences Authprefs = await SharedPreferences.getInstance();
      http.Response response = await http.delete(
        Uri.parse('${AppConstant.BASE_URL}/reviews/${widget.review_id}/'),
       headers: {
          'Authorization': Authprefs.getString("token").toString(),
        }

      );
      print(response.body);
      print(response.statusCode);
       var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SubmitReview()));
          const snackdemo = SnackBar(
            content: Text(
              "Successfully Deleted Review! ",
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
      } else if (response.statusCode == 401 && data['detail'] == "Authentication credentials were not provided.") {
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
                  "Are you sure you want to DELETE this Review?",
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
                      deleteReview();
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
              child: Column(children: const [
                SpinKitFadingCircle(
                  color: Colors.black,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Deleting Review...",
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

        if (widget.likes == 0) {
      setState(() {
        _likesNumber = false;
      });
    } else if (widget.likes != 0) {
      _likesNumber = true;
    }

final dateTime = DateTime.parse(widget.date);
final timeAgo = timeago.format(dateTime, locale: 'en_short');
            return  Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                 border: Border.all(width: 1, color: const Color.fromARGB(255, 242, 240, 240)),
              ),
              padding: const EdgeInsets.only(
                top: 2.0,
                bottom: 10.0,
                left: 16.0,
                right: 0.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50.0,
                        width: 50.0,
                        margin: const EdgeInsets.only(right: 16.0),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('assets/black.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(44.0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${widget.fname} ${widget.lname}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat"
                          ),
                        ),
                      ),

                      GestureDetector(
                        child: Container(
                                  width: null,
                                  decoration: const BoxDecoration(
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

                      

                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      SmoothStarRating(
                        starCount: 5,
                        rating: widget.rate.toDouble(),
                        size: 28.0,
                        color: Colors.orange,
                        borderColor: Colors.orange,
                      ),
                      const SizedBox(width: 18),
                      Text(
                        "( ${widget.rate}.0 )",
                        style: const TextStyle(fontSize: 18.0,
                         fontFamily: "Montserrat",),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
          GestureDetector(
            child: isLess
                ? Text(
                    caption,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                       fontFamily: "Montserrat",
                       fontWeight: FontWeight.w400,
                       
                    ),
                  )
                : Text(
                    caption,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
          ),

                  Row(children: [
                                    const SizedBox(
              width: 60,
              child: Divider(
                color: Colors.black,
              )),
  
                  Padding(
              padding: const EdgeInsets.only(top: 5, left:15),
                  child: Text(
                    city,
                    style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  )),
                                    Padding(
              padding: const EdgeInsets.only(top: 5, left:15),
                  child: Text(
                    timeAgo,
                    style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 12,
                        color: Colors.black38,
                        fontWeight: FontWeight.w500),
                  ))
                  ],),
                  const SizedBox(height: 15,),

                Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                        child: Container(
                          width: 120,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
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
                                    builder: (context) => UpdateReview(
                                          review: caption,
                                          city:  widget.city,
                                          id: widget.city_id, 
                                          reviewID: widget.review_id,
                                          rate: widget.rate
                                        )));

                        }),
                  ),
                  const SizedBox(
                    width: 5,
                  ),

                   Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      child: Container(
                        width: 120,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.red),
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                  ),
                  const SizedBox(width:10,)
                ],
              ),
                ],
              ),
              
            ),
          );
  }





}