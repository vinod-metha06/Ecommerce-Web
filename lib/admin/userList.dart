import 'dart:convert';

import 'package:ecom/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecom/admin/adminhome.dart';
import 'package:ecom/admin/allproducts.dart';
import 'package:ecom/admin/brands.dart';
import 'package:ecom/admin/category.dart';
import 'package:ecom/admin/create_cat.dart';
import 'package:ecom/admin/createbrands.dart';
import 'package:ecom/admin/editbrands.dart';
import 'package:ecom/admin/insert_product.dart';
import 'package:ecom/admin/loginpage.dart';
import 'package:ecom/admin/orders.dart';
import 'package:ecom/models/brands.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Future<List<User>> users;

  @override
  void initState() {
    super.initState();

    users = getBrandsList();
  }

  Future<List<User>> getBrandsList() async {
    final response = await http.get(
        Uri.parse(
          "http://ecom777.000webhostapp.com/Ecommerce/admin/allusers.php",
        ),
        headers: {"Accept": "application/json"});

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<User> brands = items.map<User>((json) {
      return User.fromJson(json);
    }).toList();

    return brands;
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
                            color: Colors.amber[700],
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
                                color: Colors.white,
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          width: constraints.maxWidth * 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Id",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Mobile No.",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder<List<User>>(
                            future: users,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              // By default, show a loading spinner.
                              if (!snapshot.hasData)
                                return Align(
                                    alignment: Alignment.bottomCenter,
                                    child: CircularProgressIndicator());

                              // Render student lists
                              return Flexible(
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.length,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var data = snapshot.data[index];

                                      return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          elevation: 10.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          right: 8,
                                                          top: 8),
                                                  child: Text(
                                                    "ID: ${snapshot.data[index].id.toString()}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                )),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          right: 8,
                                                          top: 8),
                                                  child: Text(
                                                    "Name: ${snapshot.data[index].name.toString()}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                )),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          right: 8,
                                                          top: 8),
                                                  child: Text(
                                                    "Email: ${snapshot.data[index].email.toString()}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                )),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          right: 8,
                                                          top: 8),
                                                  child: Text(
                                                    "Mobile no.: ${snapshot.data[index].mobno.toString()}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                )),
                                              ),
                                            ],
                                          ));
                                    }),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          })),
    );
  }
}
