import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kofyimages/views/widgets/footer.dart';
import 'package:kofyimages/views/widgets/videographyCard.dart';
import 'widgets/sidebar.dart';

// ignore: must_be_immutable
class Food extends StatefulWidget {
  String? id;
  String? name;
  String? city;
  Food({super.key, this.id, this.name, this.city});

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> with OrientationMixin {
  double _isheight = 100;
  bool _isLoading = true;
  bool showbtn = false;
  ScrollController scrollController = ScrollController();

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
      getCategory(
          "${AppConstant.BASE_URL}/cities/${widget.id}/images/${widget.name}/");
    });
  }

  TextEditingController searchController = TextEditingController();
  String _nextUrl = "null";
  String _prevUrl = "null";

  @override
  void initState() {
    lockPortrait();
    main();
    getCategory(
        "${AppConstant.BASE_URL}/cities/${widget.id}/images/${widget.name}/");

    scrollController.addListener(() {
      //scroll listener
      double showoffset =
      10; //Back to top botton will show on scroll offset 10.0

      if (scrollController.offset > showoffset) {
        showbtn = true;
        setState(() {
          //update state
        });
      } else {
        showbtn = false;
        setState(() {
          //update state
        });
      }
    });
    super.initState();
  }

  String country = "";

  void main() async {
    String? utf8Encoded = widget.city;
    var utf8Runes = utf8Encoded?.runes.toList();
    country = utf8.decode(utf8Runes!);
    print(country);
  }

  Map<String, dynamic> categoryMap = {};
  List<dynamic> cateList = [];

  Future getCategory(String url) async {
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isheight = 600;
            categoryMap = jsonDecode(response.body);
            cateList = categoryMap['results'];
            if (categoryMap['next'] is String) {
              _nextUrl = categoryMap['next'];
            } else {
              setState(() {
                _nextUrl = "null";
              });
            }
            if (categoryMap['previous'] is String) {
              _prevUrl = categoryMap['previous'];
            } else {
              _prevUrl = "null";
            }
          });
        }
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  final spinkit = const SpinKitFadingCircle(
    color: Colors.black,
    size: 40.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: appBar(),
        ),
        drawer: const SideBar(),
        floatingActionButton: AnimatedOpacity(
            duration: const Duration(milliseconds: 1000), //show/hide animation
            opacity: showbtn ? 1.0 : 0.0, //set obacity to 1 on visible, or hide
            child: FloatingActionButton(
              onPressed: () {
                scrollController.animateTo(
                  //go to top of scroll
                    0, //scroll offset to go
                    duration: const Duration(milliseconds: 500), //duration of scroll
                    curve: Curves.fastOutSlowIn //scroll type
                );
              },
              backgroundColor: Colors.black,
              child: const Icon(Icons.arrow_upward),
            )),
        body: RefreshIndicator(
            color: Colors.black,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
                controller: scrollController,
                child: Column(children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(00.0),
                          child: const Image(
                              image: AssetImage("assets/food.jpg"),
                              fit: BoxFit.cover),
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
                      Positioned(
                          bottom: 80,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  //color: Colors.blue,
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    child: const Text(
                                      "Explore cities through restaurants and their foods",
                                      style: TextStyle(
                                        color:
                                        Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 26,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                      'Best restaurants and their meals in $country',
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      _isLoading
                          ? Center(
                          child: SizedBox(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 70),
                                  child: Row(
                                    children: [
                                      spinkit,
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const Text(
                                        'Loading Restaurants...',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 20,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ))))
                          : cateList.isEmpty
                          ? Center(
                        child: Padding(
                          padding:const EdgeInsets.all(10),
                          child: Container(
                            height: 350,
                            width: 350,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/ad.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
// Foreground widget here
                      )
                          : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: cateList.length,
                          itemBuilder: (BuildContext context, int index) =>
                              VideographyCard(
                                  id: '${cateList[index]['_id']}',
                                  caption: '${cateList[index]['caption']}',
                                  view: cateList[index]['views'],
                                  comment: cateList[index]['comments_count'],
                                  thumbnailUrl: '${cateList[index]['youtube_link']}',
                                  image:'${cateList[index]['image_thumbnail']}'
                              )),
                      Padding(
                        padding: const EdgeInsets.only(left: 140, top: 10),
                        child: Row(
                          children: [
                            TextButton (
                              style: ButtonStyle(
                                  padding:
                                  MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(15)),
                                  overlayColor: MaterialStateColor.resolveWith(
                                          (states) => Colors.black26),
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.black),
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                          side: const BorderSide(color: Colors.black, width: 2)))),
                              onPressed: () {
                                print(_prevUrl);
                                if (_prevUrl.contains('null')) {
                                } else if (_prevUrl.contains('https')) {
                                  setState(() {
                                    scrollController.animateTo(
                                      //go to top of scroll
                                        0, //scroll offset to go
                                        duration: const Duration(
                                            milliseconds:
                                            500), //duration of scroll
                                        curve:
                                        Curves.fastOutSlowIn //scroll type
                                    );
                                    getCategory(_prevUrl);
                                    _isLoading = true;
                                  });
                                }
                              },
                              child: const Text(
                                'Previous',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            TextButton(
                              style: ButtonStyle(
                                  padding:
                                  MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(15)),
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.black),
                                  overlayColor: MaterialStateColor.resolveWith(
                                          (states) => Colors.black26),
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                          side: const BorderSide(color: Colors.black, width: 2)))),
                              onPressed: () {
                                print(_nextUrl);
                                if (_nextUrl.contains('null')) {
                                } else if (_nextUrl.contains('https')) {
                                  setState(() {
                                    scrollController.animateTo(
                                      //go to top of scroll
                                        0, //scroll offset to go
                                        duration: const Duration(
                                            milliseconds:
                                            500), //duration of scroll
                                        curve:
                                        Curves.fastOutSlowIn //scroll type
                                    );
                                    getCategory(_nextUrl);
                                    _isLoading = true;
                                  });
                                }
                              },
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Footer(),
                ]))));
  }
}
