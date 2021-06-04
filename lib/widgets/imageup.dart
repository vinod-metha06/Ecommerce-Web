// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class UploadImageDemo extends StatefulWidget {
//   final String title = "Upload image";
//   @override
//   _UploadImageDemoState createState() => _UploadImageDemoState();
// }

// class _UploadImageDemoState extends State<UploadImageDemo> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Upload image"),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(30.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             OutlineButton(
//               onPressed: chooseImage,
//               child: Text("choose Image"),
//             ),
//             SizedBox(height: 20.0,),
//             showImage(),
//             SizedBox(height: 20.0,),
//              OutlineButton(
//               onPressed: startUpload,
//               child: Text("upload Image"),
//             ),
//             Text(status,
//             textAlign: TextAlign.center,)
//           ],
//         ),
//       ),
//     );
//   }
// }
