import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:ecom/admin/allproducts.dart';
import 'package:ecom/models/product.dart';
import 'package:ecom/widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:http/http.dart' as http;

class EditProduct extends StatefulWidget {
  final Product product;

  EditProduct({this.product});
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String selectedCat;
  String selectedBrand;
  String _currentStatus;
  String _post;
  List category = List();
  List brands = List();
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

  TextEditingController productName = new TextEditingController();
  TextEditingController productPrice = new TextEditingController();
  TextEditingController productDesc = new TextEditingController();
  //TextEditingController productStatus = new TextEditingController();
  TextEditingController productKeywords = new TextEditingController();

  @override
  void initState() {
    productName.text = widget.product.product_title.toString();
    productPrice.text = widget.product.product_price.toString();
    productDesc.text = widget.product.product_desc.toString();
    productKeywords.text = widget.product.product_keywords.toString();
    selectedBrand = widget.product.brand_id.toString();
    selectedCat = widget.product.cat_id.toString();
    _currentStatus = widget.product.status.toString();
    _post = widget.product.post.toString();

    super.initState();
    getBrandsList();
    getCategoryList();
    print("json");
  }

  Future getCategoryList() async {
    final response = await http.get(
        Uri.parse(
          "http://ecom777.000webhostapp.com/Ecommerce/admin/category.php",
        ),
        headers: {"Accept": "application/json"});
    final jsonbody = response.body;
    final jsonData = json.decode(jsonbody);

    setState(() {
      category = jsonData;
    });
    print(jsonData);
  }

  Future getBrandsList() async {
    final response = await http.get(
        Uri.parse(
          "http://ecom777.000webhostapp.com/Ecommerce/admin/brands.php",
        ),
        headers: {"Accept": "application/json"});
    final jsonbody = response.body;
    final jsonData = json.decode(jsonbody);

    setState(() {
      brands = jsonData;
    });

    print(jsonData);
  }

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

  saveProduct() {
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
        "http://ecom777.000webhostapp.com/Ecommerce/admin/edit_product.php",
      ),
      body: {
        "p_id": widget.product.product_id.toString(),
        "cat_id": selectedCat,
        "brand_id": selectedBrand,
        "product_title": productName.text,
        "product_img": stripped.toString(),
        "img_name": name.toString(),
        "product_price": productPrice.text,
        "product_desc": productDesc.text,
        "status": _currentStatus,
        "product_keywords": productKeywords.text,
        "post": _post
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      print(response.body);
      Toast.show(
        "Product Uploaded successfully...",
        context,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        duration: Toast.LENGTH_LONG,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return AllProducts();
          },
        ),
      );
      // }
    }
  }

  void _onConfirm(context) async {
    print(selectedCat);
    print(selectedBrand);
    print(productName);
    print(name);
    print(_currentStatus);
    print(productPrice);
    print(productDesc);
    print(productKeywords);

    await _uploadproduct();

    // Remove all existing routes until the Home.dart, then rebuild Home.
  }

  _showImage() {
    if (data == null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            widget.product.img_name,
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
      decoration: InputDecoration(labelText: 'Product Name'),
      // initialValue: students[1].brand_title.toString(),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      controller: productName,
    );
  }

  Widget _buildBrandsField() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint: Text("Select Brands",
            style: TextStyle(color: Colors.red, fontSize: 20)),
        value: selectedBrand,
        isDense: true,
        onChanged: (String value) {
          setState(() {
            selectedBrand = value;
          });
          print(selectedBrand);
        },
        items: brands.map((list) {
          return DropdownMenuItem<String>(
            value: list['brand_title'],
            child: Text(list['brand_title'],
                style: TextStyle(color: Colors.black, fontSize: 18)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryField() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint: Text("Select Categories",
            style: TextStyle(color: Colors.red, fontSize: 20)),
        value: selectedCat,
        isDense: true,
        onChanged: (String value) {
          setState(() {
            selectedCat = value;
          });
        },
        items: category.map((list) {
          return DropdownMenuItem<String>(
            value: list['cat_title'],
            child: Text(list['cat_title'],
                style: TextStyle(color: Colors.black, fontSize: 18)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPostField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 40, 10),
      child: DropdownButton<String>(
          hint: Text("Select Home page post",
              style: TextStyle(color: Colors.red, fontSize: 20)),
          value: _post,
          isDense: true,
          onChanged: (String value) {
            setState(() {
              _post = value;
            });
          },
          items: [
            DropdownMenuItem(
              value: "null",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Null",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "dealoftheday",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Deals of the Day🙂️",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "bestofelectronics",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Best of Electronics",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "topofferson",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Top Offers On",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "bestsellingphones",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Best selling Phones",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "trending",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Trending",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Price'),
      // initialValue: _currentFood.price,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      controller: productPrice,
    );
  }

  Widget _buildStatusField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 40, 10),
      child: DropdownButton<String>(
          hint: Text("Select Product status",
              style: TextStyle(color: Colors.red, fontSize: 20)),
          value: _currentStatus,
          isDense: true,
          onChanged: (String value) {
            setState(() {
              _currentStatus = value;
            });
          },
          items: [
            DropdownMenuItem(
              value: "available",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Available🙂️",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: "comingsoon",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Coming Soon",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Widget _buildDescField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Description'),
      // initialValue: _currentFood.desc,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      controller: productDesc,
    );
  }

  Widget _buildProductKeywordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Keywords'),
      // initialValue: students[1].brand_title.toString(),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      controller: productKeywords,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Edit Product')),
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
            Align(
                alignment: Alignment.centerLeft, child: _buildCategoryField()),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildBrandsField(),
            ),

            _buildPriceField(),
            _buildDescField(),
            Align(alignment: Alignment.centerLeft, child: _buildStatusField()),
            _buildProductKeywordField(),
            Align(alignment: Alignment.centerLeft, child: _buildPostField()),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                saveProduct();
              },
              child: CustomRaisedButton(buttonText: 'Add Product'),
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
