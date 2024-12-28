import 'dart:convert';
// ignore: library_prefixes
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/bookletcard.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import '../orientation_mixin.dart';

// ignore: must_be_immutable
class Booklet extends StatefulWidget {
  String? id;
  Booklet({super.key, this.id});

  @override
  State<Booklet> createState() => _BookletState();
}

class _BookletState extends State<Booklet> with OrientationMixin {
  bool _isLoading = true;
  bool showbtn = false;
  ScrollController scrollController = ScrollController();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    lockPortrait();
    getCategory(
        "${AppConstant.BASE_URL}/cities/${widget.id}/booklets/?limit=4");

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
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            categoryMap = jsonDecode(response.body);
            cateList = categoryMap['results'];
          });
        }
      }
    } catch (e) {
      return Text("Error $e");
    }
    return categoryMap;
  }

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
                  duration:
                      const Duration(milliseconds: 500), //duration of scroll
                  curve: Curves.fastOutSlowIn //scroll type
                  );
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.arrow_upward),
          )),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          controller: scrollController,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                      builder: (context) => const HomeView()));
                            },
                          ),
                          const Text(
                            " Travel Guide",
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
                padding: EdgeInsets.only(left: 20, top: 30),
                child: Text(
                  "Discover The World With Our Guide",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                )),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                _isLoading
                    ? Center(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 90),
                                child: Row(
                                  children: [
                                    spinkit,
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Text(
                                      'Loading Travel Guide',
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
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: cateList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            BookletCard(
                              id: "${cateList[index]['_id']}",
                              price: "${cateList[index]['price']}",
                              quantity: "${cateList[index]['quantity']}",
                              thumbnailUrls:
                                  List<String>.from(cateList[index]['images']),
                            )),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
          ]),
        ),
      ),
    );
  }
}
