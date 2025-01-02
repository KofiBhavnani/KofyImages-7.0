import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SubCategoriesCard extends StatefulWidget {
  Function onPressed;
  String name;
  String country;
  String thumbnailUrl;
  SubCategoriesCard({
    super.key,
    required this.name,
    required this.country,
    required this.thumbnailUrl,
    required this.onPressed,
  });
  @override
  State<SubCategoriesCard> createState() => _SubCategoriesCardState();
}

class _SubCategoriesCardState extends State<SubCategoriesCard> {
  String country = "";
  @override
  void initState() {
    main();
    super.initState();
  }

  void main() async {
    String utf8Encoded = widget.country;
    var utf8Runes = utf8Encoded.runes.toList();
    country = utf8.decode(utf8Runes);
    print(country);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      child: GestureDetector(
        onTap: () {
          widget.onPressed();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.thumbnailUrl,
              imageBuilder: (context, imageProvider) => Container(
                width: 1878,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                      //image size fill
                      image: imageProvider,
                      fit: BoxFit.cover),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          widget.name.capitalize(),
                          style: const TextStyle(
                            fontSize: 19,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              placeholder: (context, url) => Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return split(" ").map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      } else {
        return "";
      }
    }).join(" ");
  }
}
