import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kofyimages/events/events.dart';
import 'package:kofyimages/orientation_mixin.dart';

class EventSplash extends StatefulWidget {
  const EventSplash({super.key});

  @override
  State<EventSplash> createState() => _EventSplashState();
}

class _EventSplashState extends State<EventSplash> with OrientationMixin {


   @override
  void initState() {
    super.initState();
    _loading();
    lockPortrait();
  }

  Future<void> _loading() async {
    Timer(const Duration(milliseconds: 1000), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) =>  const UpComingEvents()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          child: Image.asset("assets/events.png"),
        ),
      ),
    );
  }
}