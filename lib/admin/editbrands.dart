import 'package:ecom/admin/brands.dart';
import 'package:ecom/models/brands.dart';
import 'package:ecom/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class EditBrands extends StatefulWidget {
  final Brands brands;
  EditBrands({this.brands});

  @override
  _EditBrandsState createState() => _EditBrandsState();
}

class _EditBrandsState extends State<EditBrands> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController brandName = new TextEditingController();

  bool isLoading = false;
  bool autoValidate = false;

  saveBrand() {
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
      "http://ecom777.000webhostapp.com/Ecommerce/admin/editbrand.php",),
      body: {
        "brand_id": widget.brands.brand_id.toString(),
        "brand_title": brandName.text,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      print(response.body);
      Toast.show(
        "Brand Uploaded successfully...",
        context,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        duration: Toast.LENGTH_LONG,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return AllBrands();
          },
        ),
      );
      // }
    }
  }

  void _onConfirm(context) async {
    print(brandName);

    await _uploadproduct();

    // Remove all existing routes until the Home.dart, then rebuild Home.
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Brand Name'),
      // initialValue: students[1].brand_title.toString(),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      controller: brandName,
    );
  }

  @override
  void initState() {
    brandName.text = widget.brands.brand_title.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Edit Brands')),
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
                saveBrand();
              },
              child: CustomRaisedButton(buttonText: 'Add Brands'),
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
