import 'package:flutter/material.dart';
import 'package:kofyimages/cart_provider.dart';
import 'package:kofyimages/views/cart.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/login.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as Badge;
import 'package:shared_preferences/shared_preferences.dart';

class appBar extends StatelessWidget {
  const appBar({
    super.key,
  });


    void clearpref() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    await Authprefs.remove("name");
    await Authprefs.remove("last");
    await Authprefs.remove("email");
    await Authprefs.remove("token");
    await Authprefs.remove("id");
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
                  "Login Required",
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
                  "Please Login",
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
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                      child: const SizedBox(
                        width: 100,
                        height: 40,
                        child: Center(
                          child: Text(
                            "LogIn",
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
                      onTap: ()async {
                        Navigator.pop(context);
                        clearpref();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()));
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


  @override
  Widget build(BuildContext context) {
    return AppBar(
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HomeView()));
          },
        ),
        actions: [
          // Builder(builder: (context) {
          //   return GestureDetector(
          //     child: const AvatarGlow(
          //       glowColor: Colors.red,
          //       endRadius: 25.0,
          //       duration: Duration(milliseconds: 1000),
          //       repeat: true,
          //       showTwoGlows: true,
          //       child: Material(
          //         // Replace this child with your own
          //         shape: CircleBorder(),
          //         child: CircleAvatar(
          //           backgroundColor: Colors.red,
          //           radius: 18.0,
          //           child: Icon(
          //             Icons.auto_mode,
          //             size: 23,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ),
          //   );
          // }),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getCounter().toString() == "0" ? false : true,
              child: Center(
                child: Badge.Badge(
                  badgeContent:
                      Consumer<CartProvider>(builder: (context, value, child) {
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const CartView()));
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
        ]);
  }
}
