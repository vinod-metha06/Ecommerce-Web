import 'dart:convert';
import 'package:ecom/admin/adminhome.dart';
import 'package:ecom/admin/allproducts.dart';
import 'package:ecom/admin/brands.dart';
import 'package:ecom/admin/category.dart';
import 'package:ecom/admin/create_cat.dart';
import 'package:ecom/admin/createbrands.dart';
import 'package:ecom/admin/editproduct.dart';
import 'package:ecom/admin/insert_product.dart';
import 'package:ecom/admin/loginpage.dart';
import 'package:ecom/admin/orders.dart';
import 'package:ecom/admin/userList.dart';
import 'package:ecom/models/product.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

enum LegendShape { Circle, Rectangle }

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  var pending;
  var complete;
  var cancel;
  var activeusers;
  var allusers;
  var totalorders;

  Map<String, double> dataMap = {};
  List<Color> colorList = [
    Colors.blue,
    Colors.green,
    Colors.red,
    // Colors.yellow,
  ];

  LegendShape _legendShape = LegendShape.Circle;

  @override
  void initState() {
    super.initState();
    getTotalOrdersList();
    getPendingOrdersList();
    getCompletedOrdersList();
    getCancelledOrdersList();
    getActiveUserList();
    getAllUserList();

    print("json");
  }

  Future getActiveUserList() async {
    final response = await http.get(
        Uri.parse(
          "http://ecom777.000webhostapp.com/Ecommerce/admin/active_users.php",
        ),
        headers: {"Accept": "application/json"});
    final jsonbody = response.body;
    final jsonData = json.decode(jsonbody);

    setState(() {
      activeusers = jsonData;
    });

    print(jsonData);
  }

  Future getAllUserList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/admin/all_users.php",),
        headers: {"Accept": "application/json"});
    final jsonbody = response.body;
    final jsonData = json.decode(jsonbody);

    setState(() {
      allusers = jsonData;
    });

    print(jsonData);
  }

  Future getTotalOrdersList() async {
    final response = await http.get(

       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/admin/totalorders.php",),
        headers: {"Accept": "application/json"});
    final jsonbody = response.body;
    final jsonData = json.decode(jsonbody);

    setState(() {
      totalorders = jsonData;
    });

    print(jsonData);
  }

  Future getPendingOrdersList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/admin/pendingorders.php",),
        headers: {"Accept": "application/json"});
    final jsonbody = response.body;
    final jsonData = json.decode(jsonbody);

    setState(() {
      pending = jsonData;
    });
    dataMap.addAll({"pending orders": pending});
    print(jsonData);
  }

  Future getCompletedOrdersList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/admin/completedorders.php",),
        headers: {"Accept": "application/json"});
    final jsonbody = response.body;
    final jsonData = json.decode(jsonbody);

    setState(() {
      complete = jsonData;
    });
    dataMap.addAll({"completed orders": complete});
    print(jsonData);
  }

  Future getCancelledOrdersList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/admin/cancelledorder.php",),
        headers: {"Accept": "application/json"});
    final jsonbody = response.body;
    final jsonData = json.decode(jsonbody);

    setState(() {
      cancel = jsonData;
    });
    dataMap.addAll({"cancelled orders": cancel});
    print(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20),
          child: Row(
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ))

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
                        title: Text('Products',
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
                          }),
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
                                color: Colors.amber[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          onTap: () {
                            Navigator.push(
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
                          SharedPreferences preferencesb =
                              await SharedPreferences.getInstance();
                          preferencesb.remove('adminemail');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext ctx) => LoginPage()));
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
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 60,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.indigo,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Total  Users:${allusers.toString()}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 60,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.indigo,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Active Users:${activeusers.toString()}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 60,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.indigo,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Total Orders:${totalorders}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 60,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.indigo,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Pending Orders:${pending.toString()}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 60,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.indigo,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Completed Orders:${complete.toString()}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 60,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.indigo,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Cancelled Orders: ${cancel.toString()}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      complete != null
                          ? Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: PieChart(
                                dataMap: dataMap,
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 3.2,
                                colorList: colorList,
                                initialAngleInDegree: 0,
                                chartType: ChartType.ring,
                                ringStrokeWidth: 32,
                                centerText: "Orders",
                                legendOptions: LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                  showLegends: true,
                                  legendShape:
                                      _legendShape == LegendShape.Circle
                                          ? BoxShape.circle
                                          : BoxShape.rectangle,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: true,
                                  showChartValuesInPercentage: true,
                                  showChartValuesOutside: false,
                                ),
                              ),
                            )
                          : Container()
                    ],
                  )),
                ),
              )
            ],
          ),
        ));
  }
}
