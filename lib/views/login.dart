import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kofyimages/cart_provider.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/fogottenpass.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/register.dart';
import 'package:http/http.dart' as http;
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/sidebar.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with OrientationMixin {
  @override
  void initState() {
    lockPortrait();
    super.initState();
  }

  bool hidePassword = true;

  String errormsg = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  static showProgressDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  SimpleDialog(
              backgroundColor: Colors.white,
              children: <Widget>[
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
                      "Logging In...",
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
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: appBar(),
      ),
      drawer: const SideBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      height: 600,
                      width: 400,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(245, 240, 239, 239),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1.0,
                            ),
                          ]),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 40, 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    child: const Text(
                                      "X",
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontFamily: "Montserrat",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeView()));
                                    },
                                  )
                                ],
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "Log In",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 35,
                                      fontWeight: FontWeight.w700),
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
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please fill in this field";
                                  }
                                  return null;
                                },
                                obscureText: hidePassword,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.black)),
                                  fillColor:
                                      const Color.fromARGB(255, 245, 245, 245),
                                  filled: true,
                                  hintText: "Enter Your Password",
                                  hintStyle:
                                      const TextStyle(fontFamily: 'Montserrat'),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 40, 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    child: const Text(
                                      "Forgot Password ?",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: "Montserrat",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgottenPassword()));
                                    },
                                  )
                                ],
                              ),
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
                                            "Email Address invalid: ('@' is missing)",
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
                                      } else if (passwordController
                                          .text.isEmpty) {
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
                                      } else {
                                        showProgressDialog(context, true);
                                        login(
                                          emailController.toString(),
                                          passwordController.toString(),
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                GestureDetector(
                                  child: const Text(
                                    " Create Account",
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
                                            builder: (context) =>
                                                const RegisterView()));
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(String email, String password) async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    try {
      http.Response response = await http
          .post(Uri.parse('${AppConstant.BASE_URL}/users/login/'), body: {
        "email": emailController.text,
        "password": passwordController.text,
      });
      if (response.statusCode == 200 &&
          Authprefs.getString("type").toString() == "videos") {
        var data = jsonDecode(response.body.toString());
        SharedPreferences Authprefs = await SharedPreferences.getInstance();
        await Authprefs.setString("token", data['token']);
        await Authprefs.setString("name", data['first_name']);
        await Authprefs.setString("id", data['user_id']);
        await Authprefs.setString("last", data['last_name']);
        await Authprefs.setString("email", data['email']);
        await Authprefs.setString("phone", data['phone']);
        var text = Authprefs.getString("name");
        var text2 = Authprefs.getString("last");
        print(text);
        // ignore: use_build_context_synchronously
        emailController.clear();
        passwordController.clear();
        setState(() {
          showProgressDialog(context, false);
          final snackdemo = SnackBar(
            content: Text(
              "Welcome! $text $text2 👋",
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackdemo);
        });
        await Authprefs.remove("type");
      } else if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        SharedPreferences Authprefs = await SharedPreferences.getInstance();
        await Authprefs.setString("token", data['token']);
        await Authprefs.setString("name", data['first_name']);
        await Authprefs.setString("id", data['user_id']);
        await Authprefs.setString("last", data['last_name']);
        await Authprefs.setString("email", data['email']);
        await Authprefs.setString("phone", data['phone']);
        var text = Authprefs.getString("name");
        var text2 = Authprefs.getString("last");
        print(text);
        // ignore: use_build_context_synchronously
        emailController.clear();
        passwordController.clear();
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeView()));
          final snackdemo = SnackBar(
            content: Text(
              "Welcome! $text $text2 👋",
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackdemo);
        });
      } else if (response.statusCode == 400) {
        var data = jsonDecode(response.body.toString());
        print(data);
        setState(() {
          showProgressDialog(context, false);
          const snackdemo = SnackBar(
            content: Text(
              "Invalid email or password",
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
          //errormsg = data['non_field_errors'].toString();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
