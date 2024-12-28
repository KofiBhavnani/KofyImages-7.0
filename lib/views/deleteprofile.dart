import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteProfile extends StatefulWidget {
  const DeleteProfile({super.key});

  @override
  State<DeleteProfile> createState() => _DeleteProfileState();
}

class _DeleteProfileState extends State<DeleteProfile> with OrientationMixin {
  @override
  void initState() {
    lockPortrait();
  }

  TextEditingController confirmpasswordController = TextEditingController();

  void clearpref() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    await Authprefs.remove("name");
    await Authprefs.remove("last");
    await Authprefs.remove("email");
    await Authprefs.remove("token");
    await Authprefs.remove("id");
  }

  bool hidePassword = true;
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
                  "Deleting Account...",
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
                  "Your session has expired. You must sign in again.",
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
                GestureDetector(
                  child: const Text(
                    "LogIn",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
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
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
       appBar: const PreferredSize(
    preferredSize: Size.fromHeight(60),
    child: appBar(),
  ),
        drawer: const SideBar(), //show/hide animation
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                              " Delete User Profile",
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
                  padding: EdgeInsets.only(top: 15),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Delete Profile",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ))),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Container(
                      height: 700,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Form(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Once you delete this account, there is no going back. Please be certain! ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                  textAlign: TextAlign.center,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: RichText(
                                    text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                      TextSpan(text: 'Type '),
                                      TextSpan(
                                          text: "your password",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red,
                                              fontStyle: FontStyle.italic)),
                                      TextSpan(
                                          text: ' in the box below to confirm'),
                                    ]))),
                            const SizedBox(
                              height: 15,
                            ),
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
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.black)),
                                  fillColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  filled: true,
                                  hintText: "Enter Your Account Password",
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
                            GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, left: 25, right: 25),
                                  child: Container(
                                      height: 60,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Delete User Account",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                      )),
                                ),
                                onTap: () {
                                  if (confirmpasswordController.text.isEmpty) {
                                    const snackdemo = SnackBar(
                                      content: Text(
                                        "Account Password is Required!",
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
                                    deleteUser();
                                    showProgressDialog(context, true);
                                  }
                                }),
                            GestureDetector(
                              child: const Padding(
                                  padding: EdgeInsets.only(
                                      top: 50, left: 25, right: 25),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Back to User Profile",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ]))))
            ])));
  }

  Future<void> deleteUser() async {
    try {
      SharedPreferences Authprefs = await SharedPreferences.getInstance();
      http.Response response = await http.delete(
          Uri.parse(
              '${AppConstant.BASE_URL}/users/${Authprefs.getString("id").toString()}/'),
          headers: {
            'Authorization': Authprefs.getString("token").toString(),
          },
          body: {
            "password": confirmpasswordController.text
          });
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        Authprefs.remove("token").toString();
        setState(() {
          showProgressDialog(context, false);
          clearpref();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeView()));
          const snackdemo = SnackBar(
            content: Text(
              "Successfully Deleted User Account",
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
          confirmpasswordController.clear();
        });
      } else if (response.statusCode == 400) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          showProgressDialog(context, false);
          const snackdemo = SnackBar(
            content: Text(
              "Invalid Password! ",
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
      } else if (response.statusCode == 401) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          showProgressDialog(context, false);
          showSessionDialog(context);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
