import 'dart:convert';

import 'package:ecom/models/order.dart';
import 'package:ecom/user/order_details.page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Myorders extends StatefulWidget {
  @override
  _MyordersState createState() => _MyordersState();
}

class _MyordersState extends State<Myorders> {
  Future<List<Order>> orders;

  @override
  void initState() {
    orders = getOrderList();
    super.initState();
  }

  Future<List<Order>> getOrderList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');

    final response = await http.post(
        Uri.parse(
          "http://ecom777.000webhostapp.com/Ecommerce/users/order.php",
        ),
        body: {
          "email": useremail.toString(),
        });

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Order> orders = items.map<Order>((json) {
      return Order.fromJson(json);
    }).toList();

    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Orders"),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600) {
            return Dektopview(orders: orders);
          } else {
            return Mobileview(orders: orders);
          }
        }));
  }
}

class Mobileview extends StatelessWidget {
  const Mobileview({
    Key key,
    @required this.orders,
  }) : super(key: key);

  final Future<List<Order>> orders;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: orders,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                return LayoutBuilder(builder: (
                  context,
                  BoxConstraints constraints,
                ) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return OrdersDetails(
                            orderid: snapshot.data[index].order_id,
                            img: snapshot.data[index].img_name,
                            name: snapshot.data[index].name,
                            mobno: snapshot.data[index].mobno,
                            city: snapshot.data[index].city,
                            pincode: snapshot.data[index].pincode,
                            address: snapshot.data[index].address,
                            pname: snapshot.data[index].product_title,
                            price: snapshot.data[index].product_price,
                            brand: snapshot.data[index].brand_id,
                            status: snapshot.data[index].order_status,
                            qty: snapshot.data[index].qty,
                            total: snapshot.data[index].total,
                            invoiceno: snapshot.data[index].invoice_no,
                            date: snapshot.data[index].date,
                            p_id: snapshot.data[index].product_id,
                          );
                        },
                      ));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10.0,
                      child: Row(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          snapshot.data[index].img_name != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
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
                                      // fit: BoxFit.fill,
                                      fit: BoxFit.contain,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                )
                              : CircularProgressIndicator(
                                  backgroundColor:
                                      Color.fromRGBO(255, 63, 111, 1),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              width: constraints.maxWidth * 0.25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      snapshot.data[index].product_title
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Brand :- ${snapshot.data[index].brand_id}"
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 14,
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
                                                width: 35,
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
                                                              fontSize: 10)),
                                                      Icon(Icons.star,
                                                          size: 10,
                                                          color: Colors.white)
                                                    ],
                                                  ),
                                                )),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Container(
                                                height: 22,
                                                width: 35,
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
                                                              fontSize: 10)),
                                                      Icon(Icons.star,
                                                          size: 10,
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
                                            size: 11,
                                            starCount: 5,
                                            onRated: (value) {},
                                          )
                                        : SmoothStarRating(
                                            rating: snapshot.data[index].rating,
                                            isReadOnly: true,
                                            size: 11,
                                            color: Colors.green,
                                            starCount: 5,
                                          )
                                  ])
                                  // Text(),
                                  // Text(),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: 150,
                              width: constraints.maxWidth * 0.2,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Price :- ${snapshot.data[index].product_price}/-"
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Qty :- ${snapshot.data[index].qty}"
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10.0,
                                    child: new Center(
                                      child: new Container(
                                        margin: new EdgeInsetsDirectional.only(
                                            start: 1.0, end: 1.0),
                                        height: 1.0,
                                        width: 100,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Total :- ${snapshot.data[index].total}/-"
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),

                                  // Text(),
                                  // Text(),
                                ],
                              ),
                            ),
                          ),
                          // if(snapshot.data[index].order_status == "Pending"){
                          //   Text(snapshot.data[index].order_status.toString(),style: TextStyle(color: Colors.amber[700]),)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                                height: 150,
                                width: constraints.maxWidth * 0.22,
                                child:
                                    _status(snapshot.data[index].order_status)),
                          ),
                          // }
                        ],
                      ),
                    ),
                  );
                });
              });
        });
  }

  Widget _status(status) {
    if (status == "Pending") {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.blue,
              ),
            ),
          ),
          Text('Order Pending',
          textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.amber[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ))
        ],
      );
    } else if (status == "Cancel") {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.red,
              ),
            ),
          ),
          Text('Order Cancelled',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ))
        ],
      );
    } else if (status == "Packed") {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.green,
              ),
            ),
          ),
          Text('Order Packed',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ))
        ],
      );
    } else if (status == "Shipped") {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.green,
              ),
            ),
          ),
          Text('Order Shipped',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ))
        ],
      );
    } else {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60), color: Colors.green),
            ),
          ),
          Text(
            "Delivered",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          )
        ],
      );
    }
  }
}

class Dektopview extends StatelessWidget {
  const Dektopview({
    Key key,
    @required this.orders,
  }) : super(key: key);

  final Future<List<Order>> orders;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: orders,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                return LayoutBuilder(builder: (
                  context,
                  BoxConstraints constraints,
                ) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return OrdersDetails(
                            orderid: snapshot.data[index].order_id,
                            img: snapshot.data[index].img_name,
                            name: snapshot.data[index].name,
                            mobno: snapshot.data[index].mobno,
                            city: snapshot.data[index].city,
                            pincode: snapshot.data[index].pincode,
                            address: snapshot.data[index].address,
                            pname: snapshot.data[index].product_title,
                            price: snapshot.data[index].product_price,
                            brand: snapshot.data[index].brand_id,
                            status: snapshot.data[index].order_status,
                            qty: snapshot.data[index].qty,
                            total: snapshot.data[index].total,
                            invoiceno: snapshot.data[index].invoice_no,
                            date: snapshot.data[index].date,
                            p_id: snapshot.data[index].product_id,
                          );
                        },
                      ));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10.0,
                      child: Row(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          snapshot.data[index].img_name != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
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
                                      // fit: BoxFit.fill,
                                      fit: BoxFit.contain,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                )
                              : CircularProgressIndicator(
                                  backgroundColor:
                                      Color.fromRGBO(255, 63, 111, 1),
                                ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data[index].product_title
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Brand :- ${snapshot.data[index].brand_id}"
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20,
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
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                ])
                                // Text(),
                                // Text(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Price :- ${snapshot.data[index].product_price}/-"
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Qty :- ${snapshot.data[index].qty}"
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 10.0,
                                  child: new Center(
                                    child: new Container(
                                      margin: new EdgeInsetsDirectional.only(
                                          start: 1.0, end: 1.0),
                                      height: 1.0,
                                      width: 120,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Total :- ${snapshot.data[index].total}/-"
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                // Text(),
                                // Text(),
                              ],
                            ),
                          ),
                          // if(snapshot.data[index].order_status == "Pending"){
                          //   Text(snapshot.data[index].order_status.toString(),style: TextStyle(color: Colors.amber[700]),)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _status(snapshot.data[index].order_status),
                          ),
                          // }
                        ],
                      ),
                    ),
                  );
                });
              });
        });
  }

  Widget _status(status) {
    if (status == "Pending") {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.blue,
              ),
            ),
          ),
          Text('Order Pending',
              style: TextStyle(
                color: Colors.amber[700],
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ))
        ],
      );
    } else if (status == "Cancel") {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.red,
              ),
            ),
          ),
          Text('Order Cancelled',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ))
        ],
      );
    } else if (status == "Packed") {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.green,
              ),
            ),
          ),
          Text('Order Packed',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ))
        ],
      );
    } else if (status == "Shipped") {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.green,
              ),
            ),
          ),
          Text('Order Shipped',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ))
        ],
      );
    } else {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60), color: Colors.green),
            ),
          ),
          Text(
            "Delivered",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )
        ],
      );
    }
  }
}
