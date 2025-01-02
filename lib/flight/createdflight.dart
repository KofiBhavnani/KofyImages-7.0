import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:kofyimages/views/home.dart';

class OrderedFlight extends StatefulWidget {
  String image;
  String order;
  String booking;
  OrderedFlight({super.key, required this.image, required this.order, required this.booking});

  @override
  State<OrderedFlight> createState() => _OrderedFlightState();
}

class _OrderedFlightState extends State<OrderedFlight> with OrientationMixin{


    @override
   void initState() {
    super.initState();
    lockPortrait();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.image),
                  fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  stops: const [0.0, 0.4],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Booked Flight',
                            style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Align(
              alignment: Alignment.center,
              child: Text(
                "Congrats, you've created a Flight Order!",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
                textAlign: TextAlign.center,
              )),
          const AvatarGlow(
            glowColor: Colors.green,
            endRadius: 90.0,
            duration: Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: Duration(milliseconds: 100),
            child: Material(
              // Replace this child with your own
              shape: CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 40.0,
                child: Icon(
                  Icons.check,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),   
                    const Align(
              alignment: Alignment.center,
              child: Text(
                "Flight Order Created",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
                textAlign: TextAlign.center,
              )),
                 const SizedBox(
            height: 15,
          ),

                        const Align(
              alignment: Alignment.center,
              child: Text(
                "Booking Refrence",
                style: TextStyle(
                    color: Colors.black45,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                textAlign: TextAlign.center,
              )), 
              const SizedBox(height: 10,),
                                      Container(
                                        color: const Color.fromARGB(48, 158, 158, 158),
                                        width:150,
                                        height: 40,
                                        child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      widget.booking,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: "Montserrat",
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 20),
                                                      textAlign: TextAlign.center,
                                                    )),
                                      ),
const SizedBox(
  width: 300,
  height: 25,
  child:   Divider(
  ),
),
                                      const Align(
              alignment: Alignment.center,
              child: Text(
                "Order Number",
                style: TextStyle(
                    color: Colors.black45,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                textAlign: TextAlign.center,
              )),   const SizedBox(
            height: 10,
          ),

                        Align(
              alignment: Alignment.center,
              child: Text(
                widget.order,
                style: const TextStyle(
                    color: Colors.black54,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
                textAlign: TextAlign.center,
              )),
                 const SizedBox(
            height: 20,
          ),

          GestureDetector(
            onTap: () {
                                                             Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
      const HomeView()));
            },
            child: Container(
              height: 60.0,
              width: 350.0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: const Center(
                child: Text(
                  "Back to Explore",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Montserrat",
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 40,
          )
        ])));
  }
}
