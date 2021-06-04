import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:ecom/models/cart.dart';
import 'package:ecom/models/user.dart';
import 'package:ecom/screens/home.dart';
import 'package:ecom/user/user_acc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  String city;
  String country;
  String address;
  var pincode;

  PaymentPage({this.city, this.country, this.address, this.pincode});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Future<List<User>> users;
  Future<List<Cart>> cart;
  int l = 0;
  var name = '';
  var mobno = '';

  @override
  void initState() {
    users = getUserList();
    cart = getCartList();
    super.initState();
  }

  Future<List<User>> getUserList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');
    final response = await http.post(
        Uri.parse(
          "http://ecom777.000webhostapp.com/Ecommerce/users/getuser.php",
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(alignment: Alignment.center, child: _userdetails()),
            Align(alignment: Alignment.center, child: cartdetails())
          ],
        ),
      ),
    );
  }

  Widget _userdetails() {
    return FutureBuilder<List<User>>(
        future: users,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          name = snapshot.data[0].name.toString();
          mobno = snapshot.data[0].mobno.toString();

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 10.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Customer Name: ${snapshot.data[0].name.toString()}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Customer Email: ${snapshot.data[0].email.toString()}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Mobile number: ${snapshot.data[0].mobno.toString()}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "City: ${widget.city.toString()}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Country: ${widget.country.toString()}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Pincode: ${widget.pincode.toString()}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Address: ${widget.address.toString()}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget cartdetails() {
    return FutureBuilder<List<Cart>>(
        future: cart,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          l = snapshot.data.length;
          print(l);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              color: Colors.red,
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: () async {
                // // Navigator.push(context, new MaterialPageRoute<void>(
                //   builder: (BuildContext context) {
                //     return Home();
                //   },
                // ));
                for (int i = 0; i < l; i++) {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  var useremail = preferences.getString('useremail');
                  var response = await http.post(
                    Uri.parse(
                      "http://ecom777.000webhostapp.com/Ecommerce/checkout.php",
                    ),
                    body: {
                      "p_id": snapshot.data[i].product_id.toString(),
                      "useremail": useremail.toString(),
                      "name": name.toString(),
                      "mobno": mobno.toString(),
                      "qty": snapshot.data[i].qty.toString(),
                      "product_price":
                          snapshot.data[i].product_price.toString(),
                      "total": l.toString(),
                      "city": widget.city.toString(),
                      "country": widget.country.toString(),
                      "pincode": widget.pincode.toString(),
                      "address": widget.address.toString()
                    },
                  );
                  print("hhh");
                }
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: "Order Placed successfully!",
                    confirmBtnText: "OK",
                    onConfirmBtnTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return UserAccount();
                            },
                          ),
                        ),
                    confirmBtnColor: Colors.green,
                    confirmBtnTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0),
                    animType: CoolAlertAnimType.slideInUp);
              },
              child: Text(
                "Pay Offline",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        });
  }
}
