import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/home.dart';
import './screens/create.dart';
import './screens/details.dart';
import './screens/edit.dart';

Future <void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var useremail = preferences.getString('useremail');
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecommerce Web',
      // initialRoute: '/',
      debugShowCheckedModeBanner: false,
      home: Home(),
      // routes: {
      //   '/': (context) => Home(),
      //   '/create': (context) => Create(),
      //   '/details': (context) => Details(),
      //   '/edit': (context) => Edit(),
      // },
    );
  }
}
