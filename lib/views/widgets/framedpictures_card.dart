import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kofyimages/cart_model.dart';
import 'package:kofyimages/cart_provider.dart';
import 'package:kofyimages/db_helper.dart';
import 'package:provider/provider.dart';

class Framed_PicturesCard extends StatefulWidget {
  final String price;
  final String size;
  final String id;
  final String quantity;
  final String name;
  final List<String> thumbnailUrls;
  const Framed_PicturesCard({super.key, 
    required this.price,
    required this.thumbnailUrls,
    required this.id,
    required this.size,
    required this.quantity, 
    required  this.name,
  });

  @override
  State<Framed_PicturesCard> createState() => _Framed_PicturesCardState();
}

class _Framed_PicturesCardState extends State<Framed_PicturesCard> {
  int indexOfPicToShow = 0;
  String frameColor = "";
  String addtoCart = "";
  String errorText = "";

  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Card(
         shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), //<-- SEE HERE
        ),
        child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.circular(12.0)),
          child: Column(
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
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "£${widget.price}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  InkWell(
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 0, 0, 0),
                          shape: BoxShape.circle),
                    ),
                    onTap: () {
                      setState(() {
                        indexOfPicToShow = 1;
                        errorText = "";
                        addtoCart = "BLACK";
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 97, 45, 3),
                          shape: BoxShape.circle),
                    ),
                    onTap: () {
                      setState(() {
                        indexOfPicToShow = 2;
                        errorText = "";
                        addtoCart = "BROWN";
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
                Align(
                alignment: Alignment.center,
                child: Text(
                  widget.name,
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ), const SizedBox(
                height: 3,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  errorText,
                  style: const TextStyle(
                      color: Colors.red,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),

              const SizedBox(
                height: 5,
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
                    setState(() {
                      if (addtoCart == "") {
                        errorText = "Please select a frame color ↑";
                        addtoCart = "error";
                       
                      } else if (addtoCart == "BLACK") {
                        errorText = "";
                      

                  /////////////////////////////
                  dbHelper.insert(Cart(
                  productImage: widget.thumbnailUrls[indexOfPicToShow], 
                  productPrice: widget.price, 
                  quantity: 1, 
                  productColor: "black", 
                  productSize: widget.size, 
                  productSubtotal: widget.price, 
                  productTotalPrice: widget.price, 
                  productId: widget.id)).then((value){
                     const text ='Product Successfully Added';
                    const snackBar=SnackBar(content: Text(text,style: TextStyle(color: Colors.white, fontFamily:    "Montserrat", fontWeight: FontWeight.w600,fontSize:18),),
                    backgroundColor: Colors.green,);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  
                    cart.addTotalPrice(double.parse(widget.price.toString()));
                    cart.addCounter();
                  }).onError((error, stackTrace){
                   
                  });

                      } else if (addtoCart == "BROWN") {
                        frameColor = "BROWN";
                        errorText = "";
                       

                     /////////////////////////////
                  dbHelper.insert(Cart(
                  productImage: widget.thumbnailUrls[indexOfPicToShow], 
                  productPrice: widget.price, 
                  quantity: 1, 
                  productColor: "brown", 
                  productSize: widget.size, 
                  productSubtotal: widget.price, 
                  productTotalPrice: widget.price, 
                  productId: widget.id)).then((value){
                    const text ='Product Successfully Added';
                    const snackBar= SnackBar(content: Text(text,style: TextStyle(color: Colors.white, fontFamily:    "Montserrat", fontWeight: FontWeight.w600,fontSize:18),),
                     backgroundColor: Colors.green,);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    
                    cart.addTotalPrice(double.parse(widget.price.toString()));
                    cart.addCounter();
                  }).onError((error, stackTrace){
                    
                  });

                      }
                    });
                  }),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        )
        );
  }
}
