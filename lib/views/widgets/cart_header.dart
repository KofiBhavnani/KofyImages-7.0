import 'package:flutter/material.dart';


class Cartheader extends StatefulWidget {
  const Cartheader({super.key});

  @override
  State<Cartheader> createState() => _CartheaderState();
}

class _CartheaderState extends State<Cartheader> {
 @override
  Widget build(BuildContext context) {
    return Row(
      //ROW 1
      children: [
        SizedBox(
          width: 104,
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "REMOVE",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "FRAME",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "PRICE",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "QUATITY",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "COLOR",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "SIZE",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 110,
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "SUBTOTAL",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}

 