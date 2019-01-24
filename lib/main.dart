import 'package:flutter/material.dart';
import 'package:government_directory/login.dart';
import 'package:government_directory/signup.dart';
import 'package:government_directory/home.dart';
import 'package:government_directory/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
//importing login page here

void main() => runApp(
  new MaterialApp(
      title: "Government Directory",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto'
      ),
      home: new _main_page(),
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/search': (context) => search_page(),
      },
    ));

class _main_page extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _main_page_state();
}

const String _logged_in_key = 'loggedin';
const String _id_key = 'id';
const String _name_key = 'name';
const String _username_key = 'username';
const String _level_key = 'level';
const String _status_key = 'status';


class _main_page_state extends State<_main_page>{
  bool _logged_in;
  SharedPreferences preferences;

  @override
  void initState(){
    super.initState();


        print('runned');
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      preferences = sp;
      setState(() {
        _logged_in = preferences.getBool(_logged_in_key);
      });

      if (_logged_in == null) {
        //set init value
        _logged_in = false;
        print('init auto log in');

        _auto_log_in(_logged_in); //init here
      } else if (_logged_in == false) {
        print('user not logged in');
      } else {
        //_remove_local_data(_logged_in_key);
        print('user logged in');
        print('logged in user is ${_get_local_data(_name_key)}');

        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

    //init auto log in
  void _auto_log_in(bool value) {
    setState(() {
      _logged_in = value;
    });
    preferences?.setBool(_logged_in_key, value);
  }

    //get pref data
  String _get_local_data(String key) {
    return preferences?.getString(key);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                ),
                // new Container(
                //   height: 60.0,
                //   width: 60.0,
                //   decoration: new BoxDecoration(
                //       borderRadius: new BorderRadius.circular(50.0),
                //       color: Color(0xFF18D191)),
                //   child: new Icon(
                //     Icons.local_offer,
                //     color: Colors.white,
                //   ),
                // ),
                // new Container(
                //   margin: new EdgeInsets.only(right: 50.0, top: 50.0),
                //   height: 60.0,
                //   width: 60.0,
                //   decoration: new BoxDecoration(
                //       borderRadius: new BorderRadius.circular(50.0),
                //       color: Color(0xFFFC6A7F)),
                //   child: new Icon(
                //     Icons.home,
                //     color: Colors.white,
                //   ),
                // ),
                // new Container(
                //   margin: new EdgeInsets.only(left: 30.0, top: 50.0),
                //   height: 60.0,
                //   width: 60.0,
                //   decoration: new BoxDecoration(
                //       borderRadius: new BorderRadius.circular(50.0),
                //       color: Color(0xFFFFCE56)),
                //   child: new Icon(
                //     Icons.local_car_wash,
                //     color: Colors.white,
                //   ),
                // ),
                // new Container(
                //   margin: new EdgeInsets.only(left: 90.0, top: 40.0),
                //   height: 60.0,
                //   width: 60.0,
                //   decoration: new BoxDecoration(
                //       borderRadius: new BorderRadius.circular(50.0),
                //       color: Color(0xFF45E0EC)),
                //   child: new Icon(
                //     Icons.place,
                //     color: Colors.white,
                //   ),
                // )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 50.0),
                  child: new Text(
                    "Government Directory",
                    style: new TextStyle(fontSize: 30.0),
                  ),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0),
                    child: GestureDetector(
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(
                           builder: (context) => LoginPage(),
                         ));
                      },
                      child: new Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          decoration: new BoxDecoration(
                            color: Colors.green,
                             // color: Color(0xFF18D191),
                            //  color: Color(0xFFA5D6A7),
                              borderRadius: new BorderRadius.circular(9.0)),
                          child: new Text("Sign In",
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white))),
                    ),
                  ),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ));
                      },
                    child: new Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        decoration: new BoxDecoration(
                            color: Color(0xFF4364A1),
                            borderRadius: new BorderRadius.circular(9.0)),
                        child: new Text("Sign Up",
                            style: new TextStyle(
                                fontSize: 20.0, color: Colors.white))),
                    )

                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}