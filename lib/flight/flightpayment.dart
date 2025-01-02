import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kofyimages/flight/paymentCard.dart';
import 'package:kofyimages/orientation_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../constants.dart';


class FlightPayment extends StatefulWidget {
  String id;
  String image;
  String price;
  String currency;

  FlightPayment({super.key, required this.id, required this.image, required this.price, required this.currency});

  @override
  State<FlightPayment> createState() => _FlightPaymentState();
}

class _FlightPaymentState extends State<FlightPayment> with OrientationMixin{
  final Future<void> future = Future(() => null);

   late final WebViewController _controller;

 @override
  void initState() {
     lockPortrait();
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');

          },
          onPageStarted: (String url) {
             showUIDialog(context, true);
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
             showUIDialog(context, false);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
        ),
      )
      ..loadRequest(
          Uri.parse('https://payment-kofyimages.netlify.app/?token=${widget.id}'));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }


    static showUIDialog(BuildContext context, bool isLoading) {
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
                  "Please Wait...",
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


  static showConfirmDialog(BuildContext context, bool isLoading) {
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
                  "Confirming Payment...",
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                              'Make Payment',
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
                  "Enter your details to make Payment",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                )),
                            Padding(
                              padding: const EdgeInsets.only(right: 25, top: 15),
                              child: Align(
                                            alignment: Alignment.topRight,
                                            child: Column(
                                              children: [
                                                const Text(
                                              "Amount due",
                                              style: TextStyle(
                                                  color: Colors.black38,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              "${widget.currency} ${widget.price}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 24),
                                              textAlign: TextAlign.center,
                                            )
                                              ],
                                            )),
                            ),
            const SizedBox(
              height: 25,
            ),

            SizedBox(
              //color: Colors.red,
              height: 250,
              child: FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return WebViewWidget(controller: _controller);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 350,
                  child: Text(
                    "Confirm Payment after a Successful Payment has been done ",
                    style: TextStyle(
                        color: Colors.black45,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )),
                
            const SizedBox(height: 15),
            Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  child: Container(
                    width: 250,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 52, 99, 239),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.verified,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Confirm Payment ",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.white))
                      ],
                    ),
                  ),
                  onTap: () {
                    showConfirmDialog(context, true);
                    confirm();
                  },
                )),
          ],
        ),
      ),
    );
  }

  Future<void> confirm() async {
    try {
      SharedPreferences Payment = await SharedPreferences.getInstance();
      http.Response response = await http.post(
          Uri.parse('${AppConstant.FLIGHT_BASE_URL}/confirm_payment_intent/'),
          body: {
            "pit": Payment.getString("pit").toString(),
          });
      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (!responseData.toString().contains('errors')) {
        final responseData = jsonDecode(response.body);
        final paymentData = responseData['data'];

        setState(() {
          showConfirmDialog(context, false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentSuccess(
                image: widget.image,
                response: paymentData,
              ),
            ),
          );
          const snackdemo = SnackBar(
            content: Text(
              "Payment Intent Successfully Confirmed",
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
        });
      } else if (responseData.toString().contains('errors')) {
        setState(() {
          showConfirmDialog(context, false);
          const snackdemo = SnackBar(
            content: Text(
              "Payment Intent Failed. Kindly Complete Payment! ",
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
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
