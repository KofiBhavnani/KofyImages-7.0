import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class LifeStyleCard extends StatefulWidget {

  final String thumbnailUrl;
  final String name;
  final String popUpUrl;
  const LifeStyleCard({super.key, required this.thumbnailUrl,
   required this.popUpUrl, required this.name});

  @override
  State<LifeStyleCard> createState() => _LifeStyleCardState();
}

class _LifeStyleCardState extends State<LifeStyleCard> {

    @override
  void initState() {
    main();
    super.initState();
  }
   String caption = "";

    void main() async {
    String utf8Encoded = widget.name;
    var utf8Runes = utf8Encoded.runes.toList();
    caption = utf8.decode(utf8Runes);
    print(caption);
  }


  bool closeBox = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
           padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(12.0),),
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
                        caption,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: "Montserrat",
                        ),
                      ),
                   const SizedBox(
                height: 12.0,
              ),
            ],
          ),
        ),
      );
  }

}
