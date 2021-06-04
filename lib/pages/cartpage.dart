import 'package:badges/badges.dart';
import 'package:ecom/models/cart.dart';
import 'package:ecom/pages/checkout.dart';
import 'package:ecom/pages/search.dart';
import 'package:ecom/screens/home.dart';
import 'package:ecom/user/user_acc.dart';
import 'package:ecom/user/user_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<List<Cart>> cart;
  int dropDownValue = 1;
  bool isLoading = false;
  List<int> _itemCount = List();
  //final TextEditingController _qty = List();
  List<TextEditingController> _qty = new List();
  var totalcartitems;
  var subtotal;
  int l = 0;

  // String selectedBrand;
  //List cart = List();

  @override
  void initState() {
    super.initState();
    getTottalCartItemsList();
    cart = getCartList();
  }

  Future<List<Cart>> getCartList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');

    final response = await http.post(
        Uri.parse(
          "http://ecom777.000webhostapp.com/Ecommerce/cartpage.php",
        ),
        body: {
          "useremail": useremail.toString(),
        });

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Cart> cart = items.map<Cart>((json) {
      return Cart.fromJson(json);
    }).toList();

    return cart;
  }

  //cart total items
  Future getTottalCartItemsList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');
    final response = await http
        .post(
           Uri.parse("http://ecom777.000webhostapp.com/Ecommerce/cartqty.php",), body: {
      "useremail": useremail.toString(),
    });
    final jsonbody = response.body;
    final jsonData = json.decode(jsonbody);

    setState(() {
      totalcartitems = jsonData;
    });

    print(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print(
            'Backbutton pressed (device or appbar button), do whatever you want.');

        //Navigator.pop(context, false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Home();
            },
          ),
        );

        return Future.value(false);
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: AppBar(
              backgroundColor: Colors.indigo,
              title: Text('Ecommerce Web'),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 20, 10),
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      Navigator.push(context, new MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return SearchPage();
                        },
                      ));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                  child: InkWell(
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      var useremail = preferences.getString('useremail');
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return (useremail == null) ? Login() : CartPage();
                        },
                      ));
                    },
                    child: Badge(
                      badgeContent: Text(
                        totalcartitems.toString(),
                        // itemCount.toString(),
                        style: TextStyle(
                            fontFamily: 'Celias',
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      badgeColor: Colors.green,
                      child: Icon(
                        Icons.shopping_cart,
                        size: 30,
                      ),
                    ),
                  ),
                ),

                // IconButton(
                //     icon: Icon(
                //       Icons.add,
                //     ),
                //     onPressed: () async {
                //       SharedPreferences preferences =
                //           await SharedPreferences.getInstance();
                //       var useremail = preferences.getString('useremail');
                //       Navigator.push(context, MaterialPageRoute(
                //         builder: (BuildContext context) {
                //           return AdminHome();
                //         },
                //       ));
                //     }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 30, 10),
                  child: IconButton(
                      icon: Icon(
                        Icons.person,
                      ),
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        var useremail = preferences.getString('useremail');
                        Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) {
                            return (useremail == null)
                                ? Login()
                                : UserAccount();
                          },
                        ));
                      }),
                ),
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LayoutBuilder(
                builder: (
                  context,
                  BoxConstraints constraints,
                ) {
                  return Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.red),
                    child: Row(
                      children: [
                        Container(
                          width: constraints.maxWidth * 0.45, //45%
                          child: Text(
                            "Product",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.2, //20%
                          child: Text(
                            "Quantity",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.15, //20%
                          child: Text(
                            "Remove",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.2, //20%
                          child: Text("Total Price",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              _buildCartProducts()
            ],
          )),
    );
  }

  Widget _buildCartProducts() {
    return FutureBuilder<List<Cart>>(
      future: cart,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        l = snapshot.data.length;
        print(l);
        var h = l - 1;

        return Flexible(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                    ) {
                      _qty.add(new TextEditingController());
                      subtotal = snapshot.data[index].subtotal;
                      print(subtotal);

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10.0,
                        child: LayoutBuilder(builder: (
                          context,
                          BoxConstraints constraints,
                        ) {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              snapshot.data[index].img_name != null
                                  ? Container(
                                      height: 150,
                                      width: constraints.maxWidth * 0.2, //20%
                                      child: Image.network(
                                        snapshot.data[index].img_name,
                                        loadingBuilder: (BuildContext ctx,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor: Color.fromRGBO(
                                                    255, 63, 111, 1),
                                              ),
                                            );
                                          }
                                        },
                                        // fit: BoxFit.fill,
                                        //fit: BoxFit.fill,
                                        fit: BoxFit.contain,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    )
                                  : CircularProgressIndicator(
                                      backgroundColor:
                                          Color.fromRGBO(255, 63, 111, 1),
                                    ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: constraints.maxWidth * 0.25,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, top: 8),
                                        child: Text(
                                          snapshot.data[index].product_title,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "Rs: ${snapshot.data[index].product_price.toString()}/-",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Row(children: [
                                    snapshot.data[index].rating == null
                                        ? Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Container(
                                                height: 22,
                                                width: 38,
                                                color: Colors.green,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Row(
                                                    children: [
                                                      Text("5.0",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12)),
                                                      Icon(Icons.star,
                                                          size: 15,
                                                          color: Colors.white)
                                                    ],
                                                  ),
                                                )),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Container(
                                                height: 22,
                                                width: 38,
                                                color: Colors.green,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          "${snapshot.data[index].rating}.0"
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12)),
                                                      Icon(Icons.star,
                                                          size: 15,
                                                          color: Colors.white)
                                                    ],
                                                  ),
                                                )),
                                          ),
                                    snapshot.data[index].rating == null
                                        ? SmoothStarRating(
                                            rating: 5.0,
                                            isReadOnly: true,
                                            color: Colors.green,
                                            size: 20,
                                            starCount: 5,
                                            onRated: (value) {},
                                          )
                                        : SmoothStarRating(
                                            rating: snapshot.data[index].rating,
                                            isReadOnly: true,
                                            size: 20,
                                            color: Colors.green,
                                            starCount: 5,
                                          )
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      child: snapshot.data[index].status ==
                                              "available"
                                          ? Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.green,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.red,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                  )
                                ],
                              ),
                              Container(
                                width: constraints.maxWidth * 0.2,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      height: 88,
                                      width: constraints.maxWidth * 0.08,
                                      child:
                                          NumberInputPrefabbed.roundedButtons(
                                        controller: _qty[index],
                                        initialValue: snapshot.data[index].qty,
                                        incDecBgColor: Colors.amber,
                                        min: 1,
                                        max: 5,
                                        buttonArrangement:
                                            ButtonArrangement.rightEnd,
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: FlatButton(
                                    //       color: Colors.red,
                                    //       height: 40,
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(30),
                                    //       ),
                                    //       onPressed: () async {
                                    //         SharedPreferences preferences =
                                    //             await SharedPreferences
                                    //                 .getInstance();
                                    //         var useremail =
                                    //             preferences.getString('useremail');
                                    //         var response = await http.post(
                                    //           "http://ecom777.000webhostapp.com/Ecommerce/updatecart.php",
                                    //           body: {
                                    //             "p_id": snapshot
                                    //                 .data[index].product_id
                                    //                 .toString(),
                                    //             "useremail": useremail.toString(),
                                    //             "qty": _qty[index].text,
                                    //           },
                                    //         );

                                    //         setState(() {
                                    //           getCartList();
                                    //         });
                                    //         if (jsonDecode(response.body) ==
                                    //             "success") {
                                    //           setState(() {
                                    //             isLoading = false;
                                    //           });
                                    //           print(response.body);
                                    //           Toast.show(
                                    //             "Added to Cart...",
                                    //             context,
                                    //             backgroundColor: Colors.black,
                                    //             textColor: Colors.white,
                                    //             duration: Toast.LENGTH_LONG,
                                    //           );
                                    //
                                    //         }
                                    //       },
                                    //       child: Text("Update Cart",
                                    //           style: TextStyle(
                                    //               color: Colors.white,
                                    //               fontSize: 15))),
                                    // ),
                                    GestureDetector(
                                        onTap: () async {
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          var useremail = preferences
                                              .getString('useremail');
                                          var response = await http.post(
                                            Uri.parse(
                                              "http://ecom777.000webhostapp.com/Ecommerce/updatecart.php",
                                            ),
                                            body: {
                                              "p_id": snapshot
                                                  .data[index].product_id
                                                  .toString(),
                                              "useremail": useremail.toString(),
                                              "qty": _qty[index].text,
                                              // "subtotal":
                                              //     "${snapshot.data[index].product_price * _qty[index].text}".toString(),
                                            },
                                          );

                                          setState(() {
                                            getCartList();
                                          });
                                          if (jsonDecode(response.body) ==
                                              "success") {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            print(response.body);
                                            Toast.show(
                                              "Qty updated...",
                                              context,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              duration: Toast.LENGTH_LONG,
                                            );
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) {
                                                  return CartPage();
                                                },
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: constraints.maxWidth * 0.12,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                            color: Colors.red,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "Update Cart",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                width: constraints.maxWidth * 0.15,
                                child: IconButton(
                                    tooltip: "delete",
                                    alignment: Alignment.center,
                                    color: Colors.red,
                                    disabledColor: Colors.red,
                                    iconSize: 36,
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      var useremail =
                                          preferences.getString('useremail');
                                      var response = await http.post(
                                        Uri.parse(
                                          "http://ecom777.000webhostapp.com/Ecommerce/deletecartproduct.php",
                                        ),
                                        body: {
                                          "p_id": snapshot
                                              .data[index].product_id
                                              .toString(),
                                          "useremail": useremail.toString(),
                                        },
                                      );

                                      setState(() {
                                        getCartList();
                                      });

                                      if (jsonDecode(response.body) ==
                                          "success") {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        print(response.body);
                                        Toast.show(
                                          "Removed from Cart...",
                                          context,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          duration: Toast.LENGTH_LONG,
                                        );
                                      }
                                      // // Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return CartPage();
                                          },
                                        ),
                                      );
                                    }),
                              ),
                              Container(
                                width: constraints.maxWidth * 0.2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Rs: ${snapshot.data[index].total.toString()}/-",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                      );
                    }),
              ),
              snapshot.data.length == 0
                  ? Container(
                      height: 400,
                      color: Colors.white,
                      child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Your cart is Empty!...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    color: Colors.red,
                                    height: 40,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return Home();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Go to shopping",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    )
                  : Container(
                      height: 120,
                      color: Colors.deepOrange[800],
                      //child: Text( snapshot.data[h].subtotal.toString()),
                      child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2.0, 10, 35, 5),
                                  child: Text(
                                    "Subtotal =  Rs: ${snapshot.data[h].subtotal}/-"
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2.0, 5, 35, 10),
                                  child: FlatButton(
                                    color: Colors.green[500],
                                    height: 40,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    onPressed: () async {
                                      Navigator.push(context,
                                          new MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                          return Checkout();
                                        },
                                      ));
                                      // for (int i = 0; i < l; i++) {

                                      //    SharedPreferences preferences =
                                      //         await SharedPreferences
                                      //             .getInstance();
                                      //     var useremail = preferences
                                      //         .getString('useremail');
                                      //     var response = await http.post(
                                      //       "http://ecom777.000webhostapp.com/Ecommerce/checkout.php",
                                      //       body: {
                                      //         "p_id": snapshot
                                      //             .data[i].product_id
                                      //             .toString(),
                                      //         "useremail": useremail.toString(),
                                      //         "qty": snapshot.data[i].qty.toString(),
                                      //         "product_price": snapshot.data[i].product_price.toString(),
                                      //         "total":l.toString()

                                      //       },
                                      //     );
                                      //     print("hhh");
                                      // }
                                    },
                                    child: Text(
                                      "Checkout",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
            ],
          ),
        );
      },
    );
  }
}
