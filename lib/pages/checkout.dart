import 'dart:convert';

import 'package:ecom/models/address.dart';
import 'package:ecom/pages/add_address.dart';
import 'package:ecom/pages/payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  Future<List<Address>> address;
  @override
  void initState() {
    super.initState();
    address = getAddressList();
  }

  Future<List<Address>> getAddressList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');

    final response = await http.post(
       Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/users/address.php",),
        body: {
          "email": useremail.toString(),
        });

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    print(items);
    List<Address> address = items.map<Address>((json) {
      return Address.fromJson(json);
    }).toList();

    return address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 15.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: Colors.green,
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return AddressForm();
                  },
                ));
              },
              child: Text(
                "Add new Address",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text("Choose your Shipping Address..",
                style: TextStyle(color: Colors.black, fontSize: 18)),
          ),
          FutureBuilder(
              future: address,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                return Flexible(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (
                          BuildContext context,
                          int index,
                        ) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  new MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                                  return PaymentPage(
                                    city: snapshot.data[index].city.toString(),
                                    country:
                                        snapshot.data[index].country.toString(),
                                    pincode:
                                        snapshot.data[index].pincode.toString(),
                                    address:
                                        snapshot.data[index].address.toString(),
                                  );
                                },
                              ));
                            },
                            child: Container(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 10.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "City:-  ${snapshot.data[index].city}"
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "Country:-  ${snapshot.data[index].country}"
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "Pincode/Zipcode:-  ${snapshot.data[index].pincode}"
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "Address:-  ${snapshot.data[index].address}"
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }));
              }),
        ],
      ),
    );
  }
}
