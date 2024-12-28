import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/framedpictures_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'widgets/sidebar.dart';

class Framed_Pictures extends StatefulWidget {
  String? id;
  Framed_Pictures({super.key, this.id});

  @override
  State<Framed_Pictures> createState() => _Framed_PicturesState();
}

class _Framed_PicturesState extends State<Framed_Pictures> with OrientationMixin{
  bool _isLoading = true;
  bool showbtn = false;
   ScrollController scrollController = ScrollController();

    Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
     getCategory(
        "${AppConstant.BASE_URL}/frames/?limit=6");
    });
  }

  TextEditingController searchController = TextEditingController();
  String _nextUrl = "null";
  String _prevUrl = "null";

  @override
  void initState() {
    lockPortrait();
    getCategory(
        "${AppConstant.BASE_URL}/frames/?limit=6");
    scrollController.addListener(() {
      //scroll listener
      double showoffset = 3; //Back to top botton will show on scroll offset 10.0

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


  Map<String, dynamic> categoryMap = {};
  List<dynamic> cateList = [];

  Future getCategory(String url) async {
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        if (mounted){
        setState(() {
          _isLoading = false;
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
return  Scaffold(
  backgroundColor: Colors.white,
       appBar: const PreferredSize(
    preferredSize: Size.fromHeight(60),
    child: appBar(),
  ),
            drawer: const SideBar(),
            floatingActionButton: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000), //show/hide animation
                opacity:
                    showbtn ? 1.0 : 0.0, //set obacity to 1 on visible, or hide
                child: FloatingActionButton(
                  onPressed: () {
                    scrollController.animateTo(
                        //go to top of scroll
                        0, //scroll offset to go
                        duration:
                            const Duration(milliseconds: 500), //duration of scroll
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
                child: Column(
                  crossAxisAlignment: 
                CrossAxisAlignment.start,
                  children: <Widget>[
                                Container(
                height: 80.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0.0),
                    color: Colors.black),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              child: const Text(
                                "Home  >",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeView()));
                              },
                            ),
                            const Text(
                              " Frames",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
             const Padding(
                  padding: EdgeInsets.only( left: 20, top: 30),
                  child: Text(
                    "Curated frame collections",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  )),

                  Column(
                    children: [
                      _isLoading
                          ? Center(
                              child: SizedBox(
                                  height: 400,
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
                                            'Loading Frames...',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 20,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ))))
                    : ListView.builder(
                              padding: const EdgeInsets.all(20.0),
                              itemCount: cateList.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) =>
                            Framed_PicturesCard(
                              id: "${cateList[index]['_id']}",
                              name: "${cateList[index]['name']}",
                              size: "${cateList[index]['size']}",
                              price: "${cateList[index]['price']}",
                              quantity: "${cateList[index]['quantity']}",
                              thumbnailUrls:
                                  List<String>.from(cateList[index]['images']),
                            )),
                      Padding(
                        padding: const EdgeInsets.only(left: 100,),
                        child: Row(
                          children: [
                            TextButton(
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
                    height: 50,
                  ),
                ]))));
  }
}
