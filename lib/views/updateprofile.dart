import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/home.dart';
import 'package:http/http.dart' as http;
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/profile.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> with OrientationMixin {
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  bool hidePassword = true;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();

  void getCred() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    var text = Authprefs.getString("name");
    var text2 = Authprefs.getString("last");
    var email = Authprefs.getString("email");
    var phone = Authprefs.getString("phone");

    setState(() {
      firstnameController.text = text!;
      lastnameController.text = text2!;
      emailController.text = email!;
      phoneController.text = phone!;
    });
  }

  void clearpref() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    await Authprefs.remove("name");
    await Authprefs.remove("last");
    await Authprefs.remove("email");
    await Authprefs.remove("token");
    await Authprefs.remove("id");
  }

  @override
  void initState() {
    lockPortrait();
    getCred();

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
                  "Updating User Profile...",
                  style:  TextStyle(
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
                  style:  TextStyle(
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
                    "Dismiss",
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
        drawer: const SideBar(),
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
                                  " Update User Profile",
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
                            " User Profile",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ))),
                  const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Update User Profile",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
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
                                  height: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: firstnameController,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.black,
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.black,
                                          )),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.black,
                                      )),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "Username",
                                      hintStyle:
                                          const TextStyle(fontFamily: 'Montserrat'),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: lastnameController,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.black,
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.black,
                                          )),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.black,
                                      )),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "Username",
                                      hintStyle:
                                          const TextStyle(fontFamily: 'Montserrat'),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: emailController,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.black,
                                          )),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.black,
                                      )),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "Email",
                                      hintStyle:
                                          const TextStyle(fontFamily: 'Montserrat'),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: phoneController,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.phone,
                                        color: Colors.black,
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.black,
                                          )),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.black,
                                      )),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "Phone",
                                      hintStyle:
                                          const TextStyle(fontFamily: 'Montserrat'),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: oldpasswordController,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    obscureText: hidePassword,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.password_outlined,
                                        color: Colors.black,
                                      ),
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
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.black,
                                          )),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.black,
                                      )),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "Enter Old Password",
                                      hintStyle:
                                          const TextStyle(fontFamily: 'Montserrat'),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: newpasswordController,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    obscureText: hidePassword,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                      ),
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
                                      enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: Colors.black,
                                          )),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.black,
                                      )),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "Enter New Password",
                                      hintStyle:
                                          const TextStyle(fontFamily: 'Montserrat'),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 25, right: 25),
                                    child: Container(
                                        height: 60,
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Update User Account",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                        )),
                                  ),
                                  onTap: () async {
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
                                    } else if (lastnameController
                                        .text.isEmpty) {
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
                                    } else if (oldpasswordController
                                        .text.isEmpty) {
                                      const snackdemo = SnackBar(
                                        content: Text(
                                          "Old Password is Required!",
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
                                    } else if (newpasswordController
                                        .text.isEmpty) {
                                      const snackdemo = SnackBar(
                                        content: Text(
                                          "New Password is Required!",
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
                                    } else if (newpasswordController
                                            .text.length <
                                        8) {
                                      const snackdemo = SnackBar(
                                        content: Text(
                                          "New Password must be 8 or more than 8 characters",
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
                                      update();
                                    }
                                  },
                                ),
                                GestureDetector(
                                  child: const Padding(
                                      padding: EdgeInsets.only(
                                          top: 30, left: 25, right: 25),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                      )),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Profile()));
                                  },
                                ),
                              ]))))
                ])));
  }

  Future<void> update() async {
    try {
      SharedPreferences Authprefs = await SharedPreferences.getInstance();
      http.Response response = await http.put(
          Uri.parse(
              '${AppConstant.BASE_URL}/users/${Authprefs.getString("id").toString()}/'),
          headers: {
            'Authorization': Authprefs.getString("token").toString(),
          },
          body: {
            "first_name": firstnameController.text,
            "last_name": lastnameController.text,
            "email": emailController.text,
            "phone": phoneController.text,
            "old_password": oldpasswordController.text,
            "new_password": newpasswordController.text
          });
      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        SharedPreferences Authprefs = await SharedPreferences.getInstance();
        await Authprefs.setString("name", data['first_name']);
        await Authprefs.setString("last", data['last_name']);
        await Authprefs.setString("email", data['email']);
        await Authprefs.setString("phone", data['phone']);
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Profile()));
          const snackdemo = SnackBar(
            content: Text(
              "Successfully Updated User Profile",
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
      } else if (response.statusCode == 400) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          showProgressDialog(context, false);
          const snackdemo = SnackBar(
            content: Text(
              "Invalid Old Password! ",
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
