import 'dart:convert';

import 'package:ecom/models/order.dart';
import 'package:ecom/admin/adminhome.dart';
import 'package:ecom/admin/allproducts.dart';
import 'package:ecom/admin/brands.dart';
import 'package:ecom/admin/category.dart';
import 'package:ecom/admin/create_cat.dart';
import 'package:ecom/admin/createbrands.dart';
import 'package:ecom/admin/insert_product.dart';
import 'package:ecom/admin/loginpage.dart';
import 'package:ecom/admin/orders_details.dart';
import 'package:ecom/admin/userList.dart';
import 'package:ecom/models/order.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Future<List<Order>> orders;
  String _currentSelectedValue;

  @override
  void initState() {
    orders = getAdminOrderList();
    super.initState();
  }

  void refreshOrderList() {
    setState(() {
      orders = getAdminOrderList();
    });
  }

  Future<List<Order>> getAdminOrderList() async {
    final response = await http.post(
        Uri.parse(
          "http://ecom777.000webhostapp.com/Ecommerce/admin/orders.php",
        ),
        body: {"status": _currentSelectedValue.toString()});
    print(_currentSelectedValue.toString());

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
      appBar: AppBar(),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20),
          child: LayoutBuilder(builder: (
            context,
            BoxConstraints constraints,
          ) {
            return Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Colors.indigo, Colors.pink])),
                  // width: MediaQuery.of(context).size.width / 4.5,
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.dashboard,
                            color: Colors.white,
                          ),
                          hoverColor: Colors.red,
                          title: Text('Dashboard',
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return AdminHome();
                                },
                              ),
                            );
                          },

                          //trailing: Text("gggg"),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.category,
                            color: Colors.white,
                          ),
                          hoverColor: Colors.red,
                          title: Text('Categories',
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return AllCategories();
                                },
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.category_outlined,
                            color: Colors.white,
                          ),
                          hoverColor: Colors.red,
                          title: Text('Add Categories',
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return CreateCat();
                                },
                              ),
                            );
                          },
                        ),
                        ListTile(
                            leading: Icon(
                              Icons.branding_watermark,
                              color: Colors.white,
                            ),
                            title: Text('Brands',
                                style: TextStyle(
                                  color: Colors.amber[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return AllBrands();
                                  },
                                ),
                              );
                            }),
                        ListTile(
                          leading: Icon(
                            Icons.branding_watermark_outlined,
                            color: Colors.white,
                          ),
                          title: Text('Add Brands',
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return CreateBrands();
                                },
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.box,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Products',
                            style: TextStyle(
                              color: Colors.amber[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return AllProducts();
                                },
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.boxOpen,
                            color: Colors.white,
                          ),
                          title: Text('Add Products',
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return InsertProduct();
                                },
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: FaIcon(
                            FontAwesomeIcons.users,
                            color: Colors.white,
                          ),
                          title: Text('Users',
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return Users();
                                },
                              ),
                            );
                          },
                        ),
                        ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.shoppingBag,
                              color: Colors.white,
                            ),
                            title: Text('Orders',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return Orders();
                                  },
                                ),
                              );
                            }),
                        ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          title: Text('Logout',
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          onTap: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.remove('adminemail');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext ctx) =>
                                        LoginPage()));
                            Toast.show(
                              "Logout...",
                              context,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              duration: Toast.LENGTH_LONG,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 600,
                  width: constraints.maxWidth * 0.75,
                  child: Column(
                    children: [
                      Container(
                        width: constraints.maxWidth * 0.75,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 40, 10),
                                  child: DropdownButton<String>(
                                      hint: Text("Sort Orders By",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 20)),
                                      value: _currentSelectedValue,
                                      isDense: true,
                                      onChanged: (String value) {
                                        setState(() {
                                          _currentSelectedValue = value;
                                          refreshOrderList();
                                        });
                                      },
                                      items: [
                                        DropdownMenuItem(
                                          value: "Pending",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text(
                                                "Pending",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "Packed",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text(
                                                "Packed",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "Shipped",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text(
                                                "Shipped",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "Delivered",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text(
                                                "Delivered",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "Cancel",
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Text(
                                                "Canceled",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            ]),
                      ),
                      FutureBuilder<List<Order>>(
                          future: orders,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData)
                              return Center(child: CircularProgressIndicator());

                            return Flexible(
                                child: ListView.builder(
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
                                            Navigator.push(context,
                                                new MaterialPageRoute<void>(
                                              builder: (BuildContext context) {
                                                return OrdersDetails(
                                                  orderid: snapshot
                                                      .data[index].order_id,
                                                  img: snapshot
                                                      .data[index].img_name,
                                                  name:
                                                      snapshot.data[index].name,
                                                  mobno: snapshot
                                                      .data[index].mobno,
                                                  city:
                                                      snapshot.data[index].city,
                                                  pincode: snapshot
                                                      .data[index].pincode,
                                                  address: snapshot
                                                      .data[index].address,
                                                  pname: snapshot.data[index]
                                                      .product_title,
                                                  price: snapshot.data[index]
                                                      .product_price,
                                                  brand: snapshot
                                                      .data[index].brand_id,
                                                  status: snapshot
                                                      .data[index].order_status,
                                                  qty: snapshot.data[index].qty,
                                                  total: snapshot
                                                      .data[index].total,
                                                  invoiceno: snapshot
                                                      .data[index].invoice_no,
                                                  date:
                                                      snapshot.data[index].date,
                                                );
                                              },
                                            ));
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            elevation: 10.0,
                                            child: Row(
                                              // mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,

                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width:
                                                        constraints.maxWidth *
                                                            0.15,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            "Invoice No:-  ${snapshot.data[index].invoice_no}"
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        // Text(),
                                                        // Text(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                snapshot.data[index].img_name !=
                                                        null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          height: 150,
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.2, //20%
                                                          child: Image.network(
                                                            snapshot.data[index]
                                                                .img_name,
                                                            loadingBuilder:
                                                                (BuildContext
                                                                        ctx,
                                                                    Widget
                                                                        child,
                                                                    ImageChunkEvent
                                                                        loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              } else {
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    backgroundColor:
                                                                        Color.fromRGBO(
                                                                            255,
                                                                            63,
                                                                            111,
                                                                            1),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            // fit: BoxFit.fill,
                                                            //fit: BoxFit.fill,

                                                            fit: BoxFit.contain,
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                          ),
                                                        ),
                                                      )
                                                    : CircularProgressIndicator(
                                                        backgroundColor:
                                                            Color.fromRGBO(255,
                                                                63, 111, 1),
                                                      ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          snapshot.data[index]
                                                              .product_title
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Brand :- ${snapshot.data[index].brand_id}"
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(children: [
                                                        snapshot.data[index]
                                                                    .rating ==
                                                                null
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: Container(
                                                                    height: 22,
                                                                    width: 38,
                                                                    color: Colors.green,
                                                                    child: Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              3.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              "5.0",
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                                                          Icon(
                                                                              Icons.star,
                                                                              size: 15,
                                                                              color: Colors.white)
                                                                        ],
                                                                      ),
                                                                    )),
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: Container(
                                                                    height: 22,
                                                                    width: 38,
                                                                    color: Colors.green,
                                                                    child: Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              3.0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              "${snapshot.data[index].rating}.0".toString(),
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                                                          Icon(
                                                                              Icons.star,
                                                                              size: 15,
                                                                              color: Colors.white)
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ),
                                                        snapshot.data[index]
                                                                    .rating ==
                                                                null
                                                            ? SmoothStarRating(
                                                                rating: 5.0,
                                                                isReadOnly:
                                                                    true,
                                                                color: Colors
                                                                    .green,
                                                                size: 20,
                                                                starCount: 5,
                                                                onRated:
                                                                    (value) {},
                                                              )
                                                            : SmoothStarRating(
                                                                rating: snapshot
                                                                    .data[index]
                                                                    .rating,
                                                                isReadOnly:
                                                                    true,
                                                                size: 20,
                                                                color: Colors
                                                                    .green,
                                                                starCount: 5,
                                                              )
                                                      ])
                                                      // Text(),
                                                      // Text(),
                                                    ],
                                                  ),
                                                ),

                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Price :- ${snapshot.data[index].product_price}/-"
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Qty :- ${snapshot.data[index].qty}"
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),

                                                      SizedBox(
                                                        height: 10.0,
                                                        child: new Center(
                                                          child: new Container(
                                                            margin:
                                                                new EdgeInsetsDirectional
                                                                        .only(
                                                                    start: 1.0,
                                                                    end: 1.0),
                                                            height: 1.0,
                                                            width: 120,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Total :- ${snapshot.data[index].total}/-"
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: _status(snapshot
                                                      .data[index]
                                                      .order_status),
                                                ),
                                                // }
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    }));
                          }),
                    ],
                  ),
                ),
              ],
            );
          })),
    );
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
