import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kofyimages/views/widgets/appBar.dart';

class ArticleReader extends StatefulWidget {
  final String content;
  final String contentRendered;
  final String city;
  final String title;
  final String owner;
  final String thumbnailUrl;
  const ArticleReader(
      {super.key,
      required this.owner,
      required this.city,
      required this.title,
      required this.content,
      required this.contentRendered,
      required this.thumbnailUrl});

  @override
  State<ArticleReader> createState() => _ArticleReaderState();
}

class _ArticleReaderState extends State<ArticleReader> {
  @override
  Widget build(BuildContext context) {
    print(widget.title);
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: appBar(),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Stack(
            children: [
              Container(
              
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.thumbnailUrl),
                      fit: BoxFit.cover),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent
                      ],
                      stops: const [0.0, 0.9],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      height: 130,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                //color: Colors.red,
                                width: 300,
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'By ${widget.owner}',
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 30.0,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
        height: null,
        width: 500,
        child: Html(
          data: """
        ${widget.contentRendered}
        """,
          style: {
            "p": Style(
                fontSize: FontSize(18.0),
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.left,
                color: const Color.fromARGB(255, 52, 52, 52),
                lineHeight: LineHeight.rem(1.3)),
            "h1": Style(
              fontSize: FontSize(25.0),
            ),
          },
        ))
        ])
        )
        );
  }
}