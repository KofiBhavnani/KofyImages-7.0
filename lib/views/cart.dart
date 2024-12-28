import 'dart:convert';
import 'dart:developer';
// ignore: library_prefixes
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kofyimages/cart_model.dart';
import 'package:kofyimages/constants.dart';
import 'package:kofyimages/db_helper.dart';
import 'package:kofyimages/views/home.dart';
import 'package:kofyimages/views/login.dart';
import 'package:kofyimages/views/widgets/appBar.dart';
import 'package:kofyimages/views/widgets/cart_card.dart';
import 'package:kofyimages/views/widgets/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cart_provider.dart';
import '../orientation_mixin.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> with OrientationMixin {
  DBHelper dbHelper = DBHelper();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    lockPortrait();
  }

  void postCart() async {
    SharedPreferences Authprefs = await SharedPreferences.getInstance();
    var tokenId = Authprefs.getString("token");

    if (tokenId == null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginView()));
      log("User not Logged In");
    } else {
      var url = "${AppConstant.BASE_URL}/orders/";
      final cartItems = await DBHelper().getCartList();
      final orders = cartItems
          .map((cartItem) => {
                "product_id": cartItem.productId,
                "quantity": cartItem.quantity,
                "color": cartItem.productColor,
              })
          .toList();
      var data = {"orders": orders};
      var bodyy = json.encode(data);
      var urlParse = Uri.parse(url);

      http.Response response = await http.post(urlParse, body: bodyy, headers: {
        "Content-Type": "application/json",
        "Authorization": tokenId.toString()
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        final Uri url = Uri.parse(data['payment_url'].toString());
        if (!await launchUrl(url)) {
          throw 'Could not launch $url';
        }
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == 400) {
        const text = 'Error. Please Try Again';
        log(response.body);
      }

      //log(response.body);
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
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 0, 0, 0),
                    boxShadow: [
                      // BoxShadow(
                      //   color: Colors.black12,
                      //   blurRadius: 2.0,
                      // ),
                    ]),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Container(
                          height: 80.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 30.0),
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
                                                  builder: (context) =>
                                                      const HomeView()));
                                        },
                                      ),
                                      const Text(
                                        " Shopping Cart",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
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
                      )
                    ]),
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<CartProvider>(builder: (context, value, child) {
                return Visibility(
                    visible: value.getTotalPrice().toString() == "0.0"
                        ? false
                        : true,
                    child: Column(children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height,
                          width: 900,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(20),
                                  width: 1000,
                                  height: 2,
                                  color: Colors.black,
                                  child: const FlutterLogo(
                                    size: 60.0,
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                //ROW 1
                                children: const [
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
                                        "ITEM",
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
                                        "QUANTITY",
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
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                width: 1000,
                                height: 2,
                                color: Colors.black,
                                child: const FlutterLogo(
                                  size: 60.0,
                                ),
                              ),
                              FutureBuilder(
                                future: cart.getData(),
                                builder: ((context,
                                    AsyncSnapshot<List<Cart>> snapshot) {
                                  if (snapshot.hasData) {
                                    return Flexible(
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            //physics: NeverScrollableScrollPhysics(),
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: ((context, index) {
                                              return CartCard(
                                                  id: snapshot.data![index].id,
                                                  productId: snapshot
                                                      .data![index].productId,
                                                  price: int.parse(snapshot
                                                      .data![index]
                                                      .productPrice),
                                                  quantity: snapshot
                                                      .data![index].quantity,
                                                  color: snapshot
                                                      .data![index].productColor
                                                      .toString(),
                                                  size: snapshot
                                                      .data![index].productSize,
                                                  image: snapshot.data![index]
                                                      .productImage,
                                                  subtotal: int.parse(snapshot
                                                      .data![index]
                                                      .productSubtotal),
                                                  total: int.parse(snapshot
                                                      .data![index]
                                                      .productTotalPrice));
                                            })));
                                  }
                                  return const Text("");
                                }),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, top: 10),
                                      child: Container(
                                          height: 60,
                                          width: 170,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text(
                                                  'Clear Cart',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "Montserrat",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ), // <-- Text
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  // <-- Icon
                                                  Icons
                                                      .remove_shopping_cart_sharp,
                                                  size: 24.0,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                    onTap: () {
                                      dbHelper.deleteAll();
                                      cart.clearall();
                                      cart.clearallamount();
                                    },
                                  ),
                                ],
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 600, top: 10),
                                  child: Container(
                                      height: 60,
                                      width: 250,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text(
                                              'Continue Shopping',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18),
                                            ), // <-- Text
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              // <-- Icon
                                              Icons.shopping_cart,
                                              size: 24.0,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              Container(
                                  padding: const EdgeInsets.only(
                                      right: 500, top: 30),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Text(
                                          'Cart Summary',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 25,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Cart Total",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20),
                                            ),
                                            const SizedBox(width: 50),
                                            Consumer<CartProvider>(builder:
                                                (context, value, child) {
                                              return Text(
                                                "£${value.getTotalPrice()}",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "Montserrat",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20),
                                              );
                                            }),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
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
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.black),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(15),
                                                            side: const BorderSide(color: Colors.black)))),
                                                onPressed: () async {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  postCart();
                                                },
                                                child: (isLoading)
                                                    ? const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 3,
                                                        ))
                                                    : const Text(
                                                        'Proceed To CheckOut',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18),
                                                      )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ]));
              }),
              Consumer<CartProvider>(builder: (context, value, child) {
                return Visibility(
                  visible:
                      value.getTotalPrice().toString() == "0.0" ? true : false,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(boxShadow: [
                            // BoxShadow(
                            //   color: Colors.black12,
                            //   blurRadius: 2.0,
                            // ),
                          ]),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Column(
                                  children: <Widget>[
                                Image.asset(
                                  'assets/empty.png',
                                  height: 350,
                                  width: 300,
                                ),
                                const Text(
                                  "Your Cart is empty!",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Explore our cities and shop for different frames.",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30),
                                GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: Container(
                                        height: 60,
                                        width: 200,
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Explore Cities',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                        )),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeView()));
                                  },
                                ),
                                //SizedBox(height: 40),
                                  ],
                                ))
                              ]),
                        ),
                      ]),
                );
              }),
            ])));
  }
}
