// import 'package:ecom/env.sample.dart';
// import 'package:ecom/screens/home.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../models/student.dart';
// import '../widgets/form.dart';

// class Edit extends StatefulWidget {
//   final Student student;

//   Edit({this.student});

//   @override
//   _EditState createState() => _EditState();
// }

// class _EditState extends State<Edit> {
//   // Required for form validations
//   final formKey = GlobalKey<FormState>();

//   // Handles text onchange
//   TextEditingController nameController;
//   TextEditingController ageController;

//   // Http post request to update data
//   Future editStudent() async {
//     return await http.post(
//       "${Env.URL_PREFIX}/update.php",
//       body: {
//         "id": widget.student.id.toString(),
//         "name": nameController.text,
//         "age": ageController.text
//       },
//     );
//   }

//   void _onConfirm(context) async {
//     await editStudent();

//     // Remove all existing routes until the Home.dart, then rebuild Home.
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) {
//           return Home();
//         },
//       ),
//     );
//   }

//   @override
//   void initState() {
//     nameController = TextEditingController(text: widget.student.name);
//     ageController = TextEditingController(text: widget.student.age.toString());
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit"),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: RaisedButton(
//           child: Text('CONFIRM'),
//           color: Colors.blue,
//           textColor: Colors.white,
//           onPressed: () {
//             _onConfirm(context);
//           },
//         ),
//       ),
//       body: Container(
//         height: double.infinity,
//         padding: EdgeInsets.all(20),
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.all(12),
//             child: AppForm(
//               formKey: formKey,
//               nameController: nameController,
//               ageController: ageController,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
