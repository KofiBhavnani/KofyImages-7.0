import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/footer.dart';
import 'package:kofyimages/views/widgets/lifestyle_card.dart';
import 'widgets/sidebar.dart';

class LifeStyle extends StatefulWidget {
  String? id;
  String? name;
  String? city;
  LifeStyle({super.key, this.id, this.name, this.city});

  @override
  State<LifeStyle> createState() => _LifeStyleState();
}

class _LifeStyleState extends State<LifeStyle> with OrientationMixin {
  double _isheight = 100;
  bool _isLoading = true;
  bool showbtn = false;
  ScrollController scrollController = ScrollController();
  final int _current = 0;
  final CarouselController _controller = CarouselController();

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

  String country = "";

  void main() async {
    print(widget.name);
    String? utf8Encoded = widget.city;
    var utf8Runes = utf8Encoded?.runes.toList();
    country = utf8.decode(utf8Runes!);
    print(country);
  }

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
      } else {
        showbtn = false;
      }
    });
    super.initState();
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
            print(cateList);
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
                              image: AssetImage("assets/lifestyle.png"),
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
                                      "Explore cities through lifestyle",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 35.0,
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
                      'Different lifestyles in $country',
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      _isLoading
                          ? Center(
                              child: SizedBox(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 90),
                                      child: Row(
                                        children: [
                                          spinkit,
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          const Text(
                                            'Loading Lifestyle',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 20,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ))))
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: cateList.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  InkWell(
                                onTap: () {
                                  showDialog(
                                    barrierColor: Colors.black,
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            child: const Icon(
                                              Icons.close_rounded,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            onTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                          ),
                                          CarouselSlider(
                                            options: CarouselOptions(
                                                height: 700,
                                                viewportFraction: 1.0,
                                                initialPage: index),
                                            items: cateList
                                                .map(
                                                  (item) => Container(
                                                    height: null,
                                                    color: Colors.black,
                                                    child: Center(
                                                      child: CachedNetworkImage(
                                                          imageUrl: item[
                                                              'popup_image'],
                                                          fit: BoxFit.contain,
                                                          height: null,
                                                          width: null,
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                                    child:
                                                                        const CircularProgressIndicator(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  )),

                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                          
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: LifeStyleCard(
                                  thumbnailUrl: "${cateList[index]['image']}",
                                  popUpUrl: "${cateList[index]['popup_image']}",
                                  name: "${cateList[index]['name']}",
                                ),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Footer(),
                ]))));
  }
}
