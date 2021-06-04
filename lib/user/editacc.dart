import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:ecom/user/user_acc.dart';
import 'package:ecom/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:http/http.dart' as http;

class EditAccount extends StatefulWidget {
  String name;
  String mobno;
  String img;
  EditAccount({this.name, this.mobno, this.img});

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  // var fullname;
  // var mobno;
  // var img;
  // var pic;
  // var imgname;
  @override
  void initState() {
    fullName.text = widget.name.toString();
    mobno.text = widget.mobno.toString();
    // fullname =
    // mobno =
    // img = widget.img;

    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = '';
  String error;
  Uint8List data;
  var image;
  String imageData;
  File _image;
  File file;
  var stripped;

  bool isLoading = false;
  bool autoValidate = false;

  TextEditingController fullName = new TextEditingController();
  TextEditingController mobno = new TextEditingController();

  pickImage() {
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsDataUrl(input.files[0]);
      reader.onError.listen((err) => setState(() {
            error = err.toString();
          }));
      reader.onLoad.first.then((res) {
        final encoded = reader.result as String;
        // remove data:image/*;base64 preambule
        stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        setState(() {
          name = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
        });
      });
    });

    input.click();
  }

  saveUSER() {
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');
    var response = await http.post(
       Uri.parse(
      "http://ecom777.000webhostapp.com/Ecommerce/users/editacc.php",),
      body: {
        "img": stripped.toString(),
        "img_name": name.toString(),
        "name": fullName.text,
        "mobno": mobno.text,
        "useremail": useremail.toString()
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      print(response.body);
      Toast.show(
        "Account Updated successfully...",
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
      // }
    }
  }

  void _onConfirm(context) async {
    // print(fullname);
    print(mobno);

    await _uploadproduct();

    // Remove all existing routes until the Home.dart, then rebuild Home.
  }

  _showImage() {
    if (data == null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            widget.img,
            //width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 150,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => pickImage(),
          )
        ],
      );
    } else if (data != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.memory(
            data,
            fit: BoxFit.cover,
            height: 150,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => pickImage(),
          )
        ],
      );
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Description'),
      // initialValue: _currentFood.desc,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      controller: fullName,
    );
  }

  Widget _buildMobnoField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Description'),
      // initialValue: _currentFood.desc,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      controller: mobno,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Edit Account')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            // Text(
            //   widget.isUpdating ? "Edit Product" : "Add Product",
            //   textAlign: TextAlign.center,
            //   style: TextStyle(fontSize: 30),
            // ),
            // SizedBox(height: 16),
            // _imageFile == null && _imageUrl == null
            GestureDetector(
              onTap: () => pickImage(),
              child: CustomRaisedButton(buttonText: 'Add Image'),
            ),
            //     : SizedBox(height: 0),
            _buildNameField(),
            _buildMobnoField(),

            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                saveUSER();
              },
              child: CustomRaisedButton(buttonText: 'Confirm'),
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
