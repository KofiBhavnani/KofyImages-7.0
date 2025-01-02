import 'dart:convert' show utf8;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kofyimages/views/comments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

bool _isFullScreen = true;

class VideographyCard extends StatefulWidget {
  final String thumbnailUrl;
  final String caption;
  final String image;
  int view;
  int comment;
  final String id;

  VideographyCard(
      {super.key,
      required this.thumbnailUrl,
      required this.view,
      required this.caption,
      required this.id,
      required this.comment,
      required this.image});

  @override
  State<VideographyCard> createState() => _VideographyCardState();
}

class _VideographyCardState extends State<VideographyCard> {
  late YoutubePlayerController controller;
  String caption = "";
  String mainvideoId = "";

  @override
  void initState() {
    loadYoutubePlayer(widget.thumbnailUrl);
    main();
    super.initState();
  }

  void main() async {
    String utf8Encoded = widget.caption;
    var utf8Runes = utf8Encoded.runes.toList();
    caption = utf8.decode(utf8Runes);
  }

  // void getView() async {
  //   http.post(Uri.parse('${AppConstant.BASE_URL}/exhibitions/${widget.id}/'));
  // }

String formatViews(int viewCount) {
    if (viewCount >= 1000000) {
      double countInMillions = viewCount / 1000000.0;
      String formattedMillions = countInMillions.toString();
      int decimalIndex = formattedMillions.indexOf('.') + 1;

      if (decimalIndex != -1 && decimalIndex < formattedMillions.length - 1) {
        String decimalDigit =
            formattedMillions.substring(decimalIndex, decimalIndex + 1);
        return decimalDigit == '0'
            ? '${formattedMillions.substring(0, decimalIndex - 1)}M'
            : '${formattedMillions.substring(0, decimalIndex + 1)}M';
      } else {
        return '${formattedMillions}M';
      }
    } else if (viewCount >= 1000) {
      double countInThousands = viewCount / 1000.0;
      String formattedThousands = countInThousands.toString();
      int decimalIndex = formattedThousands.indexOf('.') + 1;

      if (decimalIndex != 0 && decimalIndex < formattedThousands.length) {
        String decimalDigit =
            formattedThousands.substring(decimalIndex, decimalIndex + 1);
        return decimalDigit == '0'
            ? '${formattedThousands.substring(0, decimalIndex - 1)}K'
            : '${formattedThousands.substring(0, decimalIndex + 1)}K';
      } else {
        return '${formattedThousands}K';
      }
    } else {
      return '$viewCount';
    }
  }

  loadYoutubePlayer(String url) {
    Uri uri = Uri.parse(url);
    String? videoId = uri.queryParameters['v'];

    controller = YoutubePlayerController(
      initialVideoId: '$videoId',
      flags: const YoutubePlayerFlags(
          autoPlay: true, disableDragSeek: true, forceHD: true),
    );
  }

  String view = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
          previewDialog(context);
          controller.play();
          // getView();
        },
        child: AnimatedContainer(
            // margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            duration: const Duration(milliseconds: 300),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.image,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: DefaultTextStyle(
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    child: GestureDetector(
                                      child: const AvatarGlow(
                                        glowColor: Colors.white,
                                        endRadius: 90.0,
                                        duration: Duration(milliseconds: 2000),
                                        repeat: true,
                                        showTwoGlows: true,
                                        repeatPauseDuration:
                                            Duration(milliseconds: 100),
                                        child: Material(
                                          // Replace this child with your own
                                          shape: CircleBorder(),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.red,
                                            radius: 40.0,
                                            child: Icon(
                                              Icons.play_arrow,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.landscapeRight,
                                          DeviceOrientation.landscapeLeft,
                                        ]);
                                        previewDialog(context);
                                        controller.play();
                                        // getView();
                                      },
                                    ),
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
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 5, top: 20, bottom: 5),
                        child: Container(
                          // color: Colors.red,
                          child: Row(
                            children: [
                              GestureDetector(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.message_rounded,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      'Comments ${widget.comment}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  await sharedPreferences.setString(
                                      "videoID", widget.id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Comments(id: widget.id)));
                                },
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              const Icon(
                                Icons.remove_red_eye,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                'Views ${formatViews(widget.view)}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Montserrat",
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        caption,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 18.0,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ],
                  ),
                ])));
  }

  Future<dynamic> previewDialog(BuildContext context) {
    return showDialog(
      barrierColor: Colors.black,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: OrientationBuilder(builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                _isFullScreen = true;
              } else {
                _isFullScreen = false;
              }
              return Stack(
                children: [
                  Container(
                    alignment: Alignment.center, // Center the child
                    child: Stack(
                      children: [
                        YoutubePlayer(
                          controller: controller,
                          showVideoProgressIndicator: true,
                          onEnded: (YoutubeMetaData metaData) {
                            Navigator.of(context, rootNavigator: true).pop();
                            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                          },
                        ),
                        // Back arrow button
                        Positioned(
                          top: 0,
                          left: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40,),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
          onHorizontalDragStart: (details) {
            //controller.pause();
            //controller.seekTo(Duration.zero);
            // SystemChrome.setPreferredOrientations([
            //   DeviceOrientation.portraitUp,
            // ]);
            //Navigator.of(context, rootNavigator: true).pop();
          },
        );
      },
    );
  }
}
