import 'package:badges/badges.dart';
import 'package:ecom/admin/adminhome.dart';
import 'package:ecom/admin/insert_product.dart';
import 'package:ecom/admin/loginpage.dart';
import 'package:ecom/models/brands.dart';
import 'package:ecom/models/categories.dart';
import 'package:ecom/models/product.dart';
import 'package:ecom/models/user.dart';
import 'package:ecom/pages/brandpage.dart';
import 'package:ecom/pages/cartpage.dart';
import 'package:ecom/pages/categorypage.dart';
import 'package:ecom/pages/product_details.dart';
import 'package:ecom/pages/search.dart';
import 'package:ecom/user/user_acc.dart';
import 'package:ecom/user/user_login.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<List<Product>> products;
  Future<List<Product>> dealoftheday;
  Future<List<Product>> bestofelectronics;
  Future<List<Product>> topofferson;
  Future<List<Product>> bestsellingphones;
  Future<List<Product>> trending;
  Future<List<Categories>> category;
  Future<List<Brands>> brands;
  Future<List<User>> users;

  var totalcartitems;
  var rating = 5.0;

  final studentListKey = GlobalKey<HomeState>();

  @override
  void initState() {
    super.initState();

    products = getProductList();
    dealoftheday = getdealofthedayList();
    bestofelectronics = getbestofelectronicsList();
    topofferson = gettopoffersonList();
    bestsellingphones = getbestsellingphonesList();

    bestofelectronics = getbestofelectronicsList();
    trending = gettrendingList();
    brands = getBrandsList();

    category = getCategoryList();
    users = getUserList();
    // rate = getRatingList();
    getTottalCartItemsList();
  }

  Future<List<Product>> getdealofthedayList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/dealoftheday.php",),
        headers: {"Accept": "application/json"});

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Product> dealoftheday = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();

    return dealoftheday;
  }

  Future<List<Product>> getbestofelectronicsList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/bestofelectronics.php",),
        headers: {"Accept": "application/json"});

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Product> bestofelectronics = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();

    return bestofelectronics;
  }

  Future<List<Product>> gettopoffersonList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/topofferson.php",),
        headers: {"Accept": "application/json"});

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Product> topofferson = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();

    return topofferson;
  }

  Future<List<Product>> getProductList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/newproducts.php",),
        headers: {"Accept": "application/json"});

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Product> products = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();

    return products;
  }

  Future<List<Product>> getbestsellingphonesList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/bestsellingphones.php",),
        headers: {"Accept": "application/json"});

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Product> bestsellingphones = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();

    return bestsellingphones;
  }

  Future<List<Product>> gettrendingList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/trending.php",),
        headers: {"Accept": "application/json"});

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Product> trending = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();

    return trending;
  }

////  get user details
  Future<List<User>> getUserList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');
    final response = await http.post(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/users/getuser.php",),
        body: {
          "email": useremail.toString(),
        });

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<User> users = items.map<User>((json) {
      return User.fromJson(json);
    }).toList();

    return users;
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

  ///category
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

  Future<List<Brands>> getBrandsList() async {
    final response = await http.get(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/admin/brands.php",),
        headers: {"Accept": "application/json"});

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Brands> brands = items.map<Brands>((json) {
      return Brands.fromJson(json);
    }).toList();

    return brands;
  }

  void refreshStudentList() {
    setState(() {
      products = getProductList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: studentListKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Ecommerce Web'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
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
              padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
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
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
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
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            SharedPreferences preferencesb =
                await SharedPreferences.getInstance();
            var adminemail = preferencesb.getString('adminemail');
            Navigator.push(context, new MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return adminemail == null ? LoginPage() : AdminHome();
              },
            ));
          }),

      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600) {
            return _DesktopView(
                context,
                category,
                products,
                dealoftheday,
                bestofelectronics,
                bestsellingphones,
                brands,
                topofferson,
                trending);
          } else {
            return _MobileView(
                context,
                category,
                products,
                dealoftheday,
                bestofelectronics,
                bestsellingphones,
                brands,
                topofferson,
                trending);
          }
        },
      ),
      // body: SingleChildScrollView(
      //   physics: BouncingScrollPhysics(),
      //   child: Column(
      //     children: [
      //       Container(
      //         child: ListView(
      //           shrinkWrap: true,
      //           // primary: false,
      //           physics: NeverScrollableScrollPhysics(),
      //           children: [
      //             SizedBox(
      //                 height: 50,
      //                 child: Container(
      //                     decoration: BoxDecoration(
      //                         gradient: LinearGradient(
      //                             begin: Alignment.topLeft,
      //                             end: Alignment.bottomRight,
      //                             colors: <Color>[Colors.purple, Colors.pink])),
      //                     width: MediaQuery.of(context).size.width,
      //                     child: CategoriesName(category: category))),
      //             SizedBox(
      //               height: 360,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
      //                     child: Text(
      //                       "New Products",
      //                       style: TextStyle(
      //                           color: Colors.red,
      //                           fontSize: 22,
      //                           fontStyle: FontStyle.normal),
      //                       textAlign: TextAlign.start,
      //                     ),
      //                   ),
      //                   ProductsWidet(products: products)
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 360,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
      //                     child: Text(
      //                       "Deals of the day",
      //                       style: TextStyle(
      //                           color: Colors.red,
      //                           fontSize: 22,
      //                           fontStyle: FontStyle.normal),
      //                       textAlign: TextAlign.start,
      //                     ),
      //                   ),
      //                   DealsWidet(dealoftheday: dealoftheday)
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 360,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
      //                     child: Text(
      //                       "Best of Electronics",
      //                       style: TextStyle(
      //                           color: Colors.red,
      //                           fontSize: 22,
      //                           fontStyle: FontStyle.normal),
      //                       textAlign: TextAlign.start,
      //                     ),
      //                   ),
      //                   BestElectronicsWidet(
      //                       bestofelectronics: bestofelectronics)
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 200,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
      //                     child: Text(
      //                       "Popular Brands",
      //                       style: TextStyle(
      //                           color: Colors.red,
      //                           fontSize: 22,
      //                           fontStyle: FontStyle.normal),
      //                       textAlign: TextAlign.start,
      //                     ),
      //                   ),
      //                   BrandsWidet(brands: brands)
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 360,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
      //                     child: Text(
      //                       "Top offers on",
      //                       style: TextStyle(
      //                           color: Colors.red,
      //                           fontSize: 22,
      //                           fontStyle: FontStyle.normal),
      //                       textAlign: TextAlign.start,
      //                     ),
      //                   ),
      //                   TopOfferWidet(topofferson: topofferson)
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 360,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
      //                     child: Text(
      //                       "Best selling phones",
      //                       style: TextStyle(
      //                           color: Colors.red,
      //                           fontSize: 22,
      //                           fontStyle: FontStyle.normal),
      //                       textAlign: TextAlign.start,
      //                     ),
      //                   ),
      //                   BestSellingPhonesWidet(
      //                       bestsellingphones: bestsellingphones)
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 360,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
      //                     child: Text(
      //                       "Trending",
      //                       style: TextStyle(
      //                           color: Colors.red,
      //                           fontSize: 22,
      //                           fontStyle: FontStyle.normal),
      //                       textAlign: TextAlign.start,
      //                     ),
      //                   ),
      //                   TrendingWidet(trending: trending)
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}

Widget _MobileView(BuildContext context, category, products, dealoftheday,
    bestofelectronics, bestsellingphones, brands, topofferson, trending) {
  return SingleChildScrollView(
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
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Colors.purple, Colors.pink])),
                  width: MediaQuery.of(context).size.width,
                  child: CategoriesNameMB(category: category),
                ),
              ),
              SizedBox(
                height: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "New Products",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    ProductsWidetMB(products: products)
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Deals of the day",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    DealsWidetMB(dealoftheday: dealoftheday)
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Best of Electronics",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    BestElectronicsWidetMB(bestofelectronics: bestofelectronics)
                  ],
                ),
              ),
              SizedBox(
                height: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Popular Brands",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    BrandsWidetMB(brands: brands)
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Top offers on",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    TopOfferWidetMB(topofferson: topofferson)
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Best selling phones",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    BestSellingPhonesWidetMB(
                        bestsellingphones: bestsellingphones)
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Trending",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    TrendingWidetMB(trending: trending)
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget _DesktopView(BuildContext context, category, products, dealoftheday,
    bestofelectronics, bestsellingphones, brands, topofferson, trending) {
  return SingleChildScrollView(
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
              SizedBox(
                height: 360,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "New Products",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    ProductsWidet(products: products)
                  ],
                ),
              ),
              SizedBox(
                height: 360,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Deals of the day",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    DealsWidet(dealoftheday: dealoftheday)
                  ],
                ),
              ),
              SizedBox(
                height: 360,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Best of Electronics",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    BestElectronicsWidet(bestofelectronics: bestofelectronics)
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Popular Brands",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    BrandsWidet(brands: brands)
                  ],
                ),
              ),
              SizedBox(
                height: 360,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Top offers on",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    TopOfferWidet(topofferson: topofferson)
                  ],
                ),
              ),
              SizedBox(
                height: 360,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Best selling phones",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    BestSellingPhonesWidet(bestsellingphones: bestsellingphones)
                  ],
                ),
              ),
              SizedBox(
                height: 360,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(35, 12, 8, 12),
                      child: Text(
                        "Trending",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    TrendingWidet(trending: trending)
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
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
                Navigator.push(context, new MaterialPageRoute<void>(
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

class CategoriesNameMB extends StatelessWidget {
  const CategoriesNameMB({
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
                          fontSize: 18,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context, new MaterialPageRoute<void>(
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

////////////////////

class ProductsWidet extends StatefulWidget {
  const ProductsWidet({
    Key key,
    @required this.products,
  }) : super(key: key);

  final Future<List<Product>> products;

  @override
  _ProductsWidetState createState() => _ProductsWidetState();
}

class _ProductsWidetState extends State<ProductsWidet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.products,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

class ProductsWidetMB extends StatefulWidget {
  const ProductsWidetMB({
    Key key,
    @required this.products,
  }) : super(key: key);

  final Future<List<Product>> products;

  @override
  _ProductsWidetMBState createState() => _ProductsWidetMBState();
}

class _ProductsWidetMBState extends State<ProductsWidetMB> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.products,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                              width: 140,
                              height: 100,
                            ),
                          ),
                        ),
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

///////////////////

class DealsWidet extends StatefulWidget {
  const DealsWidet({
    Key key,
    @required this.dealoftheday,
  }) : super(key: key);

  final Future<List<Product>> dealoftheday;

  @override
  _DealsWidetState createState() => _DealsWidetState();
}

class _DealsWidetState extends State<DealsWidet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.dealoftheday,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

class DealsWidetMB extends StatefulWidget {
  const DealsWidetMB({
    Key key,
    @required this.dealoftheday,
  }) : super(key: key);

  final Future<List<Product>> dealoftheday;

  @override
  _DealsWidetMBState createState() => _DealsWidetMBState();
}

class _DealsWidetMBState extends State<DealsWidetMB> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.dealoftheday,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                              width: 140,
                              height: 100,
                            ),
                          ),
                        ),
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

////////////////////////////

class BrandsWidet extends StatefulWidget {
  const BrandsWidet({
    Key key,
    @required this.brands,
  }) : super(key: key);

  final Future<List<Brands>> brands;

  @override
  _BrandsWidetState createState() => _BrandsWidetState();
}

class _BrandsWidetState extends State<BrandsWidet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Brands>>(
      future: widget.brands,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              var data = snapshot.data[index];

              return GestureDetector(
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 160,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            data.brand_title,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontStyle: FontStyle.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return BrandsPage(
                        brand_id: data.brand_title.toString(),
                      );
                    },
                  ));
                },
              );
            },
          ),
        );
      },
    );
  }
}

class BrandsWidetMB extends StatefulWidget {
  const BrandsWidetMB({
    Key key,
    @required this.brands,
  }) : super(key: key);

  final Future<List<Brands>> brands;

  @override
  _BrandsWidetMBState createState() => _BrandsWidetMBState();
}

class _BrandsWidetMBState extends State<BrandsWidetMB> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Brands>>(
      future: widget.brands,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              var data = snapshot.data[index];

              return GestureDetector(
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: 120,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            data.brand_title,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontStyle: FontStyle.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return BrandsPage(
                        brand_id: data.brand_title.toString(),
                      );
                    },
                  ));
                },
              );
            },
          ),
        );
      },
    );
  }
}

///////////////////////////////

class BestElectronicsWidet extends StatefulWidget {
  const BestElectronicsWidet({
    Key key,
    @required this.bestofelectronics,
  }) : super(key: key);

  final Future<List<Product>> bestofelectronics;

  @override
  _BestElectronicsWidetState createState() => _BestElectronicsWidetState();
}

class _BestElectronicsWidetState extends State<BestElectronicsWidet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.bestofelectronics,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

class BestElectronicsWidetMB extends StatefulWidget {
  const BestElectronicsWidetMB({
    Key key,
    @required this.bestofelectronics,
  }) : super(key: key);

  final Future<List<Product>> bestofelectronics;

  @override
  _BestElectronicsWidetMBState createState() => _BestElectronicsWidetMBState();
}

class _BestElectronicsWidetMBState extends State<BestElectronicsWidetMB> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.bestofelectronics,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                              width: 140,
                              height: 100,
                            ),
                          ),
                        ),
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

///////////////////

class TopOfferWidet extends StatefulWidget {
  const TopOfferWidet({
    Key key,
    @required this.topofferson,
  }) : super(key: key);

  final Future<List<Product>> topofferson;

  @override
  _TopOfferWidetState createState() => _TopOfferWidetState();
}

class _TopOfferWidetState extends State<TopOfferWidet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.topofferson,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

class TopOfferWidetMB extends StatefulWidget {
  const TopOfferWidetMB({
    Key key,
    @required this.topofferson,
  }) : super(key: key);

  final Future<List<Product>> topofferson;

  @override
  _TopOfferWidetMBState createState() => _TopOfferWidetMBState();
}

class _TopOfferWidetMBState extends State<TopOfferWidetMB> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.topofferson,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                              width: 140,
                              height: 100,
                            ),
                          ),
                        ),
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

////////////////////////////////

class BestSellingPhonesWidet extends StatefulWidget {
  const BestSellingPhonesWidet({
    Key key,
    @required this.bestsellingphones,
  }) : super(key: key);

  final Future<List<Product>> bestsellingphones;

  @override
  _BestSellingPhonesWidetState createState() => _BestSellingPhonesWidetState();
}

class _BestSellingPhonesWidetState extends State<BestSellingPhonesWidet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.bestsellingphones,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

class BestSellingPhonesWidetMB extends StatefulWidget {
  const BestSellingPhonesWidetMB({
    Key key,
    @required this.bestsellingphones,
  }) : super(key: key);

  final Future<List<Product>> bestsellingphones;

  @override
  _BestSellingPhonesWidetMBState createState() =>
      _BestSellingPhonesWidetMBState();
}

class _BestSellingPhonesWidetMBState extends State<BestSellingPhonesWidetMB> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.bestsellingphones,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                              width: 140,
                              height: 100,
                            ),
                          ),
                        ),
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

///////////////////////////////

class TrendingWidet extends StatefulWidget {
  const TrendingWidet({
    Key key,
    @required this.trending,
  }) : super(key: key);

  final Future<List<Product>> trending;

  @override
  _TrendingWidetState createState() => _TrendingWidetState();
}

class _TrendingWidetState extends State<TrendingWidet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.trending,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

class TrendingWidetMB extends StatefulWidget {
  const TrendingWidetMB({
    Key key,
    @required this.trending,
  }) : super(key: key);

  final Future<List<Product>> trending;

  @override
  _TrendingWidetMBState createState() => _TrendingWidetMBState();
}

class _TrendingWidetMBState extends State<TrendingWidetMB> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: widget.trending,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        // Render student lists
        return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
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
                              width: 140,
                              height: 100,
                            ),
                          ),
                        ),
                        Text(
                          data.product_title,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Rs: ${data.product_price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontStyle: FontStyle.normal),
                          textAlign: TextAlign.start,
                        ),
                        Row(children: [
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
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
                                            Text("${data.rating}.0".toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                            Icon(Icons.star,
                                                size: 15, color: Colors.white)
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
            },
          ),
        );
      },
    );
  }
}

///////////////////////////
