import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/footer.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsView();
}

final nameController = TextEditingController();
final emailController = TextEditingController();
final messageController = TextEditingController();
final subjectController = TextEditingController();

class _ContactUsView extends State<ContactUsView> with OrientationMixin {
  bool isLoading = false;

  @override
  void initState() {
    lockPortrait();
  }

  static showProgressDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(backgroundColor: Colors.white, children: <Widget>[
            Center(
              child: Column(children: const [
                SpinKitCircle(
                  color: Colors.black,
                  size: 40.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Submitting Form...",
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 650,
                width: 400,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(236, 241, 241, 241),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2.0,
                      ),
                    ]),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Contact Us",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 35,
                                fontWeight: FontWeight.w700),
                          )),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
                            hintText: "Full Name",
                            hintStyle:
                                const TextStyle(fontFamily: 'Montserrat'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
                            hintText: " Email Address",
                            hintStyle:
                                const TextStyle(fontFamily: 'Montserrat'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          controller: subjectController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
                            hintText: "Subject",
                            hintStyle:
                                const TextStyle(fontFamily: 'Montserrat'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          controller: messageController,
                          maxLines: 7,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
                            hintText: "Message",
                            hintStyle:
                                const TextStyle(fontFamily: 'Montserrat'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 40, 20),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                              height: 70,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              )),
                        ),
                        onTap: () async {
                          if (nameController.text.isEmpty) {
                            const snackdemo = SnackBar(
                              content: Text(
                                "Full Name is Required!",
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
                          } else if (subjectController.text.isEmpty) {
                            const snackdemo = SnackBar(
                              content: Text(
                                "Subject is Required!",
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
                          } else if (messageController.text.isEmpty) {
                            const snackdemo = SnackBar(
                              content: Text(
                                "Message is Required!",
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
                              'Name': nameController.text,
                              'Email': emailController.text,
                              'Subject': subjectController.text,
                              'Message': messageController.text,
                            };
                            showProgressDialog(context, true);
                            try {
                              await EmailJS.send(
                                'service_pgywu8s',
                                'template_igc72ri',
                                templateParams,
                                const Options(
                                  publicKey: 'YOjym2Spg4YOheCI2',
                                  privateKey: 'LHrmn-W3Eztv3KMK_uYry',
                                ),
                              );
                              showProgressDialog(context, false);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeView()));
                              const snackdemo = SnackBar(
                                  content: Text(
                                    "Thank you for Contacting Us.",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Colors.green);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackdemo);
                            } catch (error) {
                              print(error);
                              showProgressDialog(context, false);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeView()));
                              const snackdemo = SnackBar(
                                content: Text(
                                  "Error.Kindly try again.",
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
                            }
                            emailController.clear();
                            nameController.clear();
                            messageController.clear();
                            subjectController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )),
          const Footer()
        ]),
      ),
    );
  }
}
