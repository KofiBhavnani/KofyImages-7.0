import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kofyimages/cart_model.dart';
import 'package:kofyimages/db_helper.dart';
import 'package:provider/provider.dart';

import '../../cart_provider.dart';

class CartCard extends StatefulWidget {
  final int price;
  final int quantity;
  final String color;
  final String size;
  final String image;
  final int total;
  final int subtotal;
  final String productId;
  final int? id;
  const CartCard(
      {super.key,
      required this.price,
      required this.quantity,
      required this.color,
      required this.size,
      required this.image,
      required this.total,
      required this.subtotal,
      required this.productId,
      required this.id});

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Column(children: [
      Card(
        child: Row(
          //ROW 1
          children: [
            GestureDetector(
              child: const SizedBox(
                width: 100,
                height: 100,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ),
              ),
              onTap: () {
                dbHelper!.delete(widget.id);
                cart.removeCounter();
                cart.removeTotalPrice(double.parse(widget.subtotal.toString()));
           
              },
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Align(
                alignment: Alignment.center,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.10),
                              BlendMode.multiply,
                            ),
                            //image size fill
                            image: imageProvider,
                            fit: BoxFit.fitWidth),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "£${widget.price}",
                  style: const TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 200.0,
                  height: 100,
                  padding: const EdgeInsets.all(7),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4.0)),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 15.0,
                          ),
                        ),
                        onTap: () {
                          int quantity = widget.quantity;
                          int price = widget.price;
                          quantity--;
                          int? newPrice = price * quantity;

                          if (quantity > 0) {
                            dbHelper!
                                .update(Cart(
                                    id: widget.id,
                                    productId: widget.productId,
                                    productImage: widget.image,
                                    productPrice: widget.price.toString(),
                                    quantity: quantity,
                                    productColor: widget.color,
                                    productSize: widget.size,
                                    productSubtotal: newPrice.toString(),
                                    productTotalPrice: widget.total.toString()))
                                .then((value) {
                              newPrice = 0;
                              quantity = 0;
                              cart.removeIntialPrice(
                                  double.parse(widget.price.toString()));
                            }).onError((error, stackTrace) {
                             
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.quantity.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4.0)),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 15.0,
                          ),
                        ),
                        onTap: () {
                          int quantity = widget.quantity;
                          int price = widget.price;
                          quantity++;
                          int? newPrice = price * quantity;
                          int? newsubtotal = price * quantity;

                          dbHelper!
                              .update(Cart(
                                  id: widget.id,
                                  productId: widget.productId,
                                  productImage: widget.image,
                                  productPrice: widget.price.toString(),
                                  quantity: quantity,
                                  productColor: widget.color,
                                  productSize: widget.size,
                                  productSubtotal: newPrice.toString(),
                                  productTotalPrice: widget.total.toString()))
                              .then((value) {
                            newPrice = 0;
                            newsubtotal = 0;
                            quantity = 0;
                            cart.addTotalPrice(
                                double.parse(widget.price.toString()));
                          }).onError((error, stackTrace) {
                            
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.color.toUpperCase(),
                  style: const TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.size,
                  style: const TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 110,
              height: 100,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "£${widget.subtotal}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
