import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/flight/search.dart';
import 'package:kofyimages/views/articles.dart';
import 'package:kofyimages/views/booklet.dart';
import 'package:kofyimages/views/food.dart';
import 'package:kofyimages/views/framed_pictures.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/lifestyle.dart';
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/transport.dart';
import 'package:kofyimages/views/videography.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/footer.dart';
import 'package:kofyimages/views/widgets/subcategories_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../orientation_mixin.dart';
import 'widgets/sidebar.dart';

class SubCategory extends StatefulWidget {
  String id;
  String name;
  String code;
  String country;
  String thumbnailUrl;
  int likes;
  bool liked;

  SubCategory(
      {super.key,
      required this.id,
      required this.country,
      required this.name,
      required this.thumbnailUrl,
      required this.code,
      required this.likes,
      required this.liked});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> with OrientationMixin {
  bool _isLoading = true;
  bool _showFrame = false;
  bool _isLiked = false;
  bool _likesNumber = false;
  bool _isAuth = false;

  void clearpref() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    await Authprefs.remove("name");
    await Authprefs.remove("last");
    await Authprefs.remove("email");
    await Authprefs.remove("token");
    await Authprefs.remove("id");
  }

  void getCred() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    var tokenId = Authprefs.getString("token");
    if (tokenId == null) {
      setState(() {
        _isAuth = false;
        _isLiked = widget.liked;
      });
    } else {
      setState(() {
        _isAuth = true;
        _isLiked = widget.liked;
      });
    }
  }

  @override
  void initState() {
    lockPortrait();
    getCred();
    main();
    super.initState();
    getCategory("${AppConstant.BASE_URL}/cities/${widget.id}/");
    getArticles("${AppConstant.BASE_URL}/cities/${widget.id}/articles/");
  }

  String country = "";

  void main() async {
    String utf8Encoded = widget.country;
    var utf8Runes = utf8Encoded.runes.toList();
    country = utf8.decode(utf8Runes);
    print(country);
  }

  Map<String, dynamic> categoryMap = {};
  List<dynamic> cateList = [];
  Map<String, dynamic> articlesMap = {};
  List<dynamic> articlesList = [];

  Future getArticles(String url) async {
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            articlesMap = jsonDecode(response.body);
            articlesList = articlesMap['results'];
          });
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future getCategory(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _showFrame = true;
            _isLoading = false;
            categoryMap = jsonDecode(response.body);
            categoryMap["results"].forEach((result) {
              if (result["name"] == "booklet") {
                result["name"] = "travel guide";
              }
              if (result["name"] == "food") {
                result["name"] = "restaurants";
              }
              if (result["name"] == "videos") {
                result["name"] = "videography";
                result["image"] =
                    "https://drive.google.com/uc?export=view&id=13dc8T7qie1qyCv_sRydlZaSFSp9uSbyJ";

              }
        
              if (result["name"]== "transport"){
                result["name"]="transport";
                result["image"] = "https://drive.google.com/uc?export=view&id=18x5_P8UIogl0-cYInspBYTxLqT8K5RG9";
              }
              cateList.add(result);
            });
          });
        }
      }
    } catch (e) {
      return Text("Error $e");
    }
    return categoryMap;
  }

  showSessionDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
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
                  "Login Required",
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
                  "Please Login",
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
                        child: Container(
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
                        ),
                        onTap: () {
                          Navigator.pop(context);
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

  @override
  final spinkit = const SpinKitFadingCircle(
    color: Colors.black,
    size: 40.0,
  );

  bool isLoading = false;
  static showProgressDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
              backgroundColor: Colors.white,
              children: <Widget>[
                Center(
                  child: Column(children: [
                    SpinKitPumpingHeart(
                      color: Colors.red,
                      size: 40.0,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ]),
                )
              ]);
        },
      );
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.likes == 0) {
      setState(() {
        _likesNumber = false;
      });
    } else if (widget.likes != 0) {
      _likesNumber = true;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: appBar(),
        ),
        drawer: const SideBar(),
        body: SingleChildScrollView(
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
                      image: AssetImage("assets/top.jpg"), fit: BoxFit.cover),
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
                left: 15.0,
                bottom: 150.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "The City Of ${widget.name}, $country",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Explore the city of ${widget.name},",
                      style: const TextStyle(
                          color: Colors.white,
                           fontSize: 16.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "$country through their foods, ",
                      style: const TextStyle(
                          color: Colors.white,
                           fontSize: 16.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400),
                    ),
                    const Text(
                      "lifestyle and festival.",
                      style: TextStyle(
                          color: Colors.white,
                           fontSize: 16.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 270.0,
                  bottom: 40.0,
                  child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                              showProgressDialog(context, true);
                              postLike();
                            },
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Visibility(
                            visible: _likesNumber,
                            child: Text(
                              widget.likes.toString(),
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  fontFamily: "Montserrat",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ))),
              Positioned(
                  left: 8.0,
                  bottom: 25.0,
                  child: SizedBox(
                    height: 55,
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.black54),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: const BorderSide(
                                          color: Colors.white)))),
                      onPressed: () async {
                        if (_isAuth == false) {
                          showSessionDialog(context);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchFlight(
                                        id: widget.id,
                                        country: widget.country,
                                        name: widget.name,
                                        thumbnailUrl: widget.thumbnailUrl,
                                        code: widget.code,
                                      )));
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            'Visit ${widget.name}, $country',
                            style: const TextStyle(
                                fontSize: 14.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w700),
                          ),
                          SvgPicture.asset(
                            'assets/plane.svg',
                            color: Colors.white,
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  )),
              Positioned(
                  left: 8.0,
                  bottom: 90.0,
                  child: SizedBox(
                    height: 50,
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: const BorderSide(
                                          color: Colors.white)))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Framed_Pictures()));
                      },
                      child: const Text(
                        'Buy a Frame',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700),
                      ),
                    ),

                    // <-- Your height
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: null,
            //color: Colors.red,
            width: 500,
            child: Column(
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
                                    Text(
                                      'Loading ${widget.name}...',
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 20,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ))))
                    : ListView.builder(
                        padding: const EdgeInsets.all(0),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: cateList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            SubCategoriesCard(
                                country: "${cateList[index]['city']}",
                                name: "${cateList[index]['name']}",
                                thumbnailUrl: "${cateList[index]['image']}",
                                onPressed: () {
                                  if (cateList[index]['name'] ==
                                      "restaurants") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Food(
                                                  id: widget.id,
                                                  name: "food",
                                                  city: cateList[index]['city'],
                                                )));
                                  }
                                  if (cateList[index]['name'] == "lifestyle") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LifeStyle(
                                                  id: widget.id,
                                                  name: cateList[index]['name'],
                                                  city: cateList[index]['city'],
                                                )));
                                  }
                                  if (cateList[index]['name'] ==
                                      "travel guide") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Booklet(
                                                  id: widget.id,
                                                )));
                                  }
                                  if (cateList[index]['name'] ==
                                      "videography") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Videography(
                                                id: widget.id,
                                                city: cateList[index]['city'],
                                                thumbnailUrl: cateList[index]
                                                    ['image'])));
                                  }
                                    if (cateList[index]['name'] ==
                                      "transport") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Transport(
                                                  id: widget.id,
                                                  city: cateList[index]['city'],
                                                  thumbnailUrl: cateList[index]['image'],
                                                )));
                                  }
                                  
                                })),
                GestureDetector(
                    onTap: () {
                      if (articlesList.isEmpty) {
                        final snackdemo = SnackBar(
                          content: Text(
                            "No Article found for the City Of ${widget.name}, $country",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackdemo);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Articles(
                                      id: widget.id,
                                      thumbnailUrl: widget.thumbnailUrl,
                                    )));
                      }
                    },
child: Visibility(
  visible: _showFrame,
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 320,
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            image: DecorationImage(
              image: AssetImage('assets/articles.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                // Add this container for the dark shade
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.black.withOpacity(0.3), // Adds a dark overlay
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    "Articles",
                    style: TextStyle(
                      fontSize: 19,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
                ),

                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Framed_Pictures()));
                    },
                    child: Visibility(
                      visible: _showFrame,
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
        Container(
          width: 320,
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            image: DecorationImage(
              image: AssetImage('assets/frames.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                // Add this container for the dark shade
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.black.withOpacity(0.3), // Adds a dark overlay
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    "Frames",
                    style: TextStyle(
                      fontSize: 19,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
          const Footer(),
        ])));
  }

  Future<void> postLike() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    http.Response response = await http.post(
        Uri.parse('${AppConstant.BASE_URL}/cities/${widget.id}/likes/'),
        headers: {
          'Authorization': Authprefs.getString("token").toString(),
        });
    var data = jsonDecode(response.body.toString());
    print(data);

    if (response.statusCode == 201) {
      if (data['liked'] == true) {
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeView()));

          final snackdemo = SnackBar(
            content: Text(
              "You Liked ${widget.name}, $country 🥰",
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackdemo);
        });
      } else {
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeView()));

          final snackdemo = SnackBar(
            content: Text(
              "You unliked ${widget.name}, $country 🙁",
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackdemo);
        });
      }
    } else if (response.statusCode == 401) {
      setState(() {
        showProgressDialog(context, false);
        showSessionDialog(context);
      });
    }
  }
}
