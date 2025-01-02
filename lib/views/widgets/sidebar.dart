import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kofyimages/views/contactUs.dart';
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/profile.dart';
import 'package:kofyimages/views/register.dart';
import 'package:kofyimages/views/reviews.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    Key? key,
  }) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkforDetails();
  }

  final Uri facebook_url =Uri.parse('https://www.facebook.com/people/KofyImages/100088051583463/');
  final Uri twitter_url = Uri.parse('https://twitter.com/KofyImages');
  final Uri instagram_url = Uri.parse('https://www.instagram.com/kofy_images/');

  String name = "";
  bool loggedIn = false;
  bool loggedOut = false;

  void checkforDetails() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    var tokenId = Authprefs.getString("token");
    print(tokenId);

    if (tokenId == null) {
      clearpref();
    } else {
      getCred();
    }
  }

  void getCred() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    var text = Authprefs.getString("name");
    var tokenId = Authprefs.getString("token");

    setState(() {
      name = text.toString();
      loggedIn = true;
      loggedOut = false;
    });
  }

  void clearpref() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    await Authprefs.remove("name");
    await Authprefs.remove("token");
    await Authprefs.remove("id");
    setState(() {
      loggedIn = false;
      loggedOut = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isVisible = loggedIn;
    var isShow = loggedOut;
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [

          GestureDetector(
         child: Container(
            padding: const EdgeInsets.all(8),
            width: 200,
            height: 200,
            child: Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                "assets/home.jpeg",
                height: 200.0,
                width: 180.0,
              ),
            ),
          ),
          onTap: () {
                                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const HomeView()));
          },),
          const Text(
            "  Explore Cities Through Pictures",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
          const Divider(),
          const SizedBox(
            height: 25,
          ),
          Visibility(
            visible: isVisible,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: Text('Hi, $name',
                      style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Row(
                    children: const [
                      Text(
                    'HOME',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ) ,
                  SizedBox(width: 65,),
                  Icon(
                    Icons.home,
                    color: Colors.black,
                  ),

                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeView()));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                                ListTile(
                  title: Row(
                    children: const [
                      Text(
                    'PROFILE',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ) ,
                  SizedBox(width: 45,),
                  Icon(
                    Icons.person,
                    color: Colors.black,
                  ),

                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  },
                ),
                                const SizedBox(
                  height: 10,
                ),
                                ListTile(
                  title: Row(
                    children: const [
                      Text(
                    'REVIEWS',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ) ,
                  SizedBox(width: 40,),
                  Icon(
                    Icons.reviews_rounded,
                    color: Colors.black,
                  ),

                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SubmitReview()));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  title: Row(
                    children: const [
                      Text(
                    'LOGOUT',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ) ,
                  SizedBox(width: 45,),
                  Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),

                    ],
                  ),
                  onTap: () {
                    clearpref();
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: isShow,
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: const [
                      Text(
                    'HOME',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ) ,

                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeView()));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.login_rounded,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'LOGIN',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ) ,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  title:                       const Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ) ,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterView()));
                  },
                ),
              ],
            ),
          ),
          const Divider(),

          ListTile(
            title: const Text('CONTACT US',
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsView()));
            },
          ),
          const SizedBox(
            height: 5,
          ),
          const ListTile(
            title:  Text(
                    'CONNECT WITH US ',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  ) ,
          ),
          Row(
            children: [
              SizedBox(
                width: 70,
                height: 50,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: IconButton(
                      color: Colors.black,
                      iconSize: 30,
                      icon: const Icon(Icons.facebook_outlined),
                      onPressed: () {
                        _facebooklaunchUrl();
                      }),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 70,
                height: 50,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white70,
                  child: IconButton(
                      color: Colors.black,
                      iconSize: 30,
                      icon: const FaIcon(FontAwesomeIcons.twitter),
                      onPressed: () {
                        _twitterlaunchUrl();
                      }),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 70,
                height: 50,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: IconButton(
                      color: Colors.black,
                      iconSize: 30,
                      icon: const FaIcon(FontAwesomeIcons.instagram),
                      onPressed: () {
                        _instagramlaunchUrl();
                      }),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _facebooklaunchUrl() async {
    if (!await launchUrl(facebook_url)) {
       throw Exception('Could not launch $facebook_url');
    }
  }

  Future<void> _twitterlaunchUrl() async {
    if (!await launchUrl(twitter_url)) {
       throw Exception('Could not launch $twitter_url');
    }
  }

  Future<void> _instagramlaunchUrl() async {
    if (!await launchUrl(instagram_url)) {
       throw Exception('Could not launch $instagram_url');
    }
  }
}
