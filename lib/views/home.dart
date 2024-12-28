import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kofyimages/card_item_model.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/events/splash.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/subcategories.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/footer.dart';
import 'package:kofyimages/views/widgets/categories_card.dart';
import 'package:http/http.dart' as http;
import 'package:kofyimages/views/widgets/photoOfTheWeekCard.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import 'package:kofyimages/weather/ui/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with OrientationMixin {
  bool _isLoading = true;
  bool showbtn = false;

  ScrollController scrollController = ScrollController();

  Future<void> _onRefresh() async {
    checkforDetails();
    getPhotoOfTheWeek("${AppConstant.BASE_URL}/exhibitions/photo-of-the-week");
    setState(() {
      _isLoading = true;
      checkforDetails();
    });
  }

  void checkforDetails() async {
    // ignore: non_constant_identifier_names
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    var tokenId = Authprefs.getString("token");
    print(tokenId);

    if (tokenId == null) {
      print("i am null");
      getCategory("${AppConstant.BASE_URL}/cities/?limit=6");
      setState(() {
        _isAuth = false;
      });
    } else {
      print("i am not null");
      getAuthCategory("${AppConstant.BASE_URL}/cities/?limit=6");
      setState(() {
        _isAuth = true;
      });
    }
  }

  checkNetwork() {}

  @override
  void dispose() {
    unlockOrientation();
    super.dispose();
  }

  TextEditingController searchController = TextEditingController();
  String _nextUrl = "null";
  String _prevUrl = "null";
  bool _isAuth = false;

  @override
  void initState() {
    checkforDetails();
    getPhotoOfTheWeek("${AppConstant.BASE_URL}/exhibitions/photo-of-the-week");
    lockPortrait();
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

  void clearpref() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    await Authprefs.remove("name");
    await Authprefs.remove("token");
    await Authprefs.remove("id");
  }

  Map<String, dynamic> categoryMap = {};
  List<dynamic> cateList = [];

  Map<String, dynamic> photoOfTheWeekMap = {};

  Future getCategory(String url) async {
    final response = await http.get(
      Uri.parse(url),
    );
    try {
      if (response.statusCode == 200) {
        if (mounted) {
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

          print(cateList[0]['_id'].toString());
        }
      }
    } catch (error) {
      print("Cannot load");
    }
  }

  Future getPhotoOfTheWeek(String url) async {
    final response = await http.get(
      Uri.parse(url),
    );
    try {
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            photoOfTheWeekMap = jsonDecode(response.body);
          });
        }
      }
    } catch (error) {
      print(error);
    }
  }

  showConnectDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              //color: Colors.red,
              borderRadius: BorderRadius.circular(12.0),
            ),
            width: 100,
            height: 120,
            child: Column(
              children: [
                const Text(
                  "No Internet",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Please Check your Internet Connection",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 80),
                      child: GestureDetector(
                        child: const Center(
                          child: Text(
                            "Retry",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future getAuthCategory(String url) async {
    try {
      SharedPreferences Authprefs = await SharedPreferences.getInstance();
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': Authprefs.getString("token").toString(),
      });

      if (response.statusCode == 200) {
        if (mounted) {
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
      } else {
        showSessionDialog(context);
      }
    } catch (error) {
      print(error);
    }
  }

  showSessionDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            decoration: BoxDecoration(
              //color: Colors.red,
              borderRadius: BorderRadius.circular(12.0),
            ),
            width: 100,
            height: 120,
            child: Column(
              children: [
                const Text(
                  "Session Expired",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Login Required",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        child: const Center(
                          child: Text(
                            "Dismiss",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          clearpref();
                          getCategory(
                              "${AppConstant.BASE_URL}/cities/?limit=4");
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                      child: const SizedBox(
                        width: 100,
                        height: 40,
                        child: Center(
                          child: Text(
                            "LogIn",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        clearpref();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()));
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  final spinkit = const SpinKitThreeBounce(
    color: Colors.black,
    size: 60.0,
  );

  List<CardItem> items = [
    const CardItem(
        urlImage: "assets/events.png",
        title: "Events",
        subtitle: "View Events"),
    const CardItem(
        urlImage: "assets/weather.png",
        title: "Weather",
        subtitle: "View Weather"),
    //const CardItem(urlImage: "assets/news.png", title: "News", subtitle: "View News"),
    //const CardItem( urlImage: "assets/stock.png", title: "Stocks", subtitle: "View Stock"),
    //const CardItem(urlImage: "assets/more.png", title: "More", subtitle: "View More"),
  ];

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
      body: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
          // sometimes the stream builder doesn't work with simulator so you can check this on real devices to get the right result
          if (snapshot.hasData) {
            ConnectivityResult? result = snapshot.data;
            if (result == ConnectivityResult.mobile) {
              return mainCard();
            } else if (result == ConnectivityResult.wifi) {
              return mainCard();
            } else {
              return noInternet();
            }
          } else {
            return mainCard();
          }
        },
      ),
    );
  }

  Widget mainCard() {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
          controller: scrollController,
          child: Column(children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.width,
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
                        image: AssetImage("assets/main_card.jpg"),
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  left: 15.0,
                  bottom: 200.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Experience different cultures",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 19,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "through their food ,lifestyle",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 19,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "and festival ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                         fontSize: 19,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 120.0,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Container(
                          child: Row(
                            children: [
                              Form(
                                  child: SizedBox(
                                width: 250,
                                height: 60,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15)),
                                  child: TextFormField(
                                    controller: searchController,
                                    style: const TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value) async {
                                      SharedPreferences Authprefs =
                                          await SharedPreferences.getInstance();
                                      var tokenId =
                                          Authprefs.getString("token");
                                      if (tokenId != null) {
                                        if (searchController.text.isNotEmpty) {
                                          setState(() {
                                            String searchUrl =
                                                "${AppConstant.BASE_URL}/cities/?search=${searchController.text}";
                                            _isLoading = true;
                                            getAuthCategory(searchUrl);
                                          });
                                        } else {
                                          getAuthCategory(
                                              "${AppConstant.BASE_URL}/cities/?limit=4");
                                          _isLoading = true;
                                        }
                                      } else if (tokenId == null) {
                                        if (searchController.text.isNotEmpty) {
                                          setState(() {
                                            String searchUrl =
                                                "${AppConstant.BASE_URL}/cities/?search=${searchController.text}";
                                            _isLoading = true;
                                            getCategory(searchUrl);
                                          });
                                        } else {
                                          getCategory(
                                              "${AppConstant.BASE_URL}/cities/?limit=4");
                                          _isLoading = true;
                                        }
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.white)),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.red)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.white,
                                      )),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "Search for Cities",
                                      hintStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                              )),
                              SizedBox.fromSize(
                                size: const Size(70, 60),
                                child: Material(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  color: Colors.black,
                                  child: InkWell(
                                    splashColor: Colors.black,
                                    onTap: () async {
                                      SharedPreferences Authprefs =
                                          await SharedPreferences.getInstance();
                                      var tokenId =
                                          Authprefs.getString("token");
                                      if (tokenId != null) {
                                        if (searchController.text.isNotEmpty) {
                                          setState(() {
                                            String searchUrl =
                                                "${AppConstant.BASE_URL}/cities/?search=${searchController.text}";
                                            _isLoading = true;
                                            getAuthCategory(searchUrl);
                                          });
                                        } else {
                                          getAuthCategory(
                                              "${AppConstant.BASE_URL}/cities/?limit=4");
                                          _isLoading = true;
                                        }
                                      } else if (tokenId == null) {
                                        if (searchController.text.isNotEmpty) {
                                          setState(() {
                                            String searchUrl =
                                                "${AppConstant.BASE_URL}/cities/?search=${searchController.text}";
                                            _isLoading = true;
                                            getCategory(searchUrl);
                                          });
                                        } else {
                                          getCategory(
                                              "${AppConstant.BASE_URL}/cities/?limit=4");
                                          _isLoading = true;
                                        }
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.search,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80),
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) =>
                      buildCard(item: items[index]),
                ),
              ),
            ),
            const Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 10),
              child: Text.rich(
                TextSpan(children: [
                  WidgetSpan(
                    child: Container(
                      padding: const EdgeInsets.only(
                          bottom: 8.0), // Adjust the padding to control space
                      child: const Text(
                        'Photo O',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 19,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  WidgetSpan(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black, // Color of the underline
                            width: 3.0, // Thickness of the underline
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          bottom: 5.0), // Adjust the padding to control space
                      child: const Text(
                        'f Th',
                        style: TextStyle(
                          color: Colors.black87,
                         fontSize: 19,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  WidgetSpan(
                    child: Container(
                      padding: const EdgeInsets.only(
                          bottom: 8.0), // Adjust the padding to control space
                      child: const Text(
                        'e Week',
                        style: TextStyle(
                          color: Colors.black87,
                         fontSize: 19,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Container(
              child: _isLoading
                  ? Center(child: spinkit)
                  : photoOfTheWeekMap.isEmpty
                      ? Center(child: spinkit)
                      : PhotoOfTheWeekCard(
                          id: photoOfTheWeekMap['_id'],
                          image: photoOfTheWeekMap['image'],
                          name: photoOfTheWeekMap['name'],
                          imageThumbnail: photoOfTheWeekMap['image_thumbnail'],
                          city: photoOfTheWeekMap['city'],
                          caption: photoOfTheWeekMap['caption'],
                          contentRendered:
                              photoOfTheWeekMap['content_rendered'],
                        ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: 22, top: 10),
              child: Text(
                'Curated Cities Collections',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 22),
              child: Text(
                'Explore diverse collections of cities, their foods,lifestyle and festivals.',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                _isLoading
                    ? Center(child: spinkit)
                    : cateList.isEmpty
                        ? const Center(
                            child: Text(
                              'City not found! Check back later!',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 227, 35, 21),
                                  fontSize: 20,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: cateList.length,
                            itemBuilder: (BuildContext context, int index) {
                              try {
                                return MainCategoriesCard(
                                    id: "${cateList[index]['_id']}",
                                    country: "${cateList[index]['country']}",
                                    name: " ${cateList[index]['name']}",
                                    thumbnailUrl: "${cateList[index]['image']}",
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SubCategory(
                                                    id: cateList[index]['_id'],
                                                    name: cateList[index]
                                                        ['name'],
                                                    country: cateList[index]
                                                        ['country'],
                                                    thumbnailUrl:
                                                        cateList[index]
                                                            ['image'],
                                                    likes: cateList[index]
                                                        ['likes_count'],
                                                    liked: cateList[index]
                                                        ['liked'],
                                                    code: cateList[index]
                                                            ['iata_code']
                                                        .toString(),
                                                  )));
                                    });
                              } catch (e) {
                                return Text("$e");
                              }
                            }),
                Padding(
                  padding: const EdgeInsets.only(left: 150),
                  child: Row(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(15)),
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black26),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(
                                        color: Colors.black, width: 2)))),
                        onPressed: () {
                          print(_prevUrl);

                          if (_isAuth == false) {
                            if (_prevUrl.contains('null')) {
                            } else if (_prevUrl.contains('https')) {
                              setState(() {
                                scrollController.animateTo(
                                    //go to top of scroll
                                    0, //scroll offset to go
                                    duration: const Duration(
                                        milliseconds: 500), //duration of scroll
                                    curve: Curves.fastOutSlowIn //scroll type
                                    );
                                getCategory(_prevUrl);
                                _isLoading = true;
                              });
                            }
                          } else if (_isAuth == true) {
                            if (_prevUrl.contains('null')) {
                            } else if (_prevUrl.contains('https')) {
                              setState(() {
                                scrollController.animateTo(
                                    //go to top of scroll
                                    0, //scroll offset to go
                                    duration: const Duration(
                                        milliseconds: 500), //duration of scroll
                                    curve: Curves.fastOutSlowIn //scroll type
                                    );
                                getAuthCategory(_prevUrl);
                                _isLoading = true;
                              });
                            }
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
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(15)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.black26),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(
                                        color: Colors.black, width: 2)))),
                        onPressed: () {
                          print(_nextUrl);

                          if (_isAuth == false) {
                            if (_nextUrl.contains('null')) {
                            } else if (_nextUrl.contains('https')) {
                              setState(() {
                                scrollController.animateTo(
                                    //go to top of scroll
                                    0, //scroll offset to go
                                    duration: const Duration(
                                        milliseconds: 500), //duration of scroll
                                    curve: Curves.fastOutSlowIn //scroll type
                                    );
                                getCategory(_nextUrl);
                                _isLoading = true;
                              });
                            }
                          } else if (_isAuth == true) {
                            if (_nextUrl.contains('null')) {
                            } else if (_nextUrl.contains('https')) {
                              setState(() {
                                scrollController.animateTo(
                                    //go to top of scroll
                                    0, //scroll offset to go
                                    duration: const Duration(
                                        milliseconds: 500), //duration of scroll
                                    curve: Curves.fastOutSlowIn //scroll type
                                    );
                                getAuthCategory(_nextUrl);
                                _isLoading = true;
                              });
                            }
                          }
                        },
                        child: const Text(
                          "Next",
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
          ])),
    );
  }

  Widget noInternet() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/no_internet.png',
            color: Colors.red,
            height: 100,
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            child: const Text(
              "No Internet connection",
              style: TextStyle(
                fontSize: 22,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: const Text("Check your connection, then refresh the page.",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                )),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
            ),
            onPressed: () async {
              // You can also check the internet connection through this below function as well
              ConnectivityResult result =
                  await Connectivity().checkConnectivity();
              print(result.toString());
            },
            child: const Text("Refresh",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required CardItem item,
  }) =>
      SizedBox(
        width: 90,
        //color: Colors.red,
        child: Column(
          children: [
            Expanded(
              child: Ink.image(
                image: AssetImage(item.urlImage),
                fit: BoxFit.contain,
                child: InkWell(
                  onTap: () {
                    if (item.title == "Events") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventSplash()));
                    } else if (item.title == "Weather") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SplashScreen()));
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                item.title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                item.subtitle,
                style: const TextStyle(
                    color: Colors.black26,
                    fontSize: 12,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
}
