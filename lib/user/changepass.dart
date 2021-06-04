import 'package:ecom/user/user_acc.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:ecom/models/user.dart';
import 'package:ecom/user/user_registration.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();

  final TextEditingController _newPasswordController =
      new TextEditingController();
  User _user = User();

  String newpassword;

  bool isSignedIn = false;
  bool isLoading = false;
  bool autoValidate = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      // resizeToAvoidBottomPadding: false,
      // resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Align(
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 8 / 12,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                  ),
                  // margin: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Form(
                      key: _formkey,
                      autovalidate: true,
                      child: SingleChildScrollView(
                        // scrollDirection: Axis.vertical,
                        // physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 35),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: TextFormField(
                                    controller: _newPasswordController,
                                    obscureText: !_passwordVisible,
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (String value) {
                                      return value.length > 5
                                          ? null
                                          : "Password must be 6 characters";
                                    },
                                    onChanged: (String value) {
                                      setState(() {
                                        _user.password = value;
                                      });
                                    },
                                    //keyboardType: TextInputType.visiblePassword,
                                    cursorColor:
                                        Color.fromRGBO(255, 63, 111, 1),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter old Password',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color:
                                              Color.fromRGBO(255, 63, 111, 1),
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                      icon: Icon(
                                        Icons.lock,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 35),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_passwordVisible,
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (String value) {
                                      return value.length > 5
                                          ? null
                                          : "Password must be 6 characters";
                                    },
                                    onChanged: (String value) {
                                      setState(() {
                                        newpassword = value;
                                      });
                                    },
                                    //keyboardType: TextInputType.visiblePassword,
                                    cursorColor:
                                        Color.fromRGBO(255, 63, 111, 1),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'New Password',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color:
                                              Color.fromRGBO(255, 63, 111, 1),
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                      icon: Icon(
                                        Icons.lock,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 35),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: TextFormField(
                                    obscureText: !_passwordVisible,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "Confirm password is required";
                                      }
                                      if (_passwordController.text != value) {
                                        return "Write Correct Password";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.visiblePassword,
                                    cursorColor:
                                        Color.fromRGBO(255, 63, 111, 1),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Confirm New Password',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color:
                                              Color.fromRGBO(255, 63, 111, 1),
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                      icon: Icon(
                                        Icons.lock,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    resetpassword();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 80, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
    );
  }

  resetpassword() async {
    if (_formkey.currentState.validate()) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var useremail = preferences.getString('useremail');

      setState(() {
        isLoading = true;
      });
      setState(() {
        autoValidate = false;
      });

      var response = await http.post(
         Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/users/resetpass.php",),
        body: {
          "email": useremail.toString(),
          "password": _user.password.toString(),
          "newpassword": newpassword.toString(),
        },
      );

      if (jsonDecode(response.body) == "Success") {
        setState(() {
          isLoading = false;
        });
        Toast.show(
          "Password changed Successfully...",
          context,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          duration: Toast.LENGTH_LONG,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return UserAccount();
            },
          ),
        );
      } else if (jsonDecode(response.body) == "Error") {
        setState(() {
          isLoading = false;
        });
        print(response.body);
        Toast.show(
          "Incorrect Old Password !....",
          context,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          duration: Toast.LENGTH_LONG,
        );
      }
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }
}
