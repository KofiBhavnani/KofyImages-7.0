import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import 'package:http/http.dart' as http;

class ForgottenPassword extends StatefulWidget {
  const ForgottenPassword({super.key});

  @override
  State<ForgottenPassword> createState() => _ForgottenPasswordState();
}

class _ForgottenPasswordState extends State<ForgottenPassword> with OrientationMixin {
  String errormsg = "";
  final _passfield = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

     @override
  void initState() {
    lockPortrait();

  }

  bool isLoading = false;
  static showProgressDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
            Center(
              child: Column(children: const [
                SpinKitFadingCircle(
                  color: Colors.black,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Requesting Password...",
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
    return Scaffold(
       appBar: const PreferredSize(
    preferredSize: Size.fromHeight(60),
    child: appBar(),
  ),
      drawer: const SideBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                    height: 550,
                    width: 400,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(245, 240, 239, 239),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2.0,
                          ),
                        ]),
                    child: Form(
                      key: _passfield,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Recover Your Password",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "You can request a password reset below. We will send a link to your email address, please make sure it is correct.",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
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
                              keyboardType: TextInputType.emailAddress,
                              validator: (input) => !input!.contains("@")
                                  ? "Email Address should be Valid"
                                  : null,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.black)),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Enter Your Email Address",
                                hintStyle:
                                    const TextStyle(fontFamily: 'Montserrat'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.email),
                                  color: Colors.black,
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 70,
                              width: 300,
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              side: const BorderSide(
                                                  color: Colors.black)))),
                                  onPressed: () async {
                                    if (emailController.text.isEmpty) {
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
                                    } else if (!emailController.text
                                        .contains('@')) {
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
                                    } else if (!emailController.text
                                        .contains('.')) {
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
                                    } else {
                                      showProgressDialog(context, true);
                                      resetPassword(emailController.toString());
                                    }
                                  },
                                  child: const Text(
                                    'Request for Password Reset',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }

  void resetPassword(String email) async {
    var url =
        "${AppConstant.BASE_URL}/users/request-password-reset/";
    var urlParse = Uri.parse(url);
    http.Response response = await http.post(urlParse, body: {
      "email": emailController.text,
    });
    var data = jsonDecode(response.body.toString());
    log(data.toString());

    if (data['success'].toString() == "true") {
      setState(() {
        showProgressDialog(context, false);
        setState(() {
          Navigator.push(context, 
          MaterialPageRoute(builder: (context) => const LoginView()));
        });
        const snackdemo = SnackBar(
          content: Text(
            "Successfully Sent Password Reset Link",
            style: TextStyle(
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
      log("true");
    } else if (data['message'].toString().isNotEmpty) {
      setState(() {
        showProgressDialog(context, false);
        final snackdemo = SnackBar(
          content: Text(
            data['message'].toString().capitalize(),
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
      });
      log("false");
    } else if (data['message'].toString().isEmpty) {
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
      log("false");
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

