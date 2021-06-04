import 'dart:convert';
import 'package:ecom/admin/adminhome.dart';
import 'package:ecom/admin/allproducts.dart';
import 'package:ecom/admin/brands.dart';
import 'package:ecom/admin/create_cat.dart';
import 'package:ecom/admin/createbrands.dart';
import 'package:ecom/admin/edit_cat.dart';
import 'package:ecom/admin/insert_product.dart';
import 'package:ecom/admin/loginpage.dart';
import 'package:ecom/admin/orders.dart';
import 'package:ecom/admin/userList.dart';
import 'package:ecom/models/categories.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AllCategories extends StatefulWidget {
  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  Future<List<Categories>> category;

  @override
  void initState() {
    super.initState();

    category = getCategoryList();
  }

  Future<List<Categories>> getCategoryList() async {
    final response = await http.get(
        Uri.parse(
          "http://ecom777.000webhostapp.com/Ecommerce/category.php",
        ),
        headers: {"Accept": "application/json"});

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Categories> category = items.map<Categories>((json) {
      return Categories.fromJson(json);
    }).toList();

    return category;
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
                                color: Colors.white,
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
                                  "Category Id",
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
                                  "Category Name",
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
                                  "Edit Category",
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
                                  "Delete Category ",
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
                        FutureBuilder<List<Categories>>(
                            future: category,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              // By default, show a loading spinner.
                              if (!snapshot.hasData)
                                return Center(
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
                                                    "ID: ${snapshot.data[index].cat_id.toString()}",
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
                                                    "Name: ${snapshot.data[index].cat_title.toString()}",
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
                                                  width: 80,
                                                  child: IconButton(
                                                      tooltip: "edit",
                                                      alignment:
                                                          Alignment.center,
                                                      color: Colors.blue,
                                                      disabledColor: Colors.red,
                                                      iconSize: 32,
                                                      icon: Icon(Icons.edit),
                                                      onPressed: () {
                                                        // // Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return EditCat(
                                                                category: data,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: 80,
                                                  child: IconButton(
                                                      tooltip: "delete",
                                                      alignment:
                                                          Alignment.center,
                                                      color: Colors.red,
                                                      disabledColor: Colors.red,
                                                      iconSize: 36,
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () async {
                                                        var response =
                                                            await http.post(
                                                          Uri.parse(
                                                            "http://ecom777.000webhostapp.com/Ecommerce/admin/deletecat.php",
                                                          ),
                                                          body: {
                                                            "cat_id": snapshot
                                                                .data[index]
                                                                .cat_id
                                                                .toString(),
                                                          },
                                                        );

                                                        setState(() {
                                                          getCategoryList();
                                                        });

                                                        if (jsonDecode(response
                                                                .body) ==
                                                            "success") {
                                                          print(response.body);
                                                          Toast.show(
                                                            "Category Deleted Successfully...",
                                                            context,
                                                            backgroundColor:
                                                                Colors.black,
                                                            textColor:
                                                                Colors.white,
                                                            duration: Toast
                                                                .LENGTH_LONG,
                                                          );
                                                        }
                                                        // // Navigator.pop(context);
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AllCategories();
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                ),
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
