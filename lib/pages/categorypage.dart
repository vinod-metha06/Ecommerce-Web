import 'package:ecom/pages/cartpage.dart';
import 'package:ecom/user/user_acc.dart';
import 'package:ecom/user/user_login.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:ecom/env.sample.dart';
import 'package:ecom/models/categories.dart';
import 'package:ecom/models/product.dart';
import 'package:ecom/pages/product_details.dart';
import 'package:ecom/pages/search.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:smooth_star_rating/smooth_star_rating.dart';

class CategoryPage extends StatefulWidget {
  String category_id;

  CategoryPage({this.category_id});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Future<List<Categories>> category;
  Future<List<Product>> catproducts;
  String _currentSelectedValue;
  String selectedBrand;
  List brands = List();
  var totalcartitems;

  @override
  void initState() {
    catproducts = _postCatID();

    category = getCategoryList();
    getBrandsList();
    getTottalCartItemsList();
    super.initState();
  }

  void refreshCatList() {
    setState(() {
      catproducts = _postCatID();
    });
  }

  Future<List<Product>> _postCatID() async {
    var response = await http.post(
       Uri.parse(
      "${Env.URL_PREFIXB}/categoryproducts.php",),
      body: {
        "cat_id": "${widget.category_id}".toString(),
        "lowtohigh": _currentSelectedValue.toString(),
        "brands": selectedBrand.toString(),
        // "new": newproduct.toString(),
      },
    );
    print(_currentSelectedValue);
    print(selectedBrand);

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Product> catproducts = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();

    return catproducts;

    // if (response.body.isNotEmpty) {
    //   print("fffffffffffffffffffff");
    //   print(response.body);
    // }
    // if (response.body.isEmpty) {
    //   print("Empty");
    // }
  }

  Future<List<Categories>> getCategoryList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/category.php",),
        headers: {"Accept": "application/json"});

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Categories> category = items.map<Categories>((json) {
      return Categories.fromJson(json);
    }).toList();

    return category;
  }

  Future getBrandsList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/admin/brands.php",),
        headers: {"Accept": "application/json"});
    final jsonbody = response.body;
    final jsonData = json.decode(jsonbody);

    setState(() {
      brands = jsonData;
    });

    print(jsonData);
  }

  Future getTottalCartItemsList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');
    final response = await http
        .post(
           Uri.parse("http://ecom777.000webhostapp.com/Ecommerce/cartqty.php", ),body: {
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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > 600) {
        return _DesktopView();
      } else {
        return _MobileView();
      }
    });
  }

  Widget _DesktopView() {
    return Scaffold(
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
                        return (useremail == null) ? Login() : UserAccount();
                      },
                    ));
                  }),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: ListView(
                shrinkWrap: true,
                // primary: false,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                      height: 50,
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[Colors.purple, Colors.pink])),
                          width: MediaQuery.of(context).size.width,
                          child: CategoriesName(category: category))),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.,
                          children: [
                            Row(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.str,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        65, 10, 2, 10),
                                    child: Text(widget.category_id,
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 26)),
                                  ),
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 40, 10),
                                    child: DropdownButton<String>(
                                        hint: Text("Sort Product By",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 20)),
                                        value: _currentSelectedValue,
                                        isDense: true,
                                        onChanged: (String value) {
                                          setState(() {
                                            _currentSelectedValue = value;
                                            refreshCatList();
                                          });
                                        },
                                        items: [
                                          DropdownMenuItem(
                                            value: "1",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Text(
                                                  "low to high",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: "2",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Text(
                                                  "high to low",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: "3",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Text(
                                                  "New",
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
                                // Align(
                                //   alignment: Alignment.center,
                                //   child: Padding(
                                //     padding: const EdgeInsets.fromLTRB(
                                //         5, 10, 40, 10),
                                //     child: DropdownButtonHideUnderline(
                                //       child: DropdownButton<String>(
                                //         hint: Text("Sort by Brands",
                                //             style: TextStyle(
                                //                 color: Colors.red,
                                //                 fontSize: 20)),
                                //         value: selectedBrand,
                                //         isDense: true,
                                //         onChanged: (String value) {
                                //           setState(() {
                                //             selectedBrand = value;
                                //             refreshCatList();
                                //           });
                                //           //  print(selectedBrand);
                                //         },
                                //         items: brands.map((list) {
                                //           return DropdownMenuItem<String>(
                                //             value: list['brand_title'],
                                //             child: Text(list['brand_title'],
                                //                 style: TextStyle(
                                //                     color: Colors.black,
                                //                     fontSize: 18)),
                                //           );
                                //         }).toList(),
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ProductsWidet(catproducts: catproducts),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _MobileView() {
    return Scaffold(
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
                        return (useremail == null) ? Login() : UserAccount();
                      },
                    ));
                  }),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: ListView(
                shrinkWrap: true,
                // primary: false,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                      height: 50,
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[Colors.purple, Colors.pink])),
                          width: MediaQuery.of(context).size.width,
                          child: CategoriesName(category: category))),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.,
                          children: [
                            Row(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.str,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        25, 10, 2, 10),
                                    child: Text(widget.category_id,
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 22)),
                                  ),
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 35, 10),
                                    child: DropdownButton<String>(
                                        hint: Text("Sort Product By",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 20)),
                                        value: _currentSelectedValue,
                                        isDense: true,
                                        onChanged: (String value) {
                                          setState(() {
                                            _currentSelectedValue = value;
                                            refreshCatList();
                                          });
                                        },
                                        items: [
                                          DropdownMenuItem(
                                            value: "1",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Text(
                                                  "low to high",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: "2",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Text(
                                                  "high to low",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: "3",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Text(
                                                  "New",
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
                                // Align(
                                //   alignment: Alignment.center,
                                //   child: Padding(
                                //     padding: const EdgeInsets.fromLTRB(
                                //         5, 10, 40, 10),
                                //     child: DropdownButtonHideUnderline(
                                //       child: DropdownButton<String>(
                                //         hint: Text("Sort by Brands",
                                //             style: TextStyle(
                                //                 color: Colors.red,
                                //                 fontSize: 20)),
                                //         value: selectedBrand,
                                //         isDense: true,
                                //         onChanged: (String value) {
                                //           setState(() {
                                //             selectedBrand = value;
                                //             refreshCatList();
                                //           });
                                //           //  print(selectedBrand);
                                //         },
                                //         items: brands.map((list) {
                                //           return DropdownMenuItem<String>(
                                //             value: list['brand_title'],
                                //             child: Text(list['brand_title'],
                                //                 style: TextStyle(
                                //                     color: Colors.black,
                                //                     fontSize: 18)),
                                //           );
                                //         }).toList(),
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ProductsWidetMB(catproducts: catproducts),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesName extends StatelessWidget {
  const CategoriesName({
    Key key,
    @required this.category,
  }) : super(key: key);

  final Future<List<Categories>> category;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Categories>>(
      future: category,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            var data = snapshot.data[index];

            return GestureDetector(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.cat_title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushReplacement(context, new MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return CategoryPage(
                      category_id: data.cat_title.toString(),
                    );
                  },
                ));
              },
            );
          },
        );
      },
    );
  }
}

class ProductsWidet extends StatefulWidget {
  const ProductsWidet({
    Key key,
    @required this.catproducts,
  }) : super(key: key);

  final Future<List<Product>> catproducts;

  @override
  _ProductsWidetState createState() => _ProductsWidetState();
}

class _ProductsWidetState extends State<ProductsWidet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.catproducts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        var cato = snapshot.data;

        // Render student lists
        return GridView.builder(
            itemCount: snapshot.data.length,
            physics: NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              var data = snapshot.data[index];
              return GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10.0,
                  child: ClipRRect(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.network(
                              data.img_name,
                              fit: BoxFit.contain,
                              width: 250,
                              height: 180,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.product_title,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontStyle: FontStyle.normal),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Rs: ${data.product_price}",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 22,
                                fontStyle: FontStyle.normal),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              data.rating == null
                                  ? Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                          height: 22,
                                          width: 38,
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
                                            padding: const EdgeInsets.all(3.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                    "${data.rating}.0"
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
                              data.rating == null
                                  ? SmoothStarRating(
                                      rating: 5.0,
                                      isReadOnly: true,
                                      color: Colors.green,
                                      size: 20,
                                      starCount: 5,
                                      onRated: (value) {},
                                    )
                                  : SmoothStarRating(
                                      rating: data.rating,
                                      isReadOnly: true,
                                      size: 20,
                                      color: Colors.green,
                                      starCount: 5,
                                    )
                            ])
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return ProductDetails(
                        product: data,
                      );
                    },
                  ));
                },
              );
            });
      },
    );
  }
}

class ProductsWidetMB extends StatefulWidget {
  const ProductsWidetMB({
    Key key,
    @required this.catproducts,
  }) : super(key: key);

  final Future<List<Product>> catproducts;

  @override
  _ProductsWidetMBState createState() => _ProductsWidetMBState();
}

class _ProductsWidetMBState extends State<ProductsWidetMB> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.catproducts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Align(
              alignment: Alignment.center,
              child: Center(child: CircularProgressIndicator()));
        var cato = snapshot.data;

        // Render student lists
        return GridView.builder(
            itemCount: snapshot.data.length,
            physics: NeverScrollableScrollPhysics(),
            // primary: false,
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              var data = snapshot.data[index];
              return Container(
                color: Colors.red,
                height: 560,
                //width: 40,
                child: GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10.0,
                    child: ClipRRect(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 10.0,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.network(
                                data.img_name,
                                fit: BoxFit.contain,
                                width: 100,
                                height: 80,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              data.product_title,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Rs: ${data.product_price}",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                data.rating == null
                                    ? Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                            height: 18,
                                            width: 34,
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
                                                          fontSize: 10)),
                                                  Icon(Icons.star,
                                                      size: 8,
                                                      color: Colors.white)
                                                ],
                                              ),
                                            )),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Container(
                                            height: 18,
                                            width: 34,
                                            color: Colors.green,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                      "${data.rating}.0"
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10)),
                                                  Icon(Icons.star,
                                                      size: 8,
                                                      color: Colors.white)
                                                ],
                                              ),
                                            )),
                                      ),
                                data.rating == null
                                    ? SmoothStarRating(
                                        rating: 5.0,
                                        isReadOnly: true,
                                        color: Colors.green,
                                        size: 20,
                                        starCount: 5,
                                        onRated: (value) {},
                                      )
                                    : SmoothStarRating(
                                        rating: data.rating,
                                        isReadOnly: true,
                                        size: 20,
                                        color: Colors.green,
                                        starCount: 5,
                                      )
                              ])
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return ProductDetails(
                          product: data,
                        );
                      },
                    ));
                  },
                ),
              );
              // return GestureDetector(
              //   child: Card(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //     elevation: 10.0,
              //     child: ClipRRect(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Card(
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(30),
              //             ),
              //             elevation: 10.0,
              //             child: Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Image.network(
              //                 data.img_name,
              //                 fit: BoxFit.contain,
              //                 width: 120,
              //                 height: 80,
              //               ),
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.all(5.0),
              //             child: Text(
              //               data.product_title,
              //               style: TextStyle(
              //                   color: Colors.red,
              //                   fontSize: 14,
              //                   fontStyle: FontStyle.normal),
              //               textAlign: TextAlign.start,
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.all(5.0),
              //             child: Text(
              //               "Rs: ${data.product_price}",
              //               style: TextStyle(
              //                   color: Colors.red,
              //                   fontSize: 14,
              //                   fontStyle: FontStyle.normal),
              //               textAlign: TextAlign.start,
              //             ),
              //           ),
              //           Row(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 data.rating == null
              //                     ? Padding(
              //                         padding: const EdgeInsets.all(3.0),
              //                         child: Container(
              //                             height: 18,
              //                             width: 34,
              //                             color: Colors.green,
              //                             child: Padding(
              //                               padding: const EdgeInsets.all(3.0),
              //                               child: Row(
              //                                 children: [
              //                                   Text("5.0",
              //                                       style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontWeight:
              //                                               FontWeight.bold,
              //                                           fontSize: 8)),
              //                                   Icon(Icons.star,
              //                                       size: 10,
              //                                       color: Colors.white)
              //                                 ],
              //                               ),
              //                             )),
              //                       )
              //                     : Padding(
              //                         padding: const EdgeInsets.all(3.0),
              //                         child: Container(
              //                             height: 18,
              //                             width: 34,
              //                             color: Colors.green,
              //                             child: Padding(
              //                               padding: const EdgeInsets.all(3.0),
              //                               child: Row(
              //                                 children: [
              //                                   Text(
              //                                       "${data.rating}.0"
              //                                           .toString(),
              //                                       style: TextStyle(
              //                                           color: Colors.white,
              //                                           fontWeight:
              //                                               FontWeight.bold,
              //                                           fontSize: 8)),
              //                                   Icon(Icons.star,
              //                                       size: 10,
              //                                       color: Colors.white)
              //                                 ],
              //                               ),
              //                             )),
              //                       ),
              //                 data.rating == null
              //                     ? SmoothStarRating(
              //                         rating: 5.0,
              //                         isReadOnly: true,
              //                         color: Colors.green,
              //                         size: 20,
              //                         starCount: 5,
              //                         onRated: (value) {},
              //                       )
              //                     : SmoothStarRating(
              //                         rating: data.rating,
              //                         isReadOnly: true,
              //                         size: 20,
              //                         color: Colors.green,
              //                         starCount: 5,
              //                       )
              //               ])
              //         ],
              //       ),
              //     ),
              //   ),
              //   onTap: () {
              //     Navigator.push(context, new MaterialPageRoute<void>(
              //       builder: (BuildContext context) {
              //         return ProductDetails(
              //           product: data,
              //         );
              //       },
              //     ));
              //   },
              // );
            });
      },
    );
  }
}
