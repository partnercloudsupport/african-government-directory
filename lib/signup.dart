import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:validate/validate.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpData {
  String name;
  String user_name;
  String cellphone;
  String email;
  String password;
  String confirm_password;
}

const String _logged_in_key = 'loggedin';
const String _id_key = 'id';
const String _name_key = 'name';
const String _username_key = 'username';
const String _level_key = 'level';
const String _status_key = 'status';

class _SignUpPageState extends State<SignUpPage> {
  bool _logged_in;
  SharedPreferences preferences;

  _SignUpData _data = new _SignUpData();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String account_error = '';

  bool _is_in_async_call = false;

  @override
  void initState() {
    super.initState();
    print('runned');
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      preferences = sp;
      _logged_in = preferences.getBool(_logged_in_key);
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
      }
    });
  }

  //get pref data
  String _get_local_data(String key) {
    return preferences?.getString(key);
  }

  //set pref data
  void _set_local_data(String key, String value) {
    preferences?.setString(key, value);
  }

  //init auto log in
  void _auto_log_in(bool value) {
    setState(() {
      _logged_in = value;
    });
    preferences?.setBool(_logged_in_key, value);
  }

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

  Future _signup() async {
    setState(() {
      //tell the app that we are now in the async call
      _is_in_async_call = true;
    });

    var data = jsonEncode({
      'action': 'signup',
      'username': _data.user_name,
      'name': _data.name,
      'email': _data.email,
      'phonenumber': _data.cellphone,
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

    if (user['id'] == 'error') {
      setState(() {
        account_error = user['error'];
      });

      //
      _alert_user();
    } else {
      print(user);
      _auto_log_in(true);
      _set_local_data(_id_key, user['id']);
      _set_local_data(_name_key, user['name']);
      _set_local_data(_username_key, user['username']);
      _set_local_data(_level_key, user['level']);
      _set_local_data(_status_key, user['status']);

                            Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home', (Route<dynamic> route) => false);
    }
  }

  String _validatePassword(String value) {
    if (value.length < 5) {
      this._data.password = value;

      return 'The Password must be atleast 5 characters.';
    }
    this._data.password = value;

    return null;
  }

  String _validateUsername(String value) {
    if (value.length < 1) {
      return "UserName can't be empty";
    }

    return null;
  }

  String _validateName(String value) {
    if (value.length < 1) {
      return "Name can't be empty";
    }

    return null;
  }

  String _validatePhoneNumber(String value) {
    if (value.length < 1) {
      return "Phonenumber can't be empty";
    }
    return null;
  }

  String _validateConfirmPasssword(String value) {
    //print(this._data.password);
    if (value == '') {
      //print(this._data.password.toString());
      return 'Please confirm password';
    } else {
      if (this._data.password != value) {
        return 'passwords are not the same';
      } else {
        return null;
      }
    }
  }

  String _validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail address must be valid';
    }

    return null;
  }

  void submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      _signup();

      print('printing sign up datat');
      print('password ${_data.password}');
      print('confirm-password ${_data.confirm_password}');
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
            child: sign_up_body(),
          ),
          inAsyncCall: _is_in_async_call,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
        ));
  }

  sign_up_body() => SingleChildScrollView(
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
                  validator: this._validateName,
                  onSaved: (String value) {
                    this._data.name = value;
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Name',
                    labelText: 'Name',
                  ),
                ),
                  ),
                  new SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0.0),
                    child: new TextFormField(
                  validator: this._validateUsername,
                  onSaved: (String value) {
                    this._data.user_name = value;
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Enter UserName',
                    labelText: 'UserName',
                  ),
                ),
                  ),
                  new SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0.0),
                    child: new TextFormField(
                  validator: this._validatePhoneNumber,
                  onSaved: (String value) {
                    this._data.cellphone = value;
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Enter Phonenumber',
                    labelText: 'Phonenumber',
                  ),
                ),
                  ),
                  new SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0.0),
                    child: new TextFormField(
                  validator: this._validateEmail,
                  onSaved: (String value) {
                    this._data.email = value;
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    labelText: 'Email',
                  ),
                ),
                  ),
                  new SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0.0),
                    child: new TextFormField(
                  obscureText: true,
                  validator: this._validatePassword,
                  onSaved: (String value) {
                    this._data.password = value;
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'Password',
                  ),
                ),
                  ),
                  new SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0.0),
                    child: new TextFormField(
                  obscureText: true,
                  validator: this._validateConfirmPasssword,
                  onSaved: (String value) {
                    this._data.confirm_password = value;
                  },
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Re-enter Password',
                    labelText: 'Confirm Password',
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
                          child: new Text("Sign Up",
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
                        child: new Text("Have Account?",
                            style: new TextStyle(
                                fontSize: 17.0, color: Color(0xFF18D191)))),
                  ),
                  onTap: () {
                    //go to sign
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                )),
              ],
            ),
                              new SizedBox(
                    height: 15.0,
                  ),
          ],
        ),
      );
}