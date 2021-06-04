import 'dart:convert';

import 'package:ecom/models/product.dart';
import 'package:ecom/screens/home.dart';
import 'package:ecom/user/user_login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:number_inc_dec/number_inc_dec.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  ProductDetails({this.product});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int dropDownValue = 1;
  bool isLoading = false;

  TextEditingController _qty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > 600) {
        return _DesktopView();
      } else {
        return _MobileView();
      }
    });
  }

  Widget _MobileView() {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Column(children: [
                    GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            //color: Colors.red,
                            //height: 450,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 450,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.3,
                                        child: Image.network(
                                          widget.product.img_name,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                        )),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 10, top: 10),
                            child: Text(
                              widget.product.product_title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              "Rs: ${widget.product.product_price}/-",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              widget.product.rating == null
                                  ? Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                          height: 30,
                                          width: 45,
                                          color: Colors.green,
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Row(
                                              children: [
                                                Text("5.0",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                Icon(Icons.star,
                                                    size: 18,
                                                    color: Colors.white)
                                              ],
                                            ),
                                          )),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                          height: 30,
                                          width: 45,
                                          color: Colors.green,
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                    "${widget.product.rating}.0"
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                Icon(Icons.star,
                                                    size: 18,
                                                    color: Colors.white)
                                              ],
                                            ),
                                          )),
                                    ),
                              widget.product.rating == null
                                  ? SmoothStarRating(
                                      rating: 5.0,
                                      isReadOnly: true,
                                      color: Colors.green,
                                      size: 20,
                                      starCount: 5,
                                      onRated: (value) {},
                                    )
                                  : SmoothStarRating(
                                      rating: widget.product.rating,
                                      isReadOnly: true,
                                      size: 20,
                                      color: Colors.green,
                                      starCount: 5,
                                    )
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              child: widget.product.status == "available"
                                  ? Container(
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.green,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Available🙂️",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.red,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Coming Soon",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                "Description: ${widget.product.product_desc}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              "Brand: ${widget.product.brand_id}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              "Category: ${widget.product.cat_id}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Container(
                                  //   padding:
                                  //       EdgeInsets.symmetric(horizontal: 10.0),
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(15.0),
                                  //     border: Border.all(
                                  //         color: Colors.red,
                                  //         style: BorderStyle.solid,
                                  //         width: 1.80),
                                  //   ),
                                  //   child: DropdownButtonHideUnderline(
                                  //     child: DropdownButton(
                                  //         value: dropDownValue,
                                  //         onChanged: (int newVal) {
                                  //           setState(() {
                                  //             dropDownValue = newVal;
                                  //           });
                                  //         },
                                  //         items: [
                                  //           DropdownMenuItem(
                                  //             value: 1,
                                  //             child: Text('1'),
                                  //           ),
                                  //           DropdownMenuItem(
                                  //             value: 2,
                                  //             child: Text('2'),
                                  //           ),
                                  //           DropdownMenuItem(
                                  //             value: 3,
                                  //             child: Text('3'),
                                  //           ),
                                  //           DropdownMenuItem(
                                  //             value: 4,
                                  //             child: Text('4'),
                                  //           ),
                                  //           DropdownMenuItem(
                                  //             value: 5,
                                  //             child: Text('5'),
                                  //           ),
                                  //         ]),
                                  //   ),
                                  // ),

                                  

                                  Container(
                                    height: 80,
                                    width: 200,
                                    child: NumberInputPrefabbed.roundedButtons(
                                      controller: _qty,
                                      initialValue: 1,
                                      incDecBgColor: Colors.amber,
                                      min: 1,
                                      max: 5,
                                      buttonArrangement:
                                          ButtonArrangement.incRightDecLeft,
                                      incIconSize: 35,
                                      decIconSize: 35,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                        color: Colors.red,
                                        height: 50,
                                        minWidth: 220,
                                        
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        onPressed: () {
                                          addtocartMobile();
                                        },
                                        child: Text("add to cart",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ]),
                ),
              ),
            ),
          ]),
    );
  }

  Widget _DesktopView() {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Column(children: [
                    GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            //color: Colors.red,
                            //height: 450,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                        height: 450,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Image.network(
                                          widget.product.img_name,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          width:
                                              MediaQuery.of(context).size.width,
                                        )),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 10, top: 10),
                                            child: Text(
                                              widget.product.product_title,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Text(
                                              "Rs: ${widget.product.product_price}/-",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(children: [
                                              widget.product.rating == null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Container(
                                                          height: 30,
                                                          width: 45,
                                                          color: Colors.green,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Row(
                                                              children: [
                                                                Text("5.0",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )),
                                                                Icon(Icons.star,
                                                                    size: 18,
                                                                    color: Colors
                                                                        .white)
                                                              ],
                                                            ),
                                                          )),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Container(
                                                          height: 30,
                                                          width: 45,
                                                          color: Colors.green,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                    "${widget.product.rating}.0"
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )),
                                                                Icon(Icons.star,
                                                                    size: 18,
                                                                    color: Colors
                                                                        .white)
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                              widget.product.rating == null
                                                  ? SmoothStarRating(
                                                      rating: 5.0,
                                                      isReadOnly: true,
                                                      color: Colors.green,
                                                      size: 20,
                                                      starCount: 5,
                                                      onRated: (value) {},
                                                    )
                                                  : SmoothStarRating(
                                                      rating:
                                                          widget.product.rating,
                                                      isReadOnly: true,
                                                      size: 20,
                                                      color: Colors.green,
                                                      starCount: 5,
                                                    )
                                            ]),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Container(
                                              child: widget.product.status ==
                                                      "available"
                                                  ? Container(
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: Colors.green,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                          "Available🙂️",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: Colors.red,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                          "Coming Soon",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.4,
                                              child: Text(
                                                "Description: ${widget.product.product_desc}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Text(
                                              "Brand: ${widget.product.brand_id}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Text(
                                              "Category: ${widget.product.cat_id}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    border: Border.all(
                                                        color: Colors.red,
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 1.80),
                                                  ),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                        value: dropDownValue,
                                                        onChanged:
                                                            (int newVal) {
                                                          setState(() {
                                                            dropDownValue =
                                                                newVal;
                                                          });
                                                        },
                                                        items: [
                                                          DropdownMenuItem(
                                                            value: 1,
                                                            child: Text('1'),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: 2,
                                                            child: Text('2'),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: 3,
                                                            child: Text('3'),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: 4,
                                                            child: Text('4'),
                                                          ),
                                                          DropdownMenuItem(
                                                            value: 5,
                                                            child: Text('5'),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: FlatButton(
                                                      color: Colors.red,
                                                      height: 40,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      onPressed: () {
                                                        addtocart();
                                                      },
                                                      child: Text("add to cart",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ]),
    );
  }

  login() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return (useremail == "") ? Login() : addtocart();
      },
    ));
  }

  addtocart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');
    if (useremail == null) {
      Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return Login();
        },
      ));
    } else {
      // final price = widget.product.product_price.toString();
      // final qtyvalue = dropDownValue.toString();
      var response = await http.post(
        Uri.parse(
          "http://ecom777.000webhostapp.com/Ecommerce/addtocart.php",
        ),
        body: {
          "p_id": widget.product.product_id.toString(),
          "useremail": useremail.toString(),
          "qty": dropDownValue.toString(),
          // "subtotal": "${widget.product.product_price * dropDownValue}".toString(),
        },
      );

      if (jsonDecode(response.body) == "Error") {
        setState(() {
          isLoading = false;
        });
        print(response.body);
        Toast.show(
          "Already added to cart...",
          context,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          duration: Toast.LENGTH_LONG,
        );
      } else if (jsonDecode(response.body) == "success") {
        setState(() {
          isLoading = false;
        });
        print(response.body);
        Toast.show(
          "Added to Cart...",
          context,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          duration: Toast.LENGTH_LONG,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Home();
            },
          ),
        );
      }
    }
  }

  addtocartMobile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');
    if (useremail == null) {
      Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return Login();
        },
      ));
    } else {
      // final price = widget.product.product_price.toString();
      // final qtyvalue = dropDownValue.toString();
      var response = await http.post(
        Uri.parse(
          "http://ecom777.000webhostapp.com/Ecommerce/addtocart.php",
        ),
        body: {
          "p_id": widget.product.product_id.toString(),
          "useremail": useremail.toString(),
          "qty": dropDownValue.toString(),
          // "subtotal": "${widget.product.product_price * dropDownValue}".toString(),
        },
      );

      if (jsonDecode(response.body) == "Error") {
        setState(() {
          isLoading = false;
        });
        print(response.body);
        Toast.show(
          "Already added to cart...",
          context,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          duration: Toast.LENGTH_LONG,
        );
      } else if (jsonDecode(response.body) == "success") {
        setState(() {
          isLoading = false;
        });
        print(response.body);
        Toast.show(
          "Added to Cart...",
          context,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          duration: Toast.LENGTH_LONG,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Home();
            },
          ),
        );
      }
    }
  }
}
