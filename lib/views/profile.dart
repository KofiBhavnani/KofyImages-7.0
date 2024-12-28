import 'package:flutter/material.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/deleteprofile.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/updateprofile.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with OrientationMixin{
  ScrollController scrollController = ScrollController();
  bool showbtn = false;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
    getCred();
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
                                  " User Profile",
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
                            "User Profile",
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
                            "Update or Delete User Profile",
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
                                    readOnly: true,
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
                                      hintText: "First Name",
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
                                    readOnly: true,
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
                                      hintText: "Last Name",
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
                                    readOnly: true,
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
                                    readOnly: true,
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UpdateProfile()));
                                  },
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, left: 25, right: 25),
                                    child: Container(
                                        height: 60,
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                  onTap: () async {
                                         Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const DeleteProfile()));
                                  },
                                ),
                                GestureDetector(
                                  child: const Padding(
                                      padding: EdgeInsets.only(
                                          top: 50, left: 25, right: 25),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Back to Explore Cities",
                                          style: TextStyle(
                                            color: Colors.black,
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
                                            builder: (context) => const HomeView()));
                                  },
                                ),
                              ]))))
                ])));
  }

}
