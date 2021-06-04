import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
import 'package:ecom/user/orderpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/prefer_universal/html.dart' as html;
//import 'package:pdf_test/PdfPreviewScreen.dart'

class OrdersDetails extends StatefulWidget {
  int orderid;

  String img;
  String name;
  String mobno;
  String city;
  int pincode;
  String address;
  String pname;
  int price;
  String brand;
  String status;
  int qty;
  int total;
  int invoiceno;
  String date;
  int p_id;

  OrdersDetails(
      {this.orderid,
      this.img,
      this.name,
      this.mobno,
      this.city,
      this.pincode,
      this.address,
      this.pname,
      this.price,
      this.brand,
      this.status,
      this.qty,
      this.total,
      this.invoiceno,
      this.date,
      this.p_id});

  @override
  _OrdersDetailsState createState() => _OrdersDetailsState();
}

class _OrdersDetailsState extends State<OrdersDetails> {
  final pdf = pw.Document();
  var rating = 0.0;

  void confirmDelete(context) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Do you want to cancel order?",
        confirmBtnText: "Yes",
        onConfirmBtnTap: () => deleteOrders(context),
        confirmBtnColor: Colors.green,
        cancelBtnText: "No",
        onCancelBtnTap: () => Navigator.of(context).pop(),
        confirmBtnTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.0),
        cancelBtnTextStyle: TextStyle(
            color: Colors.red, fontWeight: FontWeight.w600, fontSize: 18.0),
        animType: CoolAlertAnimType.slideInUp);
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       content: Text('Are you sure you want to cancel order?'),
    //       actions: <Widget>[
    //         RaisedButton(
    //           child: Icon(Icons.cancel),
    //           color: Colors.red,
    //           textColor: Colors.white,
    //           onPressed: () => Navigator.of(context).pop(),
    //         ),
    //         RaisedButton(
    //           child: Icon(Icons.check_circle),
    //           color: Colors.blue,
    //           textColor: Colors.white,
    //           onPressed: () => deleteOrders(context),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  deleteOrders(context) async {
    var response = await http.post( Uri.parse(
      "http://ecom777.000webhostapp.com/Ecommerce/users/cancelorder.php",),
      body: {
        "orderid": widget.orderid.toString(),
        "status": "Cancel",
      },
    );
    if (jsonDecode(response.body) == "success") {
      print(response.body);
      Toast.show(
        "Order Cancelled...",
        context,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        duration: Toast.LENGTH_LONG,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return Myorders();
          },
        ),
      );
    }
  }

  writeOnPdf() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
              level: 0,
              child: pw.Text(
                "Invoice",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              )),
          pw.Column(children: [
            pw.Row(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(10.0),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Order No: ${widget.orderid}".toString()),
                      pw.Text("Order Date: ${widget.date}".toString()),
                    ]),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(10.0),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Invoice No: ${widget.invoiceno}".toString()),
                      pw.Text("Invoice Date: ${widget.date}".toString()),
                    ]),
              ),
            ]),
            pw.Divider(height: 2, thickness: 2),
            pw.Row(children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(10.0),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Sold By"),
                      pw.Text("Sold By"),
                      pw.Text("Sold By"),
                    ]),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(10.0),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Shipping ADDRESS",
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text("Name: ${widget.name}".toString()),
                      pw.Text("address: ${widget.address}".toString()),
                      pw.Text("city: ${widget.city}".toString()),
                      pw.Text("pincode: ${widget.pincode}".toString()),
                    ]),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(10.0),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Billing Address",
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text("Name: ${widget.name}".toString()),
                      pw.Text("address: ${widget.address}".toString()),
                      pw.Text("city: ${widget.city}".toString()),
                      pw.Text("pincode: ${widget.pincode}".toString()),
                    ]),
              )
            ]),
            pw.Divider(height: 3, thickness: 2),
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Product",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Description",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Qty",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Gross Amount",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Total",
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ]),
            ),
            pw.Divider(height: 3, thickness: 2),
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Container(
                width: 600,
                child: pw.Row(
                    // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 100,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(8.0, 8, 80, 8),
                          child: pw.Text(
                            widget.pname.toString(),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 150,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(8.0, 8, 80, 8),
                          child: pw.Text(
                            widget.brand.toString(),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 80,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(8.0, 8, 60, 8),
                          child: pw.Text(
                            widget.qty.toString(),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 100,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(15.0, 8, 8, 8),
                          child: pw.Text(
                            "Rs: ${widget.price}/-".toString(),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 100,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(15, 8, 8, 8),
                          child: pw.Text(
                            "Rs: ${widget.total}/-".toString(),
                            textAlign: pw.TextAlign.justify,
                          ),
                        ),
                      )
                    ]),
              ),
            ),
            pw.Divider(height: 3, thickness: 2),
            pw.Padding(
              padding: const pw.EdgeInsets.all(10.0),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "TOTAL QTY: ${widget.qty}".toString(),
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      "Rs: ${widget.total}/-".toString(),
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ]),
            ),
          ]),
        ];
      },
    ));
  }

  Future savePdf() async {
    Uint8List pdfInBytes = pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'OD${widget.invoiceno}.pdf';
    html.document.body.children.add(anchor);
    anchor.click();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Order Details"),
      ),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 10.0,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Delivery Address",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.name.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Mobile Number",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                        child: Text(
                          widget.mobno.toString(),
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
                          "City: ${widget.city}".toString(),
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
                          "Pincode: ${widget.pincode}".toString(),
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
                          "Address: ${widget.address}".toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("More actions",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(widget.invoiceno.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )),
                      ),
                      FlatButton(
                        onPressed: () async {
                          writeOnPdf();
                          await savePdf();
                          //anchor.click();

                          // Directory documentDirectory =
                          //     await getApplicationDocumentsDirectory();
                          // //                           final html.InputElement input = html.document.createElement('input');
                          // // input
                          // //   ..type = 'file'
                          // //   ..accept = 'image/*';

                          // String documentPath = documentDirectory.path;

                          // String fullPath = "$documentPath/example.pdf";
                          print("ccccc");
                        },
                        child: Text(
                          "Download Invoice",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        height: 40,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _status(widget.status),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 10.0,
            child: Row(
              children: [_product(), _tracker(widget.status)],
            ),
          )
        ],
      ),
    );
  }

  Widget _product() {
    return Row(
      children: [
        widget.img != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  width: 160, //20%
                  child: Image.network(
                    widget.img,
                    loadingBuilder: (BuildContext ctx, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Color.fromRGBO(255, 63, 111, 1),
                          ),
                        );
                      }
                    },
                    // fit: BoxFit.fill,
                    fit: BoxFit.contain,
                    // fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              )
            : CircularProgressIndicator(
                backgroundColor: Color.fromRGBO(255, 63, 111, 1),
              ),
        //  Image.network(widget.img),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.pname,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Rs: ${widget.price}".toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            )
          ],
        )
      ],
    );
  }

  Widget _tracker(status) {
    if (status == "Pending") {
      return _tracka();
    } else if (status == "Packed") {
      return _trackb();
    } else if (status == "Shipped") {
      return _trackc();
    } else if (status == "Delivered") {
      return _trackd();
    } else {
      return _trackf();
    }
  }

  rate() async {
    print("GGGgg");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var useremail = preferences.getString('useremail');
    var response = await http.post(
       Uri.parse(
      "http://ecom777.000webhostapp.com/Ecommerce/rate.php",),
      body: {
        "p_id": widget.p_id.toString(),
        "email": useremail.toString(),
        "rate": rating.toString(),
      },
    );
  }

  Widget _status(status) {
    if (status == "Pending") {
      return FlatButton(
        onPressed: () => confirmDelete(context),
        child: Text(
          "Cancel order",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        height: 40,
        color: Colors.red,
      );
    } else if (status == "Packed") {
      return FlatButton(
        onPressed: () => confirmDelete(context),
        child: Text(
          "Cancel order",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        height: 40,
        color: Colors.red,
      );
    } else if (status == "Shipped") {
      return FlatButton(
        onPressed: () => confirmDelete(context),
        child: Text(
          "Cancel order",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        height: 40,
        color: Colors.red,
      );
    } else if (status == "Cancel") {
      return Text('Order Cancelled',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ));
    } else if (status == "Delivered") {
      return Column(
        children: [
          Text(
            "Delivered",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SmoothStarRating(
            rating: rating,
            size: 45,
            starCount: 5,
            onRated: (value) {
              setState(() {
                rating = value;
                print(rating);
                rate();
              });
            },
          )
        ],
      );
    } else {
      return null;
    }
  }

  Widget _tracka() {
    return Row(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 120,
                    child: Text("Ordered",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green))),
                Container(
                    width: 120,
                    child: Text("Packed",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red))),
                Container(
                    width: 120,
                    child: Text("Shipped",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red))),
                Container(
                    width: 120,
                    child: Text("Delivered",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red))),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.blue,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.blue,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.blue,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.blue,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.blue,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.blue,
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _trackb() {
    return Row(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 120,
                    child: Text("Ordered",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green))),
                Container(
                    width: 120,
                    child: Text("Packed",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green))),
                Container(
                    width: 120,
                    child: Text("Shipped",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red))),
                Container(
                    width: 120,
                    child: Text("Delivered",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red))),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.blue,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.blue,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.blue,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.blue,
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _trackc() {
    return Row(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 120,
                    child: Text(
                      "Ordered",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green),
                    )),
                Container(
                    width: 120,
                    child: Text("Packed",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green))),
                Container(
                    width: 120,
                    child: Text("Shipped",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green))),
                Container(
                    width: 120,
                    child: Text("Delivered",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red))),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.red,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.red,
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _trackd() {
    return Row(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 120,
                    child: Text(
                      "Ordered",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green),
                    )),
                Container(
                    width: 120,
                    child: Text("Packed",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green))),
                Container(
                    width: 120,
                    child: Text("Shipped",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green))),
                Container(
                    width: 120,
                    child: Text("Delivered",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green))),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.green,
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _trackf() {
    return Row(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 120,
                    child: Text(
                      "Ordered",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green),
                    )),
                Container(
                  width: 120,
                ),
                Container(
                  width: 120,
                ),
                Container(
                    width: 120,
                    child: Text(
                      "Cancelled",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 4,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.red,
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}

// Widget _tracka() {
//   return Row(
//     children: [
//       Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(width: 120, child: Text("Ordered",textAlign: TextAlign.center,)),
//               Container(width: 120, child: Text("Packed",textAlign: TextAlign.center,)),
//               Container(width: 120, child: Text("Shipped",textAlign: TextAlign.center,)),
//               Container(width: 120, child: Text("Delivered",textAlign: TextAlign.center,)),
//             ],
//           ),
//           Row(
//             children: [
//               Container(
//                 height: 16,
//                 width: 16,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(60),
//                   color: Colors.red,
//                 ),
//               ),
//               Container(
//                 height: 4,
//                 width: 120,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(2),
//                   color: Colors.red,
//                 ),
//               ),
//               Container(
//                 height: 16,
//                 width: 16,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(60),
//                   color: Colors.red,
//                 ),
//               ),
//               Container(
//                 height: 4,
//                 width: 120,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(2),
//                   color: Colors.red,
//                 ),
//               ),
//               Container(
//                 height: 16,
//                 width: 16,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(60),
//                   color: Colors.red,
//                 ),
//               ),
//               Container(
//                 height: 4,
//                 width: 120,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(2),
//                   color: Colors.red,
//                 ),
//               ),
//               Container(
//                 height: 16,
//                 width: 16,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(60),
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           )
//         ],
//       )
//     ],
//   );
// }
