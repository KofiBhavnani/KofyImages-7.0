import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kofyimages/orientation_mixin.dart';

class FoodCard extends StatefulWidget {
  final String name;
  final String thumbnailUrl;
  final String popUpUrl;
  const FoodCard(
      {super.key, required this.name,
      required this.thumbnailUrl,
      required this.popUpUrl});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard>  with OrientationMixin {
  double indexOfOpacity = 0.10;
  final double _width = 350;
  final double _height = 350;
  String overText = "";
   String newText = "";

  void text() async {
    String? utf8Encoded = widget.name;
    var utf8Runes = utf8Encoded.runes.toList();
    newText = utf8.decode(utf8Runes);
    print(newText);
  }

    @override
  void initState() {
    lockPortrait();
    text();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: const EdgeInsets.only(left: 20, right: 20,bottom: 15),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.thumbnailUrl,
                imageBuilder: (context, imageProvider) => Container(
                  width: 3878,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                          const Color.fromARGB(124, 0, 0, 0).withOpacity(indexOfOpacity),
                          BlendMode.multiply,
                        ),
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
                            overText,
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
              const SizedBox(
                height: 10.0,
              ),
              Text(
               newText,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: "Montserrat",
                  fontSize: 20.0,
                ),
              )
            ],
          ),
        ),
      );
  }

}
