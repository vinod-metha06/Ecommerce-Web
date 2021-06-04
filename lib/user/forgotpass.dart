import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecom/user/user_login.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  bool autoValidate = false;

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
                                  height: 30,
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 10.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'images/lock.png',
                                      height: 75,
                                      width: 75,
                                      fit: BoxFit.fill,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
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
                                GestureDetector(
                                  onTap: () {
                                    forgotpassword();
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

  forgotpassword() async {
    if (_formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      setState(() {
        autoValidate = false;
      });

      var response = await http.post(
         Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/admin/forgotpass.php",),
        body: {
          "email": emailController.text,
        },
      );

      if (jsonDecode(response.body) == "Success") {
        setState(() {
          isLoading = false;
        });
        Toast.show(
          "Password has sent your email, Please check your inbox!...",
          context,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          duration: Toast.LENGTH_LONG,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Login();
            },
          ),
        );
      } else if (jsonDecode(response.body) == "Error") {
        setState(() {
          isLoading = false;
        });
        print(response.body);
        Toast.show(
          "Enter valid email...",
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
