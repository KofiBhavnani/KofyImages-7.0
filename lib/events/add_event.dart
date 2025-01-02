import 'dart:io';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as Badge;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kofyimages/cart_provider.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/events/events.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/cart.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Destination {
  final String id;
  final String name;
  final String country;

  Destination(this.id, this.name, this.country);
}

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> with OrientationMixin {
  bool showbtn = false;
  ScrollController scrollController = ScrollController();
  String? globalCityId;
  String? globalCityName;
  String? globalCountry;
  TextEditingController eventnameController = TextEditingController();
  TextEditingController eventcityController = TextEditingController();
  TextEditingController eventcountryController = TextEditingController();
  TextEditingController eventlocController = TextEditingController();
  TextEditingController eventdescController = TextEditingController();
  TextEditingController eventdateController = TextEditingController();
  TextEditingController eventtimeController = TextEditingController();

  String selectedImagePath = '';

  selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  //
  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
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
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: const [
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
                          child: Card(
                              elevation: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: const [
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
    setState(() {
      lockPortrait();
      eventdateController.text = "yyyy-mm-dd";
      eventtimeController.text = "00:00";
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
    });
    super.initState();
  }

  showProgressDialog(BuildContext context, bool isLoading) {
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
                  "Adding Upcoming Event...",
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
    TimeOfDay selectedTime = TimeOfDay.now();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: InkWell(
              child: Image.asset(
                "assets/home.jpeg",
                height: 100.0,
                width: 100.0,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomeView()));
              },
            ),
            actions: [
              Consumer<CartProvider>(builder: (context, value, child) {
                return Visibility(
                  visible: value.getCounter().toString() == "0" ? false : true,
                  child: Center(
                    child: Badge.Badge(
                      badgeContent: Consumer<CartProvider>(
                          builder: (context, value, child) {
                        return Text(value.getCounter().toString(),
                            style: const TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500));
                      }),
                      badgeColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      child: IconButton(
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartView()));
                          }),
                    ),
                  ),
                );
              }),
              Consumer<CartProvider>(builder: (context, value, child) {
                return Visibility(
                  visible: value.getCounter().toString() == "0" ? true : false,
                  child: Center(
                    child: IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartView()));
                        }),
                  ),
                );
              }),
              const SizedBox(
                width: 7,
              ),
              Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
            ]),
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                              "Events  >",
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
                                          const UpComingEvents()));
                            },
                          ),
                          const Text(
                            " Add Upcoming Event ",
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
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Upcoming Event",
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ))),
            const Align(
                alignment: Alignment.center,
                child: Text(
                  "Add an Upcoming Event",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                )),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Container(
                  height: 1200,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            controller: eventnameController,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.event,
                                color: Colors.black,
                              ),
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
                              hintText: "Event Name",
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
                            controller: eventcityController,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.event,
                                color: Colors.black,
                              ),
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
                              hintText: "Event City",
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
                            controller: eventcountryController,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.event,
                                color: Colors.black,
                              ),
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
                              hintText: "Event Country",
                              hintStyle:
                                  const TextStyle(fontFamily: 'Montserrat'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            controller: eventlocController,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.location_on,
                                color: Colors.black,
                              ),
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
                              hintText: "Event Location",
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
                            maxLines: 7,
                            controller: eventdescController,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
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
                              hintText: "Event Description",
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
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              controller: eventdateController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    )),
                                labelText: "Event Date",
                                labelStyle: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2010),
                                  lastDate: DateTime(5090),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Colors.black, // <-- SEE HERE
                                          onPrimary:
                                              Colors.white, // <-- SEE HERE
                                          onSurface:
                                              Colors.black, // <-- SEE HERE
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors
                                                .black, // button text color
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (pickedDate != null) {
                                  //print(pickedDate);
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  //print(formattedDate); //formatted date output using intl package =>  2022-07-04
                                  //You can format date as per your need

                                  setState(() {
                                    eventdateController.text = formattedDate;
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              }),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              controller: eventtimeController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.watch,
                                  color: Colors.black,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.black,
                                )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    )),
                                labelText: "Event Time",
                                labelStyle: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                final TimeOfDay? timeOfDay =
                                    await showTimePicker(
                                        context: context,
                                        initialTime: selectedTime,
                                        initialEntryMode:
                                            TimePickerEntryMode.dial);

                                if (timeOfDay != null) {
                                  //print(timeOfDay);
                                  String newtimeString =
                                      // ignore: use_build_context_synchronously
                                      timeOfDay.format(context);

                                  setState(() {
                                    eventtimeController.text = newtimeString;
                                  });
                                } else {
                                  print("date is not picked");
                                }
                              }),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 500,
                          color: const Color.fromARGB(66, 210, 209, 209),
                          child: Column(
                            children: [
                              selectedImagePath == ''
                                  ? const Text(
                                      'Upload an Event Image',
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
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Container(
                                  height: 60,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Select Event Image',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                  )),
                            ),
                            onTap: () async {
                              selectImage();
                            }),
                        const Divider(),
                        GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Container(
                                  height: 60,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Add Upcoming Event',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  )),
                            ),
                            onTap: () async {
                              if (eventnameController.text.isEmpty) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Event Name is Required!",
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
                              } else if (eventcityController.text.isEmpty) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Event City is Required!",
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
                              } else if (eventcountryController.text.isEmpty) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Event Country is Required!",
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
                              } else if (eventlocController.text.isEmpty) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Event Location is Required!",
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
                              } else if (eventdescController.text.isEmpty) {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Event Description is Required!",
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
                              } else if (eventdateController.text ==
                                  "yyyy-mm-dd") {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Event Date is Required!",
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
                              } else if (eventtimeController.text == "00:00") {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Event Time is Required!",
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
                              } else if (selectedImagePath == "") {
                                const snackdemo = SnackBar(
                                  content: Text(
                                    "Event Image is Required!",
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
                                postData();
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                )),
          ]),
        ));
  }

  void postData() async {
    const url =
        "${AppConstant.BASE_URL}/events/"; // Replace with your actual endpoint URL

    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = Authprefs.getString("token").toString();

    request.fields['name'] = eventnameController.text;
    request.fields['city'] = eventcityController.text;
    request.fields['country'] = eventcountryController.text;
    request.fields['location'] = eventlocController.text;
    request.fields['description'] = eventdescController.text;
    request.fields['date'] = eventdateController.text;
    request.fields['time'] = eventtimeController.text;

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
    if (response.statusCode == 201) {
      // Request successful
      //print('POST request successful');
      setState(() {
        showProgressDialog(context, false);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UpComingEvents()));
        const snackdemo = SnackBar(
          content: Text(
            "Upcoming Event Successfully Added!",
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
    } else {
      // print(response);
      // Request failed
      //print('POST request failed with status code: ${response.statusCode}');
      setState(() {
        showProgressDialog(context, false);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UpComingEvents()));
        const snackdemo = SnackBar(
          content: Text(
            "Could not Add Upcoming Event. Kindly try again! ",
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
}
