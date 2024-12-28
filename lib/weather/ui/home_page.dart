import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/weather/components/location_service.dart';
import 'package:kofyimages/weather/components/weather_item.dart';
import 'package:kofyimages/weather/constants.dart';
import 'package:kofyimages/weather/ui/detail_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _cityController = TextEditingController();
  final Constants _constants = Constants();

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  static String API_KEY = 'ba872f13ffbb4f66809121646230707';

  Future<void> getLocation() async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(UserLocation.lat, UserLocation.long);
    print(placemark[0].locality);
    setState(() {
      location = placemark[0].locality.toString();
      fetchWeatherData(location);
    });
  }

  String location = "";
  String weatherIcon = 'heavycloudy.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';
  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];
  String currentWeatherStatus = '';

  //API Call
  String searchWeatherAPI =
      "https://api.weatherapi.com/v1/forecast.json?key=$API_KEY&days=7&q="; //Default location
  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');
         //print(weatherData);

      var locationData = weatherData["location"];
      var currentWeather = weatherData["current"];

      setState(() {
        location = getShortLocationName(locationData["name"]);

        var parsedDate =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;

        //updateWeather
        currentWeatherStatus = currentWeather["condition"]["text"];
        weatherIcon ="${currentWeatherStatus.replaceAll(' ', '').toLowerCase()}.png";
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();

        //Forecast data
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        //print(dailyWeatherForecast);
      });
    } catch (e) {
      //debugPrint(e);
    }
  }

  //function to return the first two names of the string location
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return "${wordList[0]} ${wordList[1]}";
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
              appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
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
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(" Back",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                ])),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: 800,
          padding: const EdgeInsets.only( left: 10, right: 10),
          color: _constants.primaryColor.withOpacity(.1),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  height: 550,
                  decoration: BoxDecoration(
                    gradient: _constants.linearGradientBlue,
                    boxShadow: [
                      BoxShadow(
                        color: _constants.primaryColor.withOpacity(.5),
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/pin.png",
                                width: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                location,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Montserrat"),
                              ),
                              IconButton(
                                onPressed: () {
                                  _cityController.clear();
                                  showMaterialModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          SingleChildScrollView(
                                            controller:
                                                ModalScrollController.of(
                                                    context),
                                            child: Container(
                                              height: 450,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 10,
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: 70,
                                                    child: Divider(
                                                      thickness: 3.5,
                                                      color: _constants
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    onChanged: (searchText) {
                                                      fetchWeatherData(
                                                          searchText);
                                                    },
                                                    controller: _cityController,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                        prefixIcon: Icon(
                                                          Icons.search,
                                                          color: _constants
                                                              .primaryColor,
                                                        ),
                                                        suffixIcon:
                                                            GestureDetector(
                                                          onTap: () =>
                                                              _cityController
                                                                  .clear(),
                                                          child: Icon(
                                                            Icons.close,
                                                            color: _constants
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        hintText:
                                                            'Search city e.g. London',
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: _constants
                                                                .primaryColor,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                },
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 120,
                        child: Image.asset("assets/$weatherIcon"),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text(
                              temperature.toString(),
                              style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat",
                                foreground: Paint()..shader = _constants.shader,
                              ),
                            ),
                          ),
                          Text(
                            'o',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat",
                              foreground: Paint()..shader = _constants.shader,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        currentWeatherStatus,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontFamily: "Montserrat",
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        currentDate,
                        style: const TextStyle(
                            color: Colors.white70, fontFamily: "Montserrat"),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Divider(
                          color: Colors.white70,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WeatherItem(
                              value: windSpeed.toInt(),
                              unit: ' km/h',
                              imageUrl: 'assets/windspeed.png',
                            ),
                            WeatherItem(
                              value: humidity.toInt(),
                              unit: ' %',
                              imageUrl: 'assets/humidity.png',
                            ),
                            WeatherItem(
                              value: cloud.toInt(),
                              unit: ' %',
                              imageUrl: 'assets/cloud.png',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 30,
                  ),
                  height: null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Today',
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DetailPage(
                                          dailyForecastWeather:
                                              dailyWeatherForecast,
                                        ))), //this will open forecast screen
                            child: Text(
                              ' Show Forecasts',
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: _constants.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          itemCount: hourlyWeatherForecast.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            String currentTime =
                                DateFormat('HH:mm:ss').format(DateTime.now());
                            String currentHour = currentTime.substring(0, 2);

                            String forecastTime = hourlyWeatherForecast[index]
                                    ["time"]
                                .substring(11, 16);
                            String forecastHour = hourlyWeatherForecast[index]
                                    ["time"]
                                .substring(11, 13);

                            String forecastWeatherName =
                                hourlyWeatherForecast[index]["condition"]
                                    ["text"];
                            String forecastWeatherIcon = "${forecastWeatherName
                                    .replaceAll(' ', '')
                                    .toLowerCase()}.png";

                            String forecastTemperature =
                                hourlyWeatherForecast[index]["temp_c"]
                                    .round()
                                    .toString();
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              margin: const EdgeInsets.only(right: 20),
                              width: 65,
                              decoration: BoxDecoration(
                                  color: currentHour == forecastHour
                                      ? Colors.white
                                      : _constants.primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 5,
                                      color: _constants.primaryColor
                                          .withOpacity(.2),
                                    ),
                                  ]),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    forecastTime,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: _constants.greyColor,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/$forecastWeatherIcon',
                                    width: 20,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: forecastTemperature,
                                      style: TextStyle(
                                        color: _constants.greyColor,
                                        fontFamily: "Montserrat",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(0, -15),
                                            child: Text(
                                              'o',
                                              style: TextStyle(
                                                color: _constants.greyColor,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Montserrat",
                                                fontSize: 14,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
