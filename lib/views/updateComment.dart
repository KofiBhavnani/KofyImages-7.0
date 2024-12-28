import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/comments.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateComment extends StatefulWidget {
  String id;
  String content;
  String exhibition;
  UpdateComment(
      {super.key,
      required this.id,
      required this.content,
      required this.exhibition});

  @override
  State<UpdateComment> createState() => _UpdateCommentState();
}

class _UpdateCommentState extends State<UpdateComment> with OrientationMixin {
  String selectedImagePath = '';

  void clearpref() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    await Authprefs.remove("name");
    await Authprefs.remove("last");
    await Authprefs.remove("email");
    await Authprefs.remove("token");
    await Authprefs.remove("id");
  }

  final spinkit = const SpinKitFadingCircle(
    color: Colors.black,
    size: 40.0,
  );

  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  Future selectImage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: SizedBox(
              height: 190,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text(
                      'Select Image ',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            selectedImagePath = await selectImageFromGallery();
                            print('Image_Path:-');
                            print(selectedImagePath);
                            if (selectedImagePath != '') {
                              Navigator.pop(context);
                              setState(() {});
                            } else {
                              const snackdemo = SnackBar(
                                content: Text(
                                  "No Image Selected!",
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
                          },
                          child: Card(
                              elevation: 1,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.image_search, size: 60),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      ' From Gallery',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            selectedImagePath = await selectImageFromCamera();
                            print('Image_Path:-');
                            print(selectedImagePath);

                            if (selectedImagePath != '') {
                              Navigator.pop(context);
                              setState(() {});
                            } else {
                              const snackdemo = SnackBar(
                                content: Text(
                                  "No Image Captured!",
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
                          },
                          child:Card(
                              elevation: 1,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.camera, size: 60),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      ' From Camera',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    commentController.text = widget.content.toString();
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

  bool showbtn = false;
  ScrollController scrollController = ScrollController();
  TextEditingController commentController = TextEditingController();

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
                  duration:
                      const Duration(milliseconds: 500), //duration of scroll
                  curve: Curves.fastOutSlowIn //scroll type
                  );
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.arrow_upward),
          )),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            height: 80.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.0), color: Colors.black),
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
                                    builder: (context) => const HomeView()));
                          },
                        ),
                        const Text(
                          " Update Comments",
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
                    "Update Comments",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ))),
          const Align(
              alignment: Alignment.center,
              child: Text(
                "Update a Comment about a Video",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              )),
          Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Container(
                height: 600,
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
                          controller: commentController,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
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
                            hintText: "Write  a Comment",
                            hintStyle:
                                const TextStyle(fontFamily: 'Montserrat'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      Container(
                        width: 500,
                        color: const Color.fromARGB(66, 210, 209, 209),
                        child: Column(
                          children: [
                            selectedImagePath == ''
                                ? const Text(
                                    'Attach a GIF Image',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  )
                                : Image.file(
                                    File(selectedImagePath),
                                    height: 200,
                                    width: null,
                                    fit: BoxFit.contain,
                                  ),
                          ],
                        ),
                      ),
                      GestureDetector(
                          child: const Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: Center(
                              child: Text(
                                'Choose a GIF Image',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          onTap: () async {
                            selectImage();
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 40, 10),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                              height: 60,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Update Comment',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              )),
                        ),
                        onTap: () async {
                          if (commentController.text.isEmpty) {
                            const snackdemo = SnackBar(
                              content: Text(
                                "Comment is Required!",
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
                          } else if (selectedImagePath != "") {
                            showProgressDialog(context, true);
                            postDataWithImage();
                          } else if (selectedImagePath == "") {
                            showProgressDialog(context, true);
                            submitComment();
                          }
                        },
                      ),
                      GestureDetector(
                        child: const Padding(
                            padding:
                                EdgeInsets.only(top: 30, left: 25, right: 25),
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
                                  builder: (context) => Comments(
                                        id: widget.id,
                                      )));
                        },
                      ),
                    ],
                  ),
                ),
              )),
        ]),
      ),
    );
  }

  void postDataWithImage() async {
    var url =
        "${AppConstant.BASE_URL}/comments/${widget.id}/"; // Replace with your actual endpoint URL

    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.headers['Authorization'] = Authprefs.getString("token").toString();

    request.fields['content'] = commentController.text;

    var imageFile = File(selectedImagePath);
    var imageStream = http.ByteStream(imageFile.openRead());
    var imageLength = await imageFile.length();

    var multipartFile = http.MultipartFile(
      'image',
      imageStream,
      imageLength,
      filename: 'image.jpg',
    );

    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      // Request successful
      setState(() {
        showProgressDialog(context, false);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Comments(id: widget.id)));
        const snackdemo = SnackBar(
          content: Text(
            "Comment Successfully Added!",
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
        //errormsg = data['non_field_errors'].toString();
      });
    } else if (response.statusCode == 401) {
      // Request failed
      showProgressDialog(context, false);
      showSessionDialog(context);
    } else {
      setState(() {
        print(response.statusCode);
        showProgressDialog(context, false);
        const snackdemo = SnackBar(
          content: Text(
            "Could not Add Comment. Kindly try again! ",
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
  }

  Future<void> submitComment() async {
    try {
      SharedPreferences Authprefs = await SharedPreferences.getInstance();
      http.Response response = await http.put(
          Uri.parse('${AppConstant.BASE_URL}/comments/${widget.id}/'),
          headers: {
            'Authorization': Authprefs.getString("token").toString(),
          },
          body: {
            "content": commentController.text,
          });
      print(response.body);

      if (response.statusCode == 400) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          showProgressDialog(context, false);
          const snackdemo = SnackBar(
            content: Text(
              "Could not Add Comment. Kindly try again! ",
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
      } else if (response.statusCode == 401) {
        var data = jsonDecode(response.body.toString());
        showProgressDialog(context, false);
        showSessionDialog(context);
      } else {
        var data = jsonDecode(response.body.toString());
        setState(() {
          showProgressDialog(context, false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Comments(id: widget.id)));
          const snackdemo = SnackBar(
            content: Text(
              "Comment Successfully Updated!",
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
          //errormsg = data['non_field_errors'].toString();
        });
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  static showProgressDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
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
                      "Updating Comment...",
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
}
