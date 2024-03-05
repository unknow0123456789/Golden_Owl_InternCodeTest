import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test_goldenowl/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage>{
  final List<Product> productlist=fixlist;
  double totalcost=0;
  double checkCost()
  {
    double sum=0;
    for(Product product in productlist)
    {
      sum+=product.incart*product.price;
    }
    return sum;
  }
  void IncreaseProductAt(int index)
  {
    setState(()  {
      productlist[index].incart++;
      totalcost=checkCost();
      SaveProductListInstance();
    });
  }
  void DecreaseProductAt(int index)
  {
    setState(() {
      productlist[index].incart--;
      totalcost=checkCost();
      if(productlist[index].incart<0) productlist[index].incart=0;
      SaveProductListInstance();
    });
  }
  void TrashProduct(int index)
  {
    setState(() {
      productlist[index].incart=0;
      totalcost=checkCost();
      SaveProductListInstance();
    });
  }
  void SaveProductListInstance () async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedList=Product.encode(productlist);
    await prefs.setString(listkey, encodedList);
  }
  bool EmptyCartCheck()
  {
    for(Product product in productlist)
      {
        if(product.incart!=0) return false;
      }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    totalcost=checkCost();
    return Scaffold(
     body: Container(
       child: Stack(
         children: [
           Container(
             color: Colors.white,
           ),
           Align(
             alignment: Alignment.bottomCenter,
             child: FractionallySizedBox(
               widthFactor: 1,
               heightFactor: 0.5,
               child: Container(
                 width: 500,
                 height: 500,
                 decoration: BoxDecoration(
                   color: Colors.amberAccent,
                   borderRadius: BorderRadius.only(topLeft: Radius.circular(80))
                 ),
               ),
             ),
           ),
           SingleChildScrollView(
             scrollDirection: Axis.vertical,
             child: Padding(
               padding: EdgeInsets.symmetric(horizontal: 25),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children:
                 [
                   Padding( //our products
                     padding: const EdgeInsets.symmetric(vertical: 15),
                     child: Container(
                       decoration: const BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(30)),
                         color: Colors.white,
                         boxShadow: [
                           BoxShadow(
                             offset: Offset(0, 0),
                             blurRadius: 5,
                             spreadRadius: 5,
                             color: Colors.black26,
                           ),
                         ]
                       ),
                       width: double.infinity,
                       height: 650,
                       child: Stack(
                         children: [
                           Align(   //yellow circle
                             alignment: Alignment.topLeft,
                             child: FractionallySizedBox(
                               widthFactor: 0.33,
                               heightFactor: 0.3,
                               child: Container(
                                 decoration: BoxDecoration(
                                     color: Colors.amberAccent,
                                     borderRadius: BorderRadius.only(bottomRight: Radius.elliptical(200, 300),topLeft: Radius.circular(30))
                                 ),
                               ),
                             ),
                           ),
                           Padding(   //main our products
                           padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const SizedBox(    // nike logo
                                 height: 30,
                                 child: Image(
                                   image: AssetImage("images/nike.png"),
                                   fit: BoxFit.fitHeight,
                                 ),
                               ),
                               Padding(   //title
                                 padding: const EdgeInsets.only(top: 10),
                                 child: Text("Our Products",
                                 style: GoogleFonts.rubik(
                                   textStyle: const TextStyle(
                                     fontSize: 30,
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black
                                   )
                                 )
                                 ),
                               ),
                               Expanded(  //products
                                 child: ListView.builder(
                                     scrollDirection: Axis.vertical,
                                     itemCount: productlist.length,
                                     itemBuilder: (context,index)
                                         {
                                           Product currentPro=productlist[index];
                                           return new Productbuilder(product: currentPro, onAddtoCart: ()
                                           {
                                             IncreaseProductAt(index);
                                           });
                                         }
                                 ),
                               )
                             ],
                           ),
                         ),
                         ]
                       ),
                     ),
                   ),
                   Padding( //Your cart
                     padding: const EdgeInsets.symmetric(vertical: 15),
                     child: Container(
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(30)),
                           color: Colors.white,
                           boxShadow: [
                             BoxShadow(
                               offset: Offset(0, 0),
                               blurRadius: 5,
                               spreadRadius: 5,
                               color: Colors.black26,
                             ),
                           ]
                       ),
                       width: double.infinity,
                       height: 600,
                       child: Stack(
                           children: [
                             Align(   //yellow circle
                               alignment: Alignment.topLeft,
                               child: FractionallySizedBox(
                                 widthFactor: 0.33,
                                 heightFactor: 0.3,
                                 child: Container(
                                   decoration: BoxDecoration(
                                       color: Colors.amberAccent,
                                       borderRadius: BorderRadius.only(bottomRight: Radius.elliptical(200, 300),topLeft: Radius.circular(30))
                                   ),
                                 ),
                               ),
                             ),
                             Padding(   //main Your Cart
                               padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   const SizedBox(    // nike logo
                                     height: 30,
                                     child: Image(
                                       image: AssetImage("images/nike.png"),
                                       fit: BoxFit.fitHeight,
                                     ),
                                   ),
                                   Padding(   //title
                                     padding: const EdgeInsets.only(top: 10),
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Text("Your Cart",
                                             style: GoogleFonts.rubik(
                                                 textStyle: const TextStyle(
                                                     fontSize: 30,
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.black
                                                 )
                                             )
                                         ),
                                         Text(
                                           "\$"+totalcost.toStringAsFixed(2),
                                           style: GoogleFonts.rubik(
                                               textStyle: TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.black,
                                                   fontSize: 23
                                               )
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                   Expanded(  //products
                                     child: EmptyCartCheck() ?
                                     const Text("Your cart is empty") :
                                     ListView.builder(
                                         scrollDirection: Axis.vertical,
                                         itemCount: productlist.length,
                                         itemBuilder: (context,index)
                                         {
                                           Product currentPro=productlist[index];
                                           String colorOpa="0xFF${currentPro.color}";
                                           Color proColor=Color(int.parse(colorOpa));
                                           if(currentPro.incart>0) {
                                             return Padding(
                                             padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                                             child: Container(
                                               // color: Colors.red,
                                               child: Row(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Container(
                                                     // color: Colors.green,
                                                     child: SizedBox(
                                                       width: 130,
                                                       height: 130,
                                                       child: Stack(
                                                         children: [
                                                           Align(
                                                             alignment: Alignment.centerLeft,
                                                             child: Padding(
                                                               padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                                                               child: Container(
                                                                   width: 90,
                                                                   height:90,
                                                                   decoration: BoxDecoration(
                                                                       color: proColor,
                                                                       borderRadius: BorderRadius.all(Radius.circular(200))
                                                                     )
                                                               ),
                                                             ),
                                                           ),
                                                           SizedBox(
                                                             width: 170,
                                                             height: 170,
                                                             child: Container(
                                                               // color: Color.fromARGB(20, 255, 0, 0),
                                                               child: Transform.translate(
                                                                 offset: Offset(-10,0),
                                                                 child: Transform.rotate(
                                                                   angle: 330 * math.pi / 180,
                                                                   child: Image(
                                                                     image: NetworkImage(currentPro.imageUrl),
                                                                   ),
                                                                 ),
                                                               ),
                                                             ),
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                   Padding(
                                                     padding: const EdgeInsets.symmetric(vertical: 10),
                                                     child: Container(
                                                       alignment: Alignment.centerLeft,
                                                       width: 180,
                                                       child: SingleChildScrollView(
                                                         scrollDirection: Axis.horizontal,
                                                         child: Column(
                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                           crossAxisAlignment: CrossAxisAlignment.start,
                                                           children: [
                                                             Padding(
                                                               padding: const EdgeInsets.symmetric(vertical: 5),
                                                               child: Expanded(
                                                                 child: Container(
                                                                   alignment: Alignment.centerLeft,
                                                                   // color: Colors.green,
                                                                   child: Text
                                                                     (
                                                                     currentPro.name,
                                                                     style: GoogleFonts.rubik(
                                                                       textStyle: const TextStyle(
                                                                         fontSize: 13,
                                                                         fontWeight: FontWeight.bold,
                                                                         color: Colors.black,
                                                                       )
                                                                     ),
                                                                   ),
                                                                 ),
                                                               ),
                                                             ),
                                                             Container(
                                                               alignment: Alignment.topLeft,
                                                               child: Text(
                                                                 "\$"+currentPro.price.toStringAsFixed(2),
                                                                 style: GoogleFonts.rubik(
                                                                     textStyle: const TextStyle(
                                                                         fontWeight: FontWeight.bold,
                                                                         color: Colors.black,
                                                                         fontSize: 23
                                                                     )
                                                                 ),
                                                               ),
                                                             ),
                                                             SizedBox(
                                                               child: Row(
                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                 children: [
                                                                   Row(
                                                                     children: [
                                                                       Padding(
                                                                         padding: const EdgeInsets.all(5),
                                                                         child: Container(
                                                                           height: 30,
                                                                           width: 30,
                                                                           decoration: const BoxDecoration(
                                                                             borderRadius: BorderRadius.all(Radius.circular(200)),
                                                                             color: CupertinoColors.systemGrey5
                                                                           ),
                                                                           child: IconButton(onPressed:
                                                                               ()
                                                                           {
                                                                             DecreaseProductAt(index);
                                                                           },
                                                                               icon:const Image(
                                                                                 image: AssetImage("images/minus.png"),
                                                                               )),
                                                                         ),
                                                                       ),
                                                                       Padding(
                                                                         padding: const EdgeInsets.all(5),
                                                                         child: Text(
                                                                           currentPro.incart.toString()
                                                                         ),
                                                                       ),
                                                                       Padding(
                                                                         padding: const EdgeInsets.all(5),
                                                                         child: Container(
                                                                           height: 30,
                                                                           width: 30,
                                                                           decoration: BoxDecoration(
                                                                               borderRadius: BorderRadius.all(Radius.circular(200)),
                                                                               color: CupertinoColors.systemGrey5
                                                                           ),
                                                                           child: IconButton(onPressed:
                                                                               ()
                                                                           {
                                                                             IncreaseProductAt(index);
                                                                           },
                                                                               icon:Image(
                                                                                 image: AssetImage("images/plus.png"),
                                                                               )),
                                                                         ),
                                                                       ),
                                                                     ],
                                                                   ),
                                                                   Padding(
                                                                     padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                                                     child: Container(
                                                                       height: 30,
                                                                       width: 30,
                                                                       decoration: BoxDecoration(
                                                                           borderRadius: BorderRadius.all(Radius.circular(200)),
                                                                           color: Colors.amberAccent
                                                                       ),
                                                                       child: IconButton(onPressed:
                                                                           ()
                                                                       {
                                                                         TrashProduct(index);
                                                                       },
                                                                           icon:Image(
                                                                             image: AssetImage("images/trash.png"),
                                                                           )),
                                                                     ),
                                                                   ),
                                                                 ],
                                                               ),
                                                             )
                                                           ],
                                                         ),
                                                       ),
                                                     ),
                                                   )
                                                 ],
                                               ),
                                             ),
                                           );
                                           }
                                           else
                                             return Container();
                                         }
                                     ),
                                   )
                                 ],
                               ),
                             ),
                           ]
                       ),
                     ),
                   )
                 ]
               ),
             ),
           )
         ],
       ),
     ),
    );
  }
}

class Productbuilder extends StatefulWidget {
  const Productbuilder({super.key,required this.product,required this.onAddtoCart});
  final Product product;
  final AddtoCartCallback onAddtoCart;
  @override
  State<StatefulWidget> createState() =>_ProductbuilderState();
}
class _ProductbuilderState extends State<Productbuilder> {
  @override
  Widget build(BuildContext context) {
    String colorOpa="0xFF"+widget.product.color;
    Color proColor=Color(int.parse(colorOpa));
    if(widget.product.incart==0)
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
        child: Column(
          children: [
            Padding( //product image
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: proColor
                ),
                width: double.infinity,
                height: 450,
                child: Center(
                  child: Transform.rotate(
                    angle: 330 * math.pi / 180,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Image(
                        image: NetworkImage(widget.product.imageUrl),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding( //product name
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.product.name,
                  style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 23
                    ),
                  ),
                ),
              ),
            ),
            Padding( //product des
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                widget.product.description,
                style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w100
                    )
                ),
              ),
            ),
            Row( //product price and button
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(   //product price
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "\$"+widget.product.price.toString(),
                    style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 23
                        )
                    ),
                  ),
                ),
                Container( //product button
                  width: 150,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.amberAccent,
                  ),
                  child: TextButton(
                    child: Text(
                      "ADD TO CART",
                      style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            letterSpacing: 0.2,
                          )
                      ),
                    ),
                    onPressed: (){
                      widget.onAddtoCart();
                    },
                  ),
                )
              ],
            )
          ],
        ),
      );
    else
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
        child: Column(
          children: [
            Padding( //product image
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: proColor
                ),
                width: double.infinity,
                height: 450,
                child: Center(
                  child: Transform.rotate(
                    angle: 330 * math.pi / 180,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Image(
                        image: NetworkImage(widget.product.imageUrl),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding( //product name
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.product.name,
                  style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 23
                    ),
                  ),
                ),
              ),
            ),
            Padding( //product des
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                widget.product.description,
                style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w100
                    )
                ),
              ),
            ),
            Row( //product price and button
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(   //product price
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "\$"+widget.product.price.toStringAsFixed(2),
                    style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 23
                        )
                    ),
                  ),
                ),
                Container( //product button
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.amberAccent,
                  ),
                  child: IconButton(
                    icon: Image(
                      image: AssetImage("images/check.png"),
                    ),
                    onPressed: () {  },
                  )
                )
              ],
            )
          ],
        ),
      );
  }
}
typedef AddtoCartCallback = Function ();
