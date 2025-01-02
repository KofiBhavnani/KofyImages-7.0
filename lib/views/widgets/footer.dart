import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kofyimages/views/cart.dart';
import 'package:kofyimages/views/contactUs.dart';
import 'package:kofyimages/views/home.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  final now = DateTime.now();
  String formatter = DateFormat('yyyy').format(DateTime.now()); // 28/03/2020

  final emailController = TextEditingController();
  final _footerfield = GlobalKey<FormState>();
  final Uri _url = Uri.parse('https://kofyimages.com/privacy-policy');
  final Uri _terms = Uri.parse('https://kofyimages.com/termsandcondition');
  final Uri _faqs = Uri.parse('https://kofyimages.com/faq');
  final Uri _mail = Uri.parse('mailto:info@kofyimages.com');

  final Uri facebook_url =
      Uri.parse('https://www.facebook.com/people/KofyImages/100088051583463/');
  final Uri twitter_url = Uri.parse('https://twitter.com/KofyImages');
  final Uri instagram_url = Uri.parse('https://www.instagram.com/kofy_images/');

  void showSucessAlert() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Thank You for Subscribing.',
        confirmBtnText: 'Back To Explore',
        confirmBtnColor: Colors.black);
  }


    static showProgressDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
            Center(
              child: Column(children: [
                SpinKitFadingCircle(
                  color: Colors.black,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Subscribing...",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
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
    return Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      height: 950,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Container(
              height: 120.0,
              width: 210.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/black.png'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const HomeView()));
            },
          ),
          const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Got a burning question?",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400),
              )),
          const SizedBox(
            height: 2,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Reach us 24/7",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400),
              )),
          const SizedBox(
            height: 2,
          ),
          GestureDetector(
            child: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "info@kofyimages.com",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600),
                )),
            onTap: () {
              _launchmailUrl();
            },
          ),
          const SizedBox(
            height: 40,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Company",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700),
              )),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "Cities",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w400),
                )),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const HomeView()));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "FAQs",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w400),
                )),
            onTap: () {
              _launchfaqUrl();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "Contact Us",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w400),
                )),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ContactUsView()));
            },
          ),
          const SizedBox(
            height: 40,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Customer",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700),
              )),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "View Cart",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w400),
                )),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const CartView()));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "Terms and Conditions",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w400),
                )),
            onTap: () {
              _launchTermsUrl();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w400),
                )),
            onTap: () {
              _launchPolicyUrl();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Subscribe",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700),
              )),
          const SizedBox(
            height: 25,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "We update our catalog regularly, Subscribe to stay updated.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400),
              )),
          const SizedBox(
            height: 15,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                child: Row(
                  children: [
                    Form(
                        key: _footerfield,
                        child: SizedBox(
                          width: 250,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15)),
                            child: TextFormField(
                              style: const TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white)),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.red)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.white,
                                )),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Enter Your Email",
                                hintStyle: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox.fromSize(
                      size: const Size(70, 60),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        child: InkWell(
                          splashColor: Colors.black,
                          onTap: () async {
                            if (emailController.text.isEmpty) {
                              const snackdemo = SnackBar(
                                content: Text(
                                  "Email is Required! ",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackdemo);
                            } else if (!emailController.text.contains('@')) {
                              const snackdemo = SnackBar(
                                content: Text(
                                  "Email Invalid. ' @ ' is missing.",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackdemo);
                            } else if (!emailController.text.contains('.com')) {
                              const snackdemo = SnackBar(
                                content: Text(
                                  "Email Invalid. ' .com ' is missing.",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackdemo);
                            } else {
                              Map<String, dynamic> templateParams = {
                                'Email': emailController.text,
                              };
                              try {
                                showProgressDialog(context, true);
                                await EmailJS.send(
                                  'service_pgywu8s',
                                  'template_rrqm0eu',
                                  templateParams,
                                  const Options(
                                    publicKey: 'YOjym2Spg4YOheCI2',
                                    privateKey: 'LHrmn-W3Eztv3KMK_uYry',
                                  ),
                                );
                                // ignore: use_build_context_synchronously
                                showProgressDialog(context, false);
                                showSucessAlert();
                              } catch (error) {
                                showProgressDialog(context, false);
                                showSucessAlert();
                                print(error.toString());
                              }
                              //sendEmail();

                              emailController.clear();
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.solidPaperPlane),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
          const SizedBox(
            height: 30,
          ),
          Container(
            color: const Color.fromARGB(255, 31, 31, 31),
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                    child: Text(
                  "©$formatter.KofyImages.All rights reserved",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500),
                )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 120),
                    child: Row(
                      children: [
                        SizedBox.fromSize(
                          size: const Size(40, 40),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 31, 31, 31),
                            child: InkWell(
                              splashColor: Colors.black,
                              onTap: () {
                                _facebooklaunchUrl();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.squareFacebook,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox.fromSize(
                          size: const Size(40, 40),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 31, 31, 31),
                            child: InkWell(
                              splashColor: Colors.black,
                              onTap: () {
                                _twitterlaunchUrl();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.twitter,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox.fromSize(
                          size: const Size(40, 40),
                          child: Material(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(255, 31, 31, 31),
                            child: InkWell(
                              splashColor: Colors.black,
                              onTap: () {
                                _instagramlaunchUrl();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.instagram,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchPolicyUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchTermsUrl() async {
    if (!await launchUrl(_terms)) {
      throw Exception('Could not launch $_terms');
    }
  }

  Future<void> _launchfaqUrl() async {
    if (!await launchUrl(_faqs)) {
      throw Exception('Could not launch $_faqs');
    }
  }

  Future<void> _launchmailUrl() async {
    if (!await launchUrl(_mail)) {
      throw Exception('Could not launch $_mail');
    }
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
