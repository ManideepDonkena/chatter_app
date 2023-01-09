import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../groups/arts.dart';
import '../groups/cricket.dart';
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
    return Drawer(
      // backgroundColor: Color.fromARGB(148, 12, 239, 239),
      child: Container(
        color: Color.fromARGB(255, 0, 0, 0),
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
                // color: Color.fromARGB(193, 255, 255, 255),
                image: DecorationImage(
                  image: AssetImage('asset/images/forest.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            ListTile(
                leading: Icon(
                  Icons.sports_cricket_sharp,
                  color: Color.fromARGB(248, 255, 0, 157),
                ),
                title: Text(
                  'Cricket',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) {
                    return Cricket(
                      uname: uname,
                    );
                  }));
                }),
            ListTile(
                leading: Icon(
                  Icons.photo_camera_outlined,
                  color: Color.fromARGB(255, 255, 115, 0),
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
                  Icons.library_music_rounded,
                  color: Color.fromARGB(255, 47, 255, 0),
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
                Icons.movie_filter_sharp,
                color: Color.fromARGB(255, 194, 19, 19),
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
                color: Color.fromARGB(255, 243, 32, 32),
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
      ),
    );
  }
}
