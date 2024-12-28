import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/articleCard.dart';
import 'package:kofyimages/views/widgets/footer.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';

class Articles extends StatefulWidget {
  final String id;
  final String thumbnailUrl;
  const Articles({super.key, required this.id, required this.thumbnailUrl});

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> with OrientationMixin {
  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
       getCategory("${AppConstant.BASE_URL}/cities/${widget.id}/articles/");
    });
  }

  bool _isLoading = true;
  final bool _showFrame = false;
  bool showbtn = false;
  ScrollController scrollController = ScrollController();
  String articleOwner = "";
  String articleCity = "";
  String articleTitle = "";
  String articleContent = "";
  String articleContentRendered = "";

  @override
  void initState() {
    super.initState();
    lockPortrait();
    getCategory("${AppConstant.BASE_URL}/cities/${widget.id}/articles/");
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
            categoryMap = jsonDecode(response.body);
            cateList = categoryMap['results'];
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
                              image: AssetImage("assets/articlesCover.jpg"),
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
                          bottom: 60,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                    //color: Colors.blue,
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    child: const Text(
                                      "Articles",
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
                    height: 2,
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
                                            'Loading Article...',
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
                                  ArticleCard(
                                    thumbnailUrl:widget.thumbnailUrl,
                                    owner:"${cateList[index]['owner']}",
                                    city:"${cateList[index]['city']}",
                                    title:"${cateList[index]['title']}",
                                    content: "${cateList[index]['content']}",
                                    contentRendered: "${cateList[index]['content_rendered']}")),
                    ],
                  ),
                  const Footer(),
                ]))));
  }
}