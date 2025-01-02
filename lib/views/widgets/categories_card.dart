import 'dart:convert';
import 'dart:developer';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MainCategoriesCard extends StatefulWidget {
  Function onPressed;
  final String id;
  final String country;
  final String thumbnailUrl;
  final String name;
  MainCategoriesCard(
      {super.key, required this.name,
      required this.id,
      required this.country,
      required this.thumbnailUrl,
      required this.onPressed,});

  @override
  State<MainCategoriesCard> createState() => _MainCategoriesCardState();
}

class _MainCategoriesCardState extends State<MainCategoriesCard> {

  bool _isLiked = false;
  int _views =0;
  String newCountry = "";
   String country = "";


  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;

      if(_isLiked){
        _views++;
      }else{
        _views--;
      }
    });
  }

    @override
  void initState() {
   main();
   newMain();
    super.initState();
  }

    void main() async {
    String utf8Encoded = widget.name;
    var utf8Runes = utf8Encoded.runes.toList();
    newCountry = utf8.decode(utf8Runes);
    log(newCountry);
  }

     void newMain() async {
    String utf8Encoded = widget.country;
    var utf8Runes = utf8Encoded.runes.toList();
    country = utf8.decode(utf8Runes);
    log(country);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      child: GestureDetector(
        onTap: () {
          widget.onPressed();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
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
                    borderRadius: BorderRadius.circular(10),
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
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 19,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            child: AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  RotateAnimatedText('Explore ${widget.name} →'),
                                ]),
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
              errorWidget: (context, url, error) => Image.network("https://edu.ceskatelevize.cz/storage/video/placeholder.jpg"),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Text("$newCountry , $country",
                  style: const TextStyle(
                              fontSize: 19,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
