import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:ecom/models/user.dart';
import 'package:ecom/pages/cartpage.dart';
import 'package:ecom/pages/search.dart';
import 'package:ecom/screens/home.dart';
import 'package:ecom/user/changepass.dart';
import 'package:ecom/user/editacc.dart';
import 'package:ecom/user/orderpage.dart';
import 'package:ecom/user/user_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  Future<List<User>> users;
  var totalcartitems;
  @override
  void initState() {
    super.initState();
    getTottalCartItemsList();
    users = getUserList();
  }

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print(
            'Backbutton pressed (device or appbar button), do whatever you want.');

        //Navigator.pop(context, false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Home();
            },
          ),
        );

        return Future.value(false);
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > 600) {
        return _Desktop(totalcartitems: totalcartitems, users: users);
      } else {
        return _MobileView(totalcartitems: totalcartitems, users: users);
      }
    })
    );
  }
}

class _MobileView extends StatelessWidget {
   _MobileView({
    Key key,
    @required this.totalcartitems,
    @required this.users,
  }) : super(key: key);

  var totalcartitems;
  final Future<List<User>> users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          return (useremail == null)
                              ? Login()
                              : UserAccount();
                        },
                      ));
                    }),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: FutureBuilder<List<User>>(
              future: users,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return LayoutBuilder(builder: (
                  context,
                  BoxConstraints constraints,
                ) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 10.0,
                          child: Container(
                            //width: MediaQuery.of(context).size.width / 2.5,
                            width: constraints.maxWidth * 0.90, //20%

                            child: Column(
                              children: [
                                snapshot.data[0].profilepic != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          elevation: 3.0,
                                          child: CircleAvatar(
                                            radius: 40.0,
                                            backgroundImage: NetworkImage(
                                              snapshot.data[0].profilepic,
                                            ),
                                            backgroundColor:
                                                Colors.transparent,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          elevation: 3.0,
                                          child: CircleAvatar(
                                            radius: 40.0,
                                            backgroundImage: AssetImage(
                                                "images/place2.png"),
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2.0,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Hello,",
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
                                            snapshot.data[0].name,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(
                                //     snapshot.data[0].email,
                                //     style: TextStyle(
                                //       fontSize: 18,
                                //       fontWeight: FontWeight.bold,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(
                                //     snapshot.data[0].mobno,
                                //     style: TextStyle(
                                //       fontSize: 18,
                                //       fontWeight: FontWeight.bold,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return Myorders();
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 2.0,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.badge,
                                                  color: Colors.blue,
                                                  size: 30,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "My orders",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return EditAccount(
                                          name: snapshot.data[0].name,
                                          mobno: snapshot.data[0].mobno,
                                          img: snapshot.data[0].profilepic);
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 2.0,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                                size: 30,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Edit Account",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return ChangePassword();
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 2.0,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.security,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Change Password",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    preferences.remove('useremail');
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext ctx) =>
                                                Home()));
                                    Toast.show(
                                      "Logout...",
                                      context,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      duration: Toast.LENGTH_LONG,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 2.0,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.power_settings_new,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Logout",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4.0,
                        child: Container(
                          width: constraints.maxWidth * 0.9, //20%

                          height: MediaQuery.of(context).size.height / 2.0,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      snapshot.data[0].name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.email,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      snapshot.data[0].email,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.phone,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      snapshot.data[0].mobno,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: IconButton(
                                        tooltip: "delete",
                                        alignment: Alignment.center,
                                        color: Colors.red,
                                        disabledColor: Colors.red,
                                        iconSize: 36,
                                        icon: Icon(Icons.delete),
                                        // size: 30,
                                        onPressed: () async {
                                          var response = await http.post(
                                             Uri.parse(
                                            "http://ecom777.000webhostapp.com/Ecommerce/users/delete_account.php",),
                                            body: {
                                              "id": snapshot.data[0].id
                                                  .toString(),
                                            },
                                          );
                                          if (jsonDecode(response.body) ==
                                              "success") {
                                            print(response.body);
                                            Toast.show(
                                              "Account deleted Succesfully...",
                                              context,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              duration: Toast.LENGTH_LONG,
                                            );
                                          }
                                          // // Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (BuildContext context) {
                                                return Home();
                                              },
                                            ),
                                          );
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Delete Account",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                });
              },
            )));
  }
}

class _Desktop extends StatelessWidget {
   _Desktop({
    Key key,
    @required this.totalcartitems,
    @required this.users,
  }) : super(key: key);

  var totalcartitems;
  final Future<List<User>> users;

  @override
  Widget build(BuildContext context) {
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
                          return (useremail == null)
                              ? Login()
                              : UserAccount();
                        },
                      ));
                    }),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: FutureBuilder<List<User>>(
              future: users,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return LayoutBuilder(builder: (
                  context,
                  BoxConstraints constraints,
                ) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 10.0,
                          child: Container(
                            //width: MediaQuery.of(context).size.width / 2.5,
                            width: constraints.maxWidth * 0.38, //20%

                            child: Column(
                              children: [
                                snapshot.data[0].profilepic != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          elevation: 3.0,
                                          child: CircleAvatar(
                                            radius: 40.0,
                                            backgroundImage: NetworkImage(
                                              snapshot.data[0].profilepic,
                                            ),
                                            backgroundColor:
                                                Colors.transparent,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          elevation: 3.0,
                                          child: CircleAvatar(
                                            radius: 40.0,
                                            backgroundImage: AssetImage(
                                                "images/place2.png"),
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2.0,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Hello,",
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
                                            snapshot.data[0].name,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(
                                //     snapshot.data[0].email,
                                //     style: TextStyle(
                                //       fontSize: 18,
                                //       fontWeight: FontWeight.bold,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(
                                //     snapshot.data[0].mobno,
                                //     style: TextStyle(
                                //       fontSize: 18,
                                //       fontWeight: FontWeight.bold,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return Myorders();
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 2.0,
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.badge,
                                                  color: Colors.blue,
                                                  size: 30,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "My orders",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return EditAccount(
                                          name: snapshot.data[0].name,
                                          mobno: snapshot.data[0].mobno,
                                          img: snapshot.data[0].profilepic);
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 2.0,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                                size: 30,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Edit Account",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return ChangePassword();
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 2.0,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.security,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Change Password",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    preferences.remove('useremail');
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext ctx) =>
                                                Home()));
                                    Toast.show(
                                      "Logout...",
                                      context,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      duration: Toast.LENGTH_LONG,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 2.0,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.power_settings_new,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Logout",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10.0,
                        child: Container(
                          width: constraints.maxWidth * 0.5, //20%

                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      snapshot.data[0].name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.email,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      snapshot.data[0].email,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.phone,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      snapshot.data[0].mobno,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: IconButton(
                                        tooltip: "delete",
                                        alignment: Alignment.center,
                                        color: Colors.red,
                                        disabledColor: Colors.red,
                                        iconSize: 36,
                                        icon: Icon(Icons.delete),
                                        // size: 30,
                                        onPressed: () async {
                                          var response = await http.post(
                                             Uri.parse(
                                            "http://ecom777.000webhostapp.com/Ecommerce/users/delete_account.php",),
                                            body: {
                                              "id": snapshot.data[0].id
                                                  .toString(),
                                            },
                                          );
                                          if (jsonDecode(response.body) ==
                                              "success") {
                                            print(response.body);
                                            Toast.show(
                                              "Account deleted Succesfully...",
                                              context,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              duration: Toast.LENGTH_LONG,
                                            );
                                          }
                                          // // Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (BuildContext context) {
                                                return Home();
                                              },
                                            ),
                                          );
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Delete Account",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                });
              },
            )));
  }
}
