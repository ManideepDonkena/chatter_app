import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../groups/arts.dart';
import '../groups/football.dart';
import '../groups/music.dart';
import '../groups/photography.dart';
import '../pages/login_page.dart';

Future Navmain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(NavDrawer());
}

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  var uname = 'hello';
  void initState() {
    // TODO: implement initState
    super.initState();
    //uname = UserSimplePreferences.getUname() ?? 'ok';
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
    return Drawer(
      backgroundColor: Colors.grey[850],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Groups',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.purple[300],
            ),
          ),
          ListTile(
              leading: Icon(
                Icons.sports_basketball,
                color: Colors.white,
              ),
              title: Text(
                'Football',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return FootBall(
                    uname: uname,
                  );
                }));
              }),
          ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              title: Text(
                'Photography',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return Photography(
                    uname: uname,
                  );
                }));
              }),
          ListTile(
              leading: Icon(
                Icons.music_note,
                color: Colors.white,
              ),
              title: Text(
                'Music',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                  return music(
                    uname: uname,
                  );
                }));
              }),
          ListTile(
            leading: Icon(
              Icons.draw,
              color: Colors.white,
            ),
            title: Text(
              'Arts',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return Arts(
                  uname: uname,
                );
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.remove('userName');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return LoginPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}
