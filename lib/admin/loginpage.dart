import 'dart:convert';

import 'package:ecom/admin/adminhome.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  String _password;

  //bool isSignedIn = false;
  bool isLoading = false;
  bool autoValidate = false;
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 120,
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
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    validator: (String value) {
                                      return value.contains("@")
                                          ? null
                                          : "Enter valid Email";
                                    },
                                    cursorColor:
                                        Color.fromRGBO(255, 63, 111, 1),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Email',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                      icon: Icon(
                                        Icons.email,
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
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (String value) {
                                      return value.length > 5
                                          ? null
                                          : "Password must be 6 characters";
                                    },
                                    onChanged: (String value) {
                                      setState(() {
                                        _password = value;
                                      });
                                    },
                                    //keyboardType: TextInputType.visiblePassword,
                                    cursorColor:
                                        Color.fromRGBO(255, 63, 111, 1),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Password',
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
                                    login();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 80, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "Log In",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
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

  login() async {
    if (_formkey.currentState.validate()) {
      SharedPreferences preferencesb = await SharedPreferences.getInstance();
      preferencesb.setString('adminemail', emailController.text);

      setState(() {
        isLoading = true;
      });
      setState(() {
        autoValidate = false;
      });

      var response = await http.post(
         Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/admin/login.php",),
        body: {
          "email": emailController.text,
          "password": _password.toString(),
        },
      );

      if (jsonDecode(response.body) == "Success") {
        setState(() {
          isLoading = false;
        });
        Toast.show(
          "Login Success...",
          context,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          duration: Toast.LENGTH_LONG,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return AdminHome();
            },
          ),
        );
      } else if (jsonDecode(response.body) == "Error") {
        setState(() {
          isLoading = false;
        });
        print(response.body);
        Toast.show(
          "Email and Password does not match...",
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
