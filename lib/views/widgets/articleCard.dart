import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kofyimages/views/widgets/articleReader.dart';

class ArticleCard extends StatefulWidget {
  final String content;
  final String contentRendered;
  final String city;
  final String title;
  final String owner;
  final String thumbnailUrl;
  const ArticleCard({
    super.key,
    required this.owner,
    required this.city,
    required this.title,
    required this.content,
    required this.contentRendered,
    required this.thumbnailUrl
  });

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  String owner = "";
  String city = "";
  String title = "";
  String content_rendered = "";
  String contents = "";

  void initState() {
    main();
    cityName();
    titleName();
    contentName();
    contentRendered();
    super.initState();
  }

  void main() async {
    String utf8Encoded = widget.owner;
    var utf8Runes = utf8Encoded.runes.toList();
    owner = utf8.decode(utf8Runes);
  }

  void cityName() async {
    String utf8Encoded = widget.owner;
    var utf8Runes = utf8Encoded.runes.toList();
    city = utf8.decode(utf8Runes);
  }

  void titleName() async {
    String utf8Encoded = widget.title;
    var utf8Runes = utf8Encoded.runes.toList();
    title = utf8.decode(utf8Runes);
  }

  void contentRendered() async {
    String utf8Encoded = widget.contentRendered;
    var utf8Runes = utf8Encoded.runes.toList();
    content_rendered = utf8.decode(utf8Runes);
  }

  void contentName() async {
    String utf8Encoded = widget.content;
    var utf8Runes = utf8Encoded.runes.toList();
    contents = utf8.decode(utf8Runes);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleReader(
                       thumbnailUrl:widget.thumbnailUrl,
                       owner: owner,
                      content: contents,
                      contentRendered: content_rendered,
                      city: city,
                      title: title,
                    )));
      },
      child: Card(
        elevation: 4.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            decoration: BoxDecoration(color: Colors.black),
            child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: const EdgeInsets.only(right: 12.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(width: 1.0, color: Colors.white24))),
                  child: const Icon(Icons.article, color: Colors.white),
                ),
                title: Text(
                  "${widget.title}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Row(
                  children: <Widget>[
                    Icon(Icons.linear_scale, color: Colors.red),
                    Text("By ${widget.owner}",
                        style: TextStyle(color: Colors.white))
                  ],
                ),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Colors.white, size: 30.0))),
      ),
    );
  }
}