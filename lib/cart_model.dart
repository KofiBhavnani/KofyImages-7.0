import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Cart extends Equatable {

  final int? id;
  final String productId;
  final String productImage;
  final String productPrice;
  final int quantity;
  dynamic  productColor;
  final String  productSize;
  final String  productSubtotal;
  final String productTotalPrice;



    Cart({
    this.id,
    required this.productId,
    required this.productImage,
    required this.productPrice,
    required this.quantity,
    required this.productColor,
    required this.productSize,
    required this.productSubtotal,
    required this.productTotalPrice

   });

    factory Cart.fromMap(Map<String, dynamic>res)=>Cart(
    id: res["id"], 
    productId: res["productId"], 
    productImage: res["productImage"], 
    productPrice: res["productPrice"].toString(), 
    quantity: res["quantity"], 
    productColor: res["productColor"], 
    productSize: res["productSize"], 
    productSubtotal:res["productSubtotal"].toString(), 
    productTotalPrice: res["productTotalPrice"].toString()
    );


   Map<String, Object?> toMap(){
    return{
      'productId': productId,
      'productImage': productImage,
      'productPrice': productPrice,
      'quantity': quantity,
      'productColor': productColor,
      'productSize': productSize,
      'productSubtotal': productSubtotal,
      'productTotalPrice': productTotalPrice,
    };
   }
   
     @override
     List<Object?> get props => [
    id,
    productId,
    productImage,
    productPrice,
    quantity,
    productColor,
    productSize,
    productSubtotal,
    productTotalPrice


     ];

}