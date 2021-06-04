import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

class ImagePickerLabPage extends StatefulWidget {
  @override
  _ImagePickerLabPageState createState() => _ImagePickerLabPageState();
}

class _ImagePickerLabPageState extends State<ImagePickerLabPage> {
  String namea = '';
  String nameb = '';
  String namec = '';
  String error;
  Uint8List data;
  Uint8List datb;
  Uint8List datc;
  

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
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        setState(() {
          namea = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
        });
        
        // startuploadImage() {
        //    final encoded = reader.result as String;
        //   final stripped =
        //     encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    
        //   imagoe = base64.encode(stripped);
        //   }

      });
    });

    input.click();
  }

   pickImageb() {
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
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        setState(() {
          nameb = input.files[0].name;
          datb = base64.decode(stripped);
          error = null;
        });
        
        // startuploadImage() {
        //    final encoded = reader.result as String;
        //   final stripped =
        //     encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    
        //   imagoe = base64.encode(stripped);
        //   }

      });
    });

    input.click();
  }
   pickImagec() {
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
        final stripped =
            encoded.replaceFirst(RegExp(r'datc:image/[^;]+;base64,'), '');

        setState(() {
          namec = input.files[0].name;
          datc = base64.decode(stripped);
          error = null;
        });
        
        // startuploadImage() {
        //    final encoded = reader.result as String;
        //   final stripped =
        //     encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    
        //   imagoe = base64.encode(stripped);
        //   }

      });
    });

    input.click();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("name"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              pickImage();
            },
          ),
          IconButton(
            icon: Icon(Icons.camera),
           onPressed: () {
              pickImageb();
            },
          ),
          IconButton(
            icon: Icon(Icons.image),
           onPressed: () {
              pickImagec();
            },
          )
        ],
      ),
      // floatingActionButton:     FloatingActionButton(
      //     child: Icon(Icons.open_in_browser),
      //     onPressed: () {
      //       pickImage();
      //     },
      //   ),
      
      //  Column(
      //         children: [
      //            FloatingActionButton(
      //     child: Icon(Icons.open_in_browser),
      //     onPressed: () {
      //       pickImage();
      //     },
      //   ),
      //    FloatingActionButton(
      //     child: Icon(Icons.open_in_browser),
      //     onPressed: () {
      //       pickImageb();
      //     },
      //   ),
      //    FloatingActionButton(
      //     child: Icon(Icons.open_in_browser),
      //     onPressed: () {
      //       pickImagec();
      //     },
      //   ),
      //         ],
      // ),
      
      // body: Center(
      //   child: error != null
      //       ? Text(error)
      //       : data != null
      //           ? Image.memory(data)
      //           : Text('No data...'),
      // ),
      body: Column(
        children: [
          // Container(
          //   child:  error != null
          //   ? Text(error)
          //   : data != null
          //       ? Image.memory(data)
          //       : Text('No data...'),
          // ),
           Container(
            child:  error != null
            ? Text(error)
            : data != null
                ? Image.memory(datb)
                : Text('No data...'),
          ),
          //  Container(
          //   child:  error != null
          //   ? Text(error)
          //   : data != null
          //       ? Image.memory(datc)
          //       : Text('No data...'),
          // )
        ],
      ),
    );
  }
}
