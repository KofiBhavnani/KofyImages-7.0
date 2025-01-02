import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/events/add_event.dart';
import 'package:kofyimages/events/eventCard.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/widgets/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpComingEvents extends StatefulWidget {
  const UpComingEvents({super.key});

  @override
  State<UpComingEvents> createState() => _UpComingEventsState();
}

class _UpComingEventsState extends State<UpComingEvents> with OrientationMixin {
  bool _isLoading = true;
  double _height = 100;
  bool showbtn = false;
  bool _isAuth = false;
  String bg="";
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  late final userId;

  @override
  void dispose() {
    unlockOrientation();
    super.dispose();
  }

  final spinkit = const SpinKitFadingCircle(
    color: Colors.black,
    size: 40.0,
  );

  void checkforDetails() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    var tokenId = Authprefs.getString("token");
    userId = Authprefs.getString("id");
    print(tokenId);
    print(userId);

    if (tokenId == null) {
      // print("i am null");
      getCategory("${AppConstant.BASE_URL}/events/");
      setState(() {
        _isAuth = false;
      });
    } else {
      //  print("i am not null");
      getAuthCategory("${AppConstant.BASE_URL}/events/");
      setState(() {
        _isAuth = true;
      });
    }
  }

  @override
  void initState() {
    lockPortrait();
    checkforDetails();
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
    final response = await http.get(
      Uri.parse(url),
    );
    try {
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _height = 570;
            categoryMap = jsonDecode(response.body);
            cateList = categoryMap['results'];
          });

          print(cateList);
        }


      }
    } catch (error) {
      //  print("Cannot load");
    }
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
            _height = 570;
            categoryMap = jsonDecode(response.body);
            cateList = categoryMap['results'];
          });
        }

        //print(cateList);


      }
    } catch (error) {
      // print("Cannot load");
    }
  }

  @override
  Widget build(BuildContext context) {
    var isShowing = _isAuth;
    return Scaffold(
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
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/event.jpg"),
                  fit: BoxFit.cover,
                )),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  stops: const [0.0, 0.4],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16 ,),
                  height: 250,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 120),
                                child: SizedBox(
                                  height: 48,
                                  child: GestureDetector(child: const Icon(Icons.arrow_back_ios, size: 50,color: Colors.white,),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },),
                                ),
                              ),

                              const Text(
                                'Upcoming Events',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'All Upcoming Events',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 23,
                          ),
                          Visibility(
                            visible: isShowing,
                            child: Padding(
                              padding: const EdgeInsets.only(top:140),
                              child: SizedBox(
                                height: 48,
                                child: TextButton(
                                  style: ButtonStyle(
                                      padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.all(15)),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent),
                                      overlayColor: MaterialStateColor.resolveWith(
                                              (states) => Colors.white24),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                              side: const BorderSide(color: Colors.white)))),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const AddEvent()));
                                  },
                                  child:  Row(
                                    children: [
                                      Text(
                                        'Add Event',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )

                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'Find all Upcoming Events',
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Form(
                  child: SizedBox(
                    width: 250,
                    height: 60,
                    child: ClipRRect(
                      child: TextFormField(
                        controller: searchController,
                        style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (query) {
                          if (searchController.text.isNotEmpty) {
                            setState(() {
                              String searchUrl =
                                  "${AppConstant.BASE_URL}/events/?search=${searchController.text}";
                              _isLoading = true;
                              getCategory(searchUrl);
                            });
                          } else {
                            getCategory(
                                "${AppConstant.BASE_URL}/events/?limit=4");
                            _isLoading = true;
                          }
                        },
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: Colors.black)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black,
                              )),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Search for Events (City)",
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 1,
                ),
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
                        if (searchController.text.isNotEmpty) {
                          setState(() {
                            String searchUrl =
                                "${AppConstant.BASE_URL}/events/?search=${searchController.text}";
                            _isLoading = true;
                            getCategory(searchUrl);
                          });
                        } else {
                          getCategory(
                              "${AppConstant.BASE_URL}/events/?limit=4");
                          _isLoading = true;
                        }
                      },
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height:_height,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: _isLoading
                  ? Center(
                  child: SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              spinkit,
                              const SizedBox(
                                width: 4,
                              ),
                              const Text(
                                'Loading Upcoming Events',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ))))
                  : cateList.isEmpty
                  ? const Align(
                alignment: Alignment.center,
                child: Text(
                  'No Upcoming Event found! Check back later!',
                  style: TextStyle(
                      color: Color.fromARGB(255, 227, 35, 21),
                      fontSize: 20,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cateList.length,
                  itemBuilder: (context, index) {
                    return EventCard(
                        id: "${cateList[index]['_id']}",
                        image: "${cateList[index]['image']}",
                        city: "${cateList[index]['city']}",
                        owner: "${cateList[index]['owner']}",
                        country: "${cateList[index]['country']}",
                        name: "${cateList[index]['name']}",
                        location: " ${cateList[index]['location']}",
                        date: " ${cateList[index]['date']}",
                        time: " ${cateList[index]['time']}",
                        liked: cateList[index]['liked'],
                        likes: cateList[index]['likes_count'],
                        description: "${cateList[index]['description']}",
                        ownerId: "${cateList[index]["owner_id"]}"

                    );
                  }),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          const Footer(),
        ]),
      ),
    );
  }
}
