import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

//shared preferences import
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginData {
  String username = '';
  String password = '';
}

const String _logged_in_key = 'loggedin';
const String _id_key = 'id';
const String _name_key = 'name';
const String _username_key = 'username';
const String _level_key = 'level';
const String _status_key = 'status';

class _LoginPageState extends State<LoginPage> {
  bool _logged_in;
  SharedPreferences preferences;

  @override
  void initState() {
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

  //remove pref data
  void _remove_local_data(String key) {
    preferences?.remove(key);
  }

  //set pref data
  void _set_local_data(String key, String value) {
    preferences?.setString(key, value);
  }

  //get pref data
  String _get_local_data(String key) {
    return preferences?.getString(key);
  }

  _LoginData _data = new _LoginData();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String account_error = '';

  bool _is_in_async_call = false;

  void _alert_user() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Account Error'),
            content: new Text(account_error),
            actions: <Widget>[
              new FlatButton(
                child: new Text('close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future _login() async {
    setState(() {
      //tell the app that we are now in the async call
      _is_in_async_call = true;
    });

    var data = jsonEncode({
      'action': 'signin',
      'username': _data.username,
      'password': _data.password
    });

    //make call
    final response =
        await http.post('https://government.co.za/api/account', body: data);

    setState(() {
      _is_in_async_call = false;
    });

    var result = response.body;
    var user = json.decode(response.body);

    //print(result);
    //rint(user);

    if (user['id'] == 'error') {
      setState(() {
        account_error = user['account'];
      });

      //
      _alert_user();
    } else {
      print(user);
      //save user data here
      //enable auto log in her
      _auto_log_in(true);
      _set_local_data(_id_key, user['id']);
      _set_local_data(_name_key, user['name']);
      _set_local_data(_username_key, user['username']);
      _set_local_data(_level_key, user['level']);
      _set_local_data(_status_key, user['status']);

      //Navigator.popAndPushNamed(context, '/home');

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    }
  }

  String _validatePassword(String value) {
    if (value.length < 5) {
      return 'The Password must be atleast 5 characters.';
    }

    return null;
  }

  String _validateusername(String value) {
    if (value.length < 3) {
      return 'username too short';
    }

    return null;
  }

  void submit() {
    //first validate form here
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      _login();

      print('printing the login data');
      print('username: ${_data.username}');
      print('Password: ${_data.password}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: new IconThemeData(color: Colors.green)),
      body: ModalProgressHUD(
        child: Center(
          child: login_body(),
        ),
        inAsyncCall: _is_in_async_call,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(),
      ),
    );
  }

  login_body() => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 50.0),
                  child: Text(
                    'Government Directory',
                    style: TextStyle(fontSize: 30.0),
                  ),
                )
              ],
            ),
            Form(
              key: this._formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0.0),
                    child: new TextFormField(
                      validator: this._validateusername,
                      onSaved: (String value) {
                        this._data.username = value;
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Enter Your username',
                          labelText: 'Username'),
                    ),
                  ),
                  new SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0.0),
                    child: new TextFormField(
                      validator: this._validatePassword,
                      onSaved: (String value) {
                        this._data.password = value;
                      },
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Password',
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  new SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 5.0, top: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        this.submit();
                      },
                      child: new Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          decoration: new BoxDecoration(
                              color: Colors.green,
                              borderRadius: new BorderRadius.circular(9.0)),
                          child: new Text("Login",
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white))),
                    ),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 20.0, top: 10.0),
                    child: new Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        child: new Text("Create A New Account",
                            style: new TextStyle(
                                fontSize: 17.0, color: Color(0xFF18D191)))),
                  ),
                  onTap: () {
                    //go to sign
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                )),
              ],
            ),
          ],
        ),
      );
}
