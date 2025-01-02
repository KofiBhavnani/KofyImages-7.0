import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoOfTheWeekCard extends StatefulWidget {
  String id;
  String name;
  String caption;
  String image;
  String imageThumbnail;
  String city;
  String contentRendered;

  PhotoOfTheWeekCard(
      {super.key,
      required this.id,
      required this.image,
      required this.name,
      required this.imageThumbnail,
      required this.city,
      required this.caption,
      required this.contentRendered});

  @override
  State<PhotoOfTheWeekCard> createState() => _EventCardState();
}

class _EventCardState extends State<PhotoOfTheWeekCard> with OrientationMixin {
  String photoName = "";
  String photoCity = "";
  String photoCaption = "";
  String photoContentRendered = "";
  final bool _isAuth = false;
  String userId = "";

  @override
  void initState() {
    super.initState();

    name();
    caption();
    lockPortrait();
    location();
    content();
  }

  void name() async {
    String utf8Encoded = widget.name;
    var utf8Runes = utf8Encoded.runes.toList();
    photoName = utf8.decode(utf8Runes);
  }

  void caption() async {
    String utf8Encoded = widget.caption;
    var utf8Runes = utf8Encoded.runes.toList();
    photoCaption = utf8.decode(utf8Runes);
  }

  void location() async {
    String utf8Encoded = widget.city;
    var utf8Runes = utf8Encoded.runes.toList();
    photoCity = utf8.decode(utf8Runes);
  }

  void content() async {
    String utf8Encoded = widget.contentRendered;
    var utf8Runes = utf8Encoded.runes.toList();
    photoContentRendered = utf8.decode(utf8Runes);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              width: 350,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.imageThumbnail),
                    //fit: BoxFit.fill
                    fit: BoxFit.contain
                    ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    photoCaption,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    photoCity,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width *
                            0.85), // Set the maximum width
                    child: Html(data: photoContentRendered, style: {
                      'body': Style(
                          fontFamily: "Montserrat",
                          fontSize: FontSize(14),
                          lineHeight: LineHeight.rem(1.3)),
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
