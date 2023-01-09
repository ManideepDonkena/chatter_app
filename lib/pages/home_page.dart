import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase_options.dart';
import '../widgets/sidebar_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  var uname = 'hello';
  void initState() {
    super.initState();
    loadCounter();
  }

  void loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uname = prefs.getString('userName') ?? 'ok';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat App'),
          backgroundColor: Colors.black12,
        ),
        backgroundColor: Colors.black26,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
              child: Text(
            "Welcome " + uname + '!',
            style: TextStyle(color: Colors.purple[300], fontSize: 20),
          )),
        ])),
        drawer: NavDrawer());
  }
}
