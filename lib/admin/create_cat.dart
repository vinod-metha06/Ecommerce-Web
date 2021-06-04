import 'package:ecom/admin/category.dart';
import 'package:ecom/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:http/http.dart' as http;

class CreateCat extends StatefulWidget {
  @override
  _CreateCatState createState() => _CreateCatState();
}

class _CreateCatState extends State<CreateCat> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController catName = new TextEditingController();

  bool isLoading = false;
  bool autoValidate = false;

  saveCat() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      setState(() {
        autoValidate = false;
      });
      _onConfirm(context);
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  // Http post request to create new data
  Future _uploadproduct() async {
    var response = await http.post(
      Uri.parse(
        "http://ecom777.000webhostapp.com/Ecommerce/admin/addcat.php",
      ),
      body: {
        "cat_title": catName.text,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      print(response.body);
      Toast.show(
        "Category Uploaded successfully...",
        context,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        duration: Toast.LENGTH_LONG,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return AllCategories();
          },
        ),
      );
      // }
    }
  }

  void _onConfirm(context) async {
    print(catName);

    await _uploadproduct();

    // Remove all existing routes until the Home.dart, then rebuild Home.
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Category Name'),
      // initialValue: students[1].brand_title.toString(),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      controller: catName,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Add Category')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            SizedBox(
              height: 60,
            ),
            _buildNameField(),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                saveCat();
              },
              child: CustomRaisedButton(buttonText: 'Add Category'),
            ),
            SizedBox(
              height: 60,
            )
          ]),
        ),
      ),
    );
  }
}
