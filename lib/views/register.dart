import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'dart:convert';
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../cart_provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with OrientationMixin {
  @override
  void initState() {
    lockPortrait();
    super.initState();
  }

  final Uri _url = Uri.parse('https://kofyimages.com/termsandcondition');
  bool hidePassword = true;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  bool isLoading = false;
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
                  "Creating Account..",
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

  Future<void> sendEmail() async {
    final apiUri =
        Uri.parse('https://api.mailgun.net/v3/info.kofyimages.com/messages');
    final response = await http.post(
      apiUri,
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('api:88a034d12ff68fc65e61b94daed1f5f5-48c092ba-68130820'))}',
      },
      body: {
        'from': 'KofyImages <postmaster@info.kofyimages.com>',
        'to':
            '${firstnameController.text.toString()} ${lastnameController.text.toString()} <${emailController.text.toString()}>',
        'subject': 'Welcome to KofyImages',
        'template': 'regtemplate',
        'h:X-Mailgun-Variables':
            '{"firstname": "${firstnameController.text.toString()}"}',
      },
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  String completeNumber = "";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
       appBar: const PreferredSize(
    preferredSize: Size.fromHeight(60),
    child: appBar(),
  ),
        drawer: const SideBar(),
        body: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 35,
                                fontWeight: FontWeight.w700),
                          )),
                      const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "First Name",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                          controller: firstnameController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black)),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter First Name",
                            hintStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Last Name ",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                          controller: lastnameController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black)),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Enter Last Name",
                            hintStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Phone Number",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )),
                      Container(
                          padding: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          child: IntlPhoneField(
                            controller: phoneController,
                            dropdownIcon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            textInputAction: TextInputAction.done,
                            disableLengthCheck: true,
                            dropdownTextStyle: const TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                            style: const TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.black)),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "545104648",
                              hintStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onChanged: (phone) {
                              setState(() {
                                completeNumber = phone.completeNumber;
                              });
                              print(completeNumber);
                            },
                          )),
                      const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Email Address",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                          controller: emailController,
                          decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.black)),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Enter Your Email Address",
                              hintStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              suffixIcon: const Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Password",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                          controller: passwordController,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black)),
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
                            filled: true,
                            hintText: "Enter Your Password",
                            hintStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: Colors.black,
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Confirm Password",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          )),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                          controller: confirmpasswordController,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black)),
                            fillColor: const Color.fromARGB(255, 245, 245, 245),
                            filled: true,
                            hintText: "Confirm Password",
                            hintStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: Colors.black,
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "By signing up you accept our ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          child: const Text(
                            "Terms and Conditions & Privacy Policy",
                            style: TextStyle(
                                color: Colors.red,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          onTap: () {
                            _launchUrl();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side:
                                            const BorderSide(color: Colors.black)))),
                            onPressed: () async {
                              if (firstnameController.text.isEmpty) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "First Name is Required!",
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
                              } else if (lastnameController.text.isEmpty) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Last Name is Required!",
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
                              } else if (phoneController.text.isEmpty) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Phone Number is Required!",
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
                              } else if (emailController.text.isEmpty) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Email Address is Required!",
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
                                    "Email Address invalid: ( '@' is missing)",
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
                              } else if (!emailController.text.contains('.')) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Email Address invalid: ( '.' is missing)",
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
                              } else if (passwordController.text.isEmpty) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Password is Required!",
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
                              } else if (confirmpasswordController
                                  .text.isEmpty) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Confirm Password is Required!",
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
                              } else if (passwordController.text.length < 8) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Password must be 8 or more than 8 characters",
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
                              } else if (passwordController.text !=
                                  confirmpasswordController.text) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Password does not match",
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
                                showProgressDialog(context, true);
                                register(
                                    firstnameController.toString(),
                                    lastnameController.toString(),
                                    emailController.toString(),
                                    completeNumber,
                                    passwordController.toString(),
                                    confirmpasswordController.toString());
                              }
                            },
                            child: const Text(
                              'Create Account',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                          GestureDetector(
                            child: const Text(
                              " Login",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginView()));
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ]),
              ),
            )));
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  Future<void> register(
    String firstname,
    String lastname,
    String email,
    String completeNumber,
    String password,
    String confirmpassword,
  ) async {
    try {
      http.Response response = await http
          .post(Uri.parse('${AppConstant.BASE_URL}/users/register/'), body: {
        "first_name": firstnameController.text,
        "last_name": lastnameController.text,
        "email": emailController.text,
        "phone": completeNumber,
        "password": passwordController.text,
        "password2": confirmpasswordController.text
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // ignore: use_build_context_synchronously
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginView()));
        });
        sendEmail();
        firstnameController.clear();
        lastnameController.clear();
        emailController.clear();
        phoneController.clear();
        passwordController.clear();
        confirmpasswordController.clear();
      } else if (response.body.contains('email')) {
        var data = jsonDecode(response.body.toString());
        print(data);
        setState(() {
          showProgressDialog(context, false);
          final snackdemo = SnackBar(
            content: Text(
              "${data['email'][0]}".capitalize(),
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackdemo);
        });
      } else if (response.body.contains('phone')) {
        var data = jsonDecode(response.body.toString());
        print(data);
        setState(() {
          showProgressDialog(context, false);
          final snackdemo = SnackBar(
            content: Text(
              "${data['phone'][0]}".capitalize(),
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackdemo);
        });
      } else if (response.body.isEmpty) {
        var data = jsonDecode(response.body.toString());
        print(data);
        setState(() {
          showProgressDialog(context, false);
          const snackdemo = SnackBar(
            content: Text(
              "Error. Kindly try again.",
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackdemo);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return split(" ").map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      } else {
        return "";
      }
    }).join(" ");
  }
}
