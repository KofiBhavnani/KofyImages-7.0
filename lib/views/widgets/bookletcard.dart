import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kofyimages/cart_model.dart';
import 'package:kofyimages/cart_provider.dart';
import 'package:kofyimages/db_helper.dart';
import 'package:provider/provider.dart';

class BookletCard extends StatefulWidget {
  final String price;
  final String id;
  final String quantity;
  final List<String> thumbnailUrls;
  const BookletCard({super.key, 
    required this.price,
    required this.thumbnailUrls,
    required this.id,
    required this.quantity,
  });

  @override
  State<BookletCard> createState() => _BookletCardState();
}

class _BookletCardState extends State<BookletCard> {
  int indexOfPicToShow = 0;
  String frameColor = "null";
  String addtoCart = "";


  DBHelper dbHelper = DBHelper();

   @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Card(
       margin: const EdgeInsets.all(25),
         shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(12.0), //<-- SEE HERE
        ),
        child: Container(
          //margin: EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2.0,
                ),
              ]),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.thumbnailUrls[indexOfPicToShow],
                imageBuilder: (context, imageProvider) => Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.10),
                          BlendMode.multiply,
                        ),
                        //image size fill
                        image: imageProvider,
                        fit: BoxFit.contain),
                  ),
                ),
              placeholder: (context, url) => Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
              ),
              const SizedBox(height: 15,),
                  Text(
                    "£${widget.price}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        )),
                  onTap: () {
                  dbHelper.insert(Cart(
                  productImage: widget.thumbnailUrls[indexOfPicToShow], 
                  productPrice: widget.price, 
                  quantity: 1, 
                  productColor: null,
                  productSize: "NULL", 
                  productSubtotal: widget.price, 
                  productTotalPrice: widget.price, 
                  productId: widget.id)).then((value){
                  const text ='Travel Guide Successfully Added';
                    const snackBar=SnackBar(
                      content: 
                      Text(text,style: TextStyle(color: Colors.white, fontFamily:    "Montserrat", fontWeight: FontWeight.w600,fontSize:18),),
                      backgroundColor: Colors.black,);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    cart.addTotalPrice(double.parse(widget.price.toString()));
                    cart.addCounter();
                  }).onError((error, stackTrace){

                  });
                  }),

              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
