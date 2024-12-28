import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/weather/ui/home_page.dart';
import 'package:location/location.dart';
import '../components/location_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    locationService();
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
            width: null,
            height: 270,
            child: Column(
              children: [
                const Icon(
                  Icons.my_location,
                  size: 30,
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  "Turn On Location",
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
                Image.asset(
                  "assets/location.gif",
                  height: 100.0,
                  width: 350.0,
                ),
                const Text(
                  "Go to Settings → Privacy & Security → Location Services",
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        child: Container(
                          child: const Center(
                            child: Text(
                              "Dismiss",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeView()));
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 70,
                    ),
                    GestureDetector(
                      child: const SizedBox(
                        width: 100,
                        height: 40,
                        child: Center(
                          child: Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      onTap: () {
                        AppSettings.openLocationSettings();
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> locationService() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionLocation;
    LocationData locData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        showSessionDialog(context);
      }
    }

    permissionLocation = await location.hasPermission();
    if (permissionLocation == PermissionStatus.denied) {
      permissionLocation = await location.requestPermission();
      if (permissionLocation != PermissionStatus.granted) {
        showSessionDialog(context);
      }
    }

    locData = await location.getLocation();

    setState(() {
      UserLocation.lat = locData.latitude!;
      UserLocation.long = locData.longitude!;
    });

    Timer(const Duration(milliseconds: 600), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WeatherHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          child: Image.asset("assets/weather.png"),
        ),
      ),
    );
  }
}
