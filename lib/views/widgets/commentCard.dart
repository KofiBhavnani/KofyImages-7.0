import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/views/comments.dart';
import 'package:kofyimages/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

import '../updateComment.dart';

class CommentCard extends StatefulWidget {
  String id;
  String owner;
  String exhibition;
  String content;
  String date;
  String ownerId;
  final String image;
  CommentCard(
      {super.key,
        required this.id,
        required this.owner,
        required this.exhibition,
        required this.content,
        required this.image,
        required this.date,
        required this.ownerId});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLess = true;
  String caption = "";
  String comment = "";
  String userId = "";
  final bool  _isAuth = false;

  @override
  void initState() {
    main();
    commentName();
    getUserId();
    super.initState();
  }

  void getUserId() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    String? id = Authprefs.getString("id");
    setState(() {
      userId = id!;
    });
  }

  void main() async {
    String utf8Encoded = widget.content;
    var utf8Runes = utf8Encoded.runes.toList();
    caption = utf8.decode(utf8Runes);
  }

  void commentName() async {
    String utf8Encoded = widget.exhibition;
    var utf8Runes = utf8Encoded.runes.toList();
    comment = utf8.decode(utf8Runes);
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(widget.date);
    final timeAgo = timeago.format(dateTime, locale: 'en_short');
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              width: 1, color: const Color.fromARGB(255, 242, 240, 240)),
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
                    widget.owner,
                    style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Montserrat"),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15, right: 10),
                    child: Text(
                      timeAgo,
                      style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 12,
                          color: Colors.black38,
                          fontWeight: FontWeight.w500),
                    ))
              ],
            ),
            const SizedBox(height: 5.0),
            widget.image == ""
                ? Container()
                : Center(
              child: CachedNetworkImage(
                imageUrl: widget.image,
                imageBuilder: (context, imageProvider) => Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      //image size fill
                        image: imageProvider,
                        fit: BoxFit.contain),
                  ),
                ),
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
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
            Row(
              children: [
                const SizedBox(
                    width: 60,
                    child: Divider(
                      color: Colors.black,
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    child: SizedBox(
                      width: 270,
                      child: Text(
                        comment,
                        style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                userId == widget.ownerId ?
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
                        child:  Row(
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
                                builder: (context) => UpdateComment(
                                    id: widget.id,
                                    content: caption,
                                    exhibition: comment)));
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
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ],
        ),
      ),
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
                  "Are you sure you want to DELETE this Comment?",
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
                        deleteComment();
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

  Future<void> deleteComment() async {
    try {
      SharedPreferences Authprefs = await SharedPreferences.getInstance();
      http.Response response = await http.delete(
          Uri.parse('${AppConstant.BASE_URL}/comments/${widget.id}/'),
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
              MaterialPageRoute(builder: (context) => Comments(id: widget.id)));
          const snackdemo = SnackBar(
            content: Text(
              "Successfully Deleted Comment! ",
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

  static showProgressDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
              backgroundColor: Colors.white,
              children: <Widget>[
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
                      "Deleting Comment...",
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
}
