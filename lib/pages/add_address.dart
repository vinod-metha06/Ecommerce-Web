import 'package:ecom/pages/checkout.dart';
import 'package:flutter/material.dart';
import 'package:ecom/widgets/custom_raised_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class AddressForm extends StatefulWidget {
  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  TextEditingController city = new TextEditingController();
  TextEditingController country = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController pincode = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Address')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _buildCityField(),
            _buildCountryField(),
            _buildPinField(),
            _buildAddressField(),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                saveAddress();
              },
              child: CustomRaisedButton(buttonText: 'Add Address'),
            ),
            SizedBox(
              height: 60,
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'City Name'),
      // initialValue: students[1].brand_title.toString(),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      controller: city,
    );
  }

  Widget _buildCountryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Country Name'),
      // initialValue: students[1].brand_title.toString(),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      controller: country,
    );
  }

  Widget _buildPinField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'PIN code'),
      // initialValue: students[1].brand_title.toString(),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      controller: pincode,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Address'),
      // initialValue: students[1].brand_title.toString(),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      controller: address,
    );
  }

  saveAddress() {
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
  Future _uploadAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');
    var response = await http.post(
       Uri.parse(
      "http://ecom777.000webhostapp.com/Ecommerce/users/addadrress.php",),
      body: {
        "city": city.text,
        "country": country.text,
        "address": address.text,
        "pincode": pincode.text,
        "email": useremail.toString(),
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      print(response.body);
      Toast.show(
        "Address Uploaded successfully...",
        context,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        duration: Toast.LENGTH_LONG,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return Checkout();
          },
        ),
      );
    }
  }

  void _onConfirm(context) async {
    print(city.text);
    print(country.text);
    print(pincode.text);
    print(address.text);

    await _uploadAddress();

    // Remove all existing routes until the Home.dart, then rebuild Home.
  }
}
