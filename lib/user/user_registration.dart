import 'dart:convert';

import 'package:ecom/screens/home.dart';
import 'package:ecom/user/user_login.dart';
import 'package:flutter/material.dart';
import 'package:ecom/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  var _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController mobnumber = new TextEditingController();

  bool autoValidate = false;

  bool isLoading = false;
  bool _passwordVisible = false;

  User _user = User();
  final TextEditingController emailController = new TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
  }

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
                                    keyboardType: TextInputType.text,
                                    validator: (String value) {
                                      return value.length > 0
                                          ? null
                                          : "Enter valid Name";
                                    },
                                    onChanged: (String value) {
                                      setState(() {
                                        _user.name = value;
                                      });
                                    },
                                    cursorColor:
                                        Color.fromRGBO(255, 63, 111, 1),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Full Name',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                      icon: Icon(
                                        Icons.person,
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
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    validator: (String value) {
                                      return value.contains("@")
                                          ? null
                                          : "Enter valid Email";
                                    },
                                    // onChanged: (String value) {
                                    //   setState(() {
                                    //     _user.email = value;
                                    //   });
                                    // },
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
                                    keyboardType: TextInputType.number,
                                    controller: mobnumber,
                                    validator: (mobnumber) {
                                      return mobnumber.length == 10
                                          ? null
                                          : "Enter valid mobile number";
                                    },
                                    // onChanged: (String value) {
                                    //   setState(() {
                                    //     _user.mobno = value;
                                    //   });
                                    // },
                                    cursorColor:
                                        Color.fromRGBO(255, 63, 111, 1),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Mobile Number',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                      icon: Icon(
                                        Icons.phone,
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
                                        _user.password = value;
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
                                        print("Confirm password is required");
                                      }
                                      if (_passwordController.text != value) {
                                        return "Write Correct Password";
                                        print("Write Correct Password");
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.visiblePassword,
                                    cursorColor:
                                        Color.fromRGBO(255, 63, 111, 1),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Confirm Password',
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
                                    signup();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 80, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(255, 63, 111, 1),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 60,
                                ), //LOGIN BUTTON
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Already a registered user?',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //        Navigator.push(
                                        // context,
                                        // PageTransition(
                                        //     type: PageTransitionType.size,alignment: Alignment.bottomLeft,
                                        //     duration: Duration(microseconds: 880),
                                        //     child:LogInSide()
                                        //     ));
                                        //       // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) => LogInSide()));
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Login()));
                                      },
                                      child: Container(
                                        child: Text(
                                          'Log In here',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
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

  signup() async {
    if (_formkey.currentState.validate()) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('useremail', emailController.text);

      setState(() {
        isLoading = true;
      });
      setState(() {
        autoValidate = false;
      });

      var response = await http.post(
         Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/users/register.php",),
        body: {
          "name": _user.name.toString(),
          "email": emailController.text,
          "password": _user.password.toString(),
          "mobno": mobnumber.text,
          "profilepic": "",
        },
      );

      if (jsonDecode(response.body) == "Error") {
        setState(() {
          isLoading = false;
        });
        Toast.show(
          "Account Already Exists...",
          context,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          duration: Toast.LENGTH_LONG,
        );
      } else if (jsonDecode(response.body) == "success") {
        setState(() {
          isLoading = false;
          logintime();
        });
        print(response.body);
        Toast.show(
          "Registration successfull...",
          context,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          duration: Toast.LENGTH_LONG,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Home();
            },
          ),
        );
      }
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  logintime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('useremail', emailController.text);

    var response = await http.post(
       Uri.parse(
      "http://ecom777.000webhostapp.com/Ecommerce/admin/logintime.php",),
      body: {
        "email": emailController.text,
      },
    );
  }
}
