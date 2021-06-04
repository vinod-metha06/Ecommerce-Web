import 'dart:convert';
import 'package:ecom/pages/product_details.dart';
import 'package:http/http.dart' as http;
import 'package:ecom/models/product.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<Product>> searchproducts;
  String searchkey;

  @override
  void initState() {
    searchproducts = _search();

    super.initState();
  }

  void initiateSearch() {
    setState(() {
      searchproducts = _search();
    });
  }

  Future<List<Product>> _search() async {
    var response = await http.post(
      Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/search.php",
      ),
      body: {
        "searchkey": searchkey.toLowerCase(),
      },
    );
    print(searchkey.toLowerCase());

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Product> catproducts = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();

    return catproducts;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[50],
      body: ListView(children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: TextField(
              onChanged: (String value) {
                setState(() {
                  searchkey = value;
                  initiateSearch();
                });
                print(searchkey);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search products  eg : Mobiles',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0))),
            ),
          ),
        ),
        FutureBuilder<List<Product>>(
            future: searchproducts,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // By default, show a loading spinner.
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              //var data = snapshot.data;

              return snapshot.data.length == 0
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
                                    "No Products found!🙁️...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )
                  : GridView.builder(
                      itemCount: snapshot.data.length,
                      physics: NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
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
                                  Text(data.product_title),
                                  Text("Rs: ${data.product_price}"),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        data.rating == null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Container(
                                                    height: 22,
                                                    width: 38,
                                                    color: Colors.green,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Row(
                                                        children: [
                                                          Text("5.0",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      12)),
                                                          Icon(Icons.star,
                                                              size: 15,
                                                              color:
                                                                  Colors.white)
                                                        ],
                                                      ),
                                                    )),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Container(
                                                    height: 22,
                                                    width: 38,
                                                    color: Colors.green,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                              "${data.rating}.0"
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      12)),
                                                          Icon(Icons.star,
                                                              size: 15,
                                                              color:
                                                                  Colors.white)
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
            }),
      ]),
    );
  }
}
