import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:government_directory/models/GovCategory.dart';
import 'package:government_directory/models/Province.dart';
//import 'flutter_select.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class add_advert extends StatefulWidget{
  
  @override
  _add_advert createState() => _add_advert();
}

class _add_advert extends State<add_advert>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffold_key,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Add Advert'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),),
      backgroundColor: Colors.green,
      ),
      //body: _form_view,
      body: ModalProgressHUD(
        child: Center(
          child: Container(
                margin: EdgeInsets.all(8.0),
    padding: EdgeInsets.all(8.0),
    child: SingleChildScrollView(
      child: Form(
        key: _form_key,
        child: Column(
          children: <Widget>[
            _name_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _physical_address_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _postal_address_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _telephone_number_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _mobile_number_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _fax_number_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _email_address_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _company_website_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _about_us_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _category_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _province_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
          new SizedBox(
            width: double.infinity,
            child: submit_advert_button(),
          ),
            //submit_advert(),

            // Padding(
            //   padding: EdgeInsets.only(top: 10.0),
            //   child: submit_advert(),
            // ),
          ],
        ),
      ),
    ),
          ),
        ),
        progressIndicator: CircularProgressIndicator(),
        inAsyncCall: _is_in_async_call,
        opacity: 0.5,
      ),
    );
  }

  //logged in user id
  String user_id;

    //string province_id
   String province_id;
  //string government business category
   String category_id;


  //local database storage
  SharedPreferences _preferences;

  //sending company information to the server
  bool _is_in_async_call = false;

  //scaffold key
  static final GlobalKey<ScaffoldState> _scaffold_key = new GlobalKey<ScaffoldState>();

  //form controllers
static TextEditingController _name_controller = new TextEditingController();
static TextEditingController _physical_address_controller = new TextEditingController();
static TextEditingController _postal_address_controller = new TextEditingController();
static TextEditingController _telephone_number_controller = new TextEditingController();
static TextEditingController _mobile_number_controller = new TextEditingController();
static TextEditingController _fax_number_controller = new TextEditingController();
static TextEditingController _email_address_controller = new TextEditingController();
static TextEditingController _company_website_controller = new TextEditingController();
static TextEditingController _about_us_controller = new TextEditingController();
//static ItemSelectingController _category_controller = new ItemSelectingController();
static TextEditingController _category_controller = new TextEditingController();
static TextEditingController _province_controller = new TextEditingController();

static double _space_between_fields = 10.0;

//focus nodes
static FocusNode _province_focus = new FocusNode();
static FocusNode _bussiness_category_focus = new FocusNode();
static FocusNode _about_company_focus = new FocusNode();

//focus nodes controllers
bool _province_focus_active = false;
bool _business_category_focus_active = false;

//bool in foc
bool clicked = false;

//bool loading provinces
bool _provinces_loaded = false;

//bool loading business/government categories
bool _categories_loaded = false;


static List<GovCategory> Government_categories = [];

static List<Province> Provinces = [];


_call_snackbar(message){
  final snackBar = SnackBar(
    content: Text(message),
  );

  _scaffold_key.currentState.showSnackBar(snackBar);
}

@override
void initState(){
super.initState();

print('entered');
get_all_cats();
get_all_provinces();
//_province_focus = new FocusNode();
_province_focus.addListener(_on_province_form_field_click);

//_bussiness_category_focus = new FocusNode();
_bussiness_category_focus.addListener(_on_business_category_form_field_click);

SharedPreferences.getInstance().then((SharedPreferences sp){
  _preferences = sp;
  setState(() {
      user_id = _preferences.getString('id');
    });
});
}

  get_all_cats(){
    String server_categories = '[{"id":"11","name":"Ultimate Business in Africa"},{"id":"12","name":"Government Departments"},{"id":"13","name":"Local Government"},{"id":"14","name":"Municipalities"},{"id":"15","name":"Government Services"},{"id":"16","name":"Development Organisations"},{"id":"17","name":"Educational Institutions"},{"id":"18","name":"Social Services"},{"id":"19","name":"Government and Law"},{"id":"20","name":"Youth and Community Groups"},{"id":"21","name":"Immigration Services"},{"id":"22","name":"Charitable Services"},{"id":"23","name":"Retirement Homes"},{"id":"24","name":"Rehabilitation"},{"id":"25","name":"Bodies and Structures"}]';

    setState((){
    Government_categories = parse_category(server_categories);
    });

    print(Government_categories);
  }

  static List<GovCategory> parse_category(String responseBody){
    final parsed_data = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed_data.map<GovCategory>((json) => GovCategory.fromjson(json)).toList();
  }


  get_all_provinces(){
    String server_provinces = '[{"id":"1","name":"Eastern Cape"},{"id":"2","name":"Freestate"},{"id":"3","name":"Gauteng"},{"id":"4","name":"Kwazulu Natal"},{"id":"5","name":"Limpopo Province"},{"id":"6","name":"Mpumalanga"},{"id":"7","name":"Northern Cape"},{"id":"8","name":"North West province"},{"id":"9","name":"Western Cape"}]';

    setState((){
      Provinces = parse_provinces(server_provinces);
    });

    print(Provinces);
  }

  static List<Province> parse_provinces(String responseBody){
    final parsed_data = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed_data.map<Province>((json) => Province.fromjson(json)).toList();
  }

    Future _server_call_save_business_info() async{
    setState((){
      _is_in_async_call = true;
    });
    var data = jsonEncode({'name': _name_controller.text,'address':_physical_address_controller.text,'paddress':_postal_address_controller.text,'telephone':_telephone_number_controller.text,'mobile':_mobile_number_controller.text,'fax':_fax_number_controller.text,'email':_email_address_controller.text,'website':_company_website_controller.text,'about_us':_about_us_controller.text,'user_id':user_id,'province_id':province_id,'category_id':category_id});
    //var request_duration = new Duration(minutes: 2);
    //making call
    // final response = await http.post('https://government.co.za/api/add_new_listing',body: data).then((value){
    //   print('company created it id is ${value.body}');
    //   setState((){
    //     _is_in_async_call = false;
    //   });
    // }).catchError((error){
    //   setState((){
    //     _is_in_async_call = false;
    //   });
    //   print(error);
    // });

    // final response = await http.post('https://government.co.za/api/add_new_listing',body: data).then((value){
    //   print('company created it id is ${value.body}');
    // }).catchError((error){
    //   setState((){
    //     _is_in_async_call = false;
    //   });
    //   print(error);
    // }).whenComplete((){
    //   setState((){
    //     _is_in_async_call = false;
    //   });
    // });
    
    //print(data);
    final response = await http.post('https://government.co.za/api/add_new_listing',body: data).then((response){
      setState(() {
        _is_in_async_call = false;
      });

      _call_snackbar(_name_controller.text.toUpperCase() + ' Has Been Added!');
      _clear_fields();
      
      var result = response.body;
      var company = json.decode(result);
      print('new company id ${company}');
    }).catchError((error){
      print(error);
      setState(() {
        _is_in_async_call = false;
      });
    });
  }

  _clear_fields(){
    _name_controller.clear();
    _physical_address_controller.clear();
    _postal_address_controller.clear();
    _telephone_number_controller.clear();
    _mobile_number_controller.clear();
    _fax_number_controller.clear();
    _email_address_controller.clear();
    _company_website_controller.clear();
    _about_us_controller.clear();
    _category_controller.clear();
    _province_controller.clear();
  }


 @override
 void dispose(){
 _province_focus = new FocusNode();
 _bussiness_category_focus = new FocusNode();
 _about_company_focus = new FocusNode();
 
  //clearing form data
  _name_controller.clear();
  _physical_address_controller.clear();
  _postal_address_controller.clear();
  _telephone_number_controller.clear();
  _mobile_number_controller.clear();
  _fax_number_controller.clear();
  _email_address_controller.clear();
  _company_website_controller.clear();
  _about_us_controller.clear();
  _category_controller.clear();
  _province_controller.clear();

  super.dispose();
 }

//focus events
void _on_province_form_field_click(){
  if(_province_focus.hasFocus){
    showDialog(
      barrierDismissible: false,
      context: _scaffold_key.currentContext,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('choose province'),
          content: set_up_province_dialog(),
          actions: <Widget>[
            new FlatButton(
              child: Text('close'),
              onPressed: (){
                _province_focus.unfocus();
                Navigator.of(_scaffold_key.currentContext).pop();
              },
            ),
          ],
        );
      }
    );
  }else{

  }
  
  // if(_province_focus_active){
  //   setState((){
  //     _province_focus_active = false;
  //   });
  // }
  // else{
  //   print('province form field has been clicked');
  //   setState((){
  //     _province_focus_active = true;
  //   });
  // }

  // if(_province_focus_active){
  //   setState((){
  //     clicked = true;
  //   });



    // showDialog(
    //   barrierDismissible: false,
    //   context: _scaffold_key.currentContext,
    //   builder: (BuildContext context){
    //     return _province_dialog;
    //   }
    // );
  //}
}

void _on_business_category_form_field_click(){
  if(_bussiness_category_focus.hasFocus){
    showDialog(
      barrierDismissible: false,
      context: _scaffold_key.currentContext,
      builder: (BuildContext context){
                return AlertDialog(
          title: Text('Choose Business Category'),
          content: set_up_categories_dialog(),
          actions: <Widget>[
            new FlatButton(
              child: Text('close'),
              onPressed: (){
                _bussiness_category_focus.unfocus();
                Navigator.of(_scaffold_key.currentContext).pop();
                },
            ),
          ],
        );
      },
    );
  }else{
    
  }

  // if(_business_category_focus_active){
  //   setState((){
  //     _business_category_focus_active = false;
  //   });
  // }
  // else{
  //   print('business category form field has been clicked');
  //   setState((){
  //     _business_category_focus_active = true;
  //   });
  // }

  // if(_business_category_focus_active){
  //   setState((){
  //     clicked = true;
  //   });

  // }
}

  static final _form_key = GlobalKey<FormState>();
  var _form_view = Container(
    //color: Colors.grey.shade300,
    margin: EdgeInsets.all(8.0),
    padding: EdgeInsets.all(8.0),
    child: SingleChildScrollView(
      child: Form(
        key: _form_key,
        child: Column(
          children: <Widget>[
            _name_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _physical_address_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _postal_address_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _telephone_number_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _mobile_number_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _fax_number_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _email_address_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _company_website_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _about_us_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _category_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
            _province_field(),
                      SizedBox(
            height: _space_between_fields,
          ),
          SizedBox(
            width: double.infinity,
            //child: submit_advert_button(),
          ),
            //submit_advert(),

            // Padding(
            //   padding: EdgeInsets.only(top: 10.0),
            //   child: submit_advert(),
            // ),
          ],
        ),
      ),
    ),
  );
submit_advert_button(){
  return  RaisedButton(
    onPressed: (){
      _submit_advert();
    },
    color: Colors.green,
    child: Text('Submit Advert',
    style: TextStyle(
      fontSize: 16.9,
      
    ),
    ),
    textColor: Colors.white,
  );
}

static TextFormField _name_field(){
  return TextFormField(
    controller: _name_controller,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,

    validator: (value){
      if(value.length == 0){
        return ('Enter Company Name');
      }
    },

    decoration: InputDecoration(
      labelText: 'Business Name',
      hintText: 'Business Name', 
      border: OutlineInputBorder(),
      icon: Icon(Icons.next_week),
      fillColor: Colors.grey
    ),
  );
}

static TextFormField _physical_address_field(){
  return TextFormField(
    controller: _physical_address_controller,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    validator: (value){
      if(value.length == 0){
        return ('Enter Company Physical address');
      }
    },

    decoration: InputDecoration(
      labelText: 'Physical Address',
      hintText: 'Physical Address',
      border: OutlineInputBorder(),
      icon: Icon(Icons.add_location),
      fillColor: Colors.grey
    ),
  );
}

static TextFormField _postal_address_field(){
  return TextFormField(
    controller: _postal_address_controller,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,

    decoration: InputDecoration(
      labelText: 'Postal Address',
      hintText: 'Postal Address',
      border: OutlineInputBorder(),
      icon: Icon(Icons.mail_outline),
      fillColor: Colors.grey
    ),
  );
}

static TextFormField _telephone_number_field(){
  return TextFormField(
    controller: _telephone_number_controller,
    keyboardType: TextInputType.phone,
    textInputAction: TextInputAction.next,

    validator: (value){
      if(value.length == 0){
        return ('Enter Company Telephone Number');
      }
    },

    decoration: InputDecoration(
      labelText: 'Telephone Number',
      border: OutlineInputBorder(),
      hintText: 'Telephone Number',
      icon: Icon(Icons.local_phone),
      fillColor: Colors.grey
    ),
  );
}

static TextFormField _mobile_number_field(){
  return TextFormField(
    controller: _mobile_number_controller,
    keyboardType: TextInputType.phone,
    textInputAction: TextInputAction.next,

    decoration: InputDecoration(
      labelText: 'Mobile Number',
      hintText: 'Mobile Number',
      border: OutlineInputBorder(),
      icon: Icon(Icons.phone_android),
      fillColor: Colors.grey
    ),
  );
}

static TextFormField _fax_number_field(){
  return TextFormField(
    controller: _fax_number_controller,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,

    decoration: InputDecoration(
      labelText: 'Fax Number',
      hintText: 'Fax Number',
      icon: Icon(Icons.print),
      border: OutlineInputBorder(),
      fillColor: Colors.grey
    ),
  );
}

static TextFormField _email_address_field(){
  return TextFormField(
    controller: _email_address_controller,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,

    validator: (value){
      Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

      if(value.length == 0 || !regex.hasMatch(value)){
        return ('Enter valid Company Email Address');
      }
    },

    decoration: InputDecoration(
      labelText: 'Email Address',
      hintText: 'Email Address',
      icon: Icon(Icons.email),
      border: OutlineInputBorder(),
      fillColor: Colors.grey
    ),
  );
}

static TextFormField _company_website_field(){
  return TextFormField(
    controller: _company_website_controller,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,

    decoration: InputDecoration(
      labelText: 'Company Website',
      hintText: 'Company Website',
      icon: Icon(Icons.web),
      border: OutlineInputBorder(),
      fillColor: Colors.grey
    ),
  );
}

static TextFormField _about_us_field(){
  return TextFormField(
    controller: _about_us_controller,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    focusNode: _about_company_focus,

    validator: (value){
      if(value.length == 0){
        return ('Enter Company Description');
      }
    },

    decoration: InputDecoration(
      labelText: 'About Company',
      hintText: 'About Company',
      border: OutlineInputBorder(),
      icon: Icon(Icons.info),
      fillColor: Colors.grey
    ),
  );
}






    static List<Map<String, dynamic>> test = [{"label":"test"}, {"label":"again"}];

// static SingleSelectFormField category_field(){
//   return SingleSelectFormField(
//     controller: _category_controller,
//     labelText: 'single select',
//     //initialValue: test[0],
//     validator: (value){
//       if(value.isEmpty)
//         return 'please select value';
//     },

//     options: test,
//   );
// }

 static TextFormField _category_field(){
   return TextFormField(
     controller: _category_controller,
     keyboardType: TextInputType.text,
     textInputAction: TextInputAction.next,
     focusNode: _bussiness_category_focus,
     validator: (value){
       if(value.length == 0) 
         return 'Please Select Business Category';
     },

     decoration: InputDecoration(
      border: OutlineInputBorder(),
       labelText: 'Category',
       hintText: 'Category',
       icon: Icon(Icons.category),
      fillColor: Colors.grey
     ),
   );
 }

static TextFormField _province_field(){
  return TextFormField(
    controller: _province_controller,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    focusNode: _province_focus,
    validator: (value){
      if(value.length == 0){
        return 'Please Select Province';
      }
    },

    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Province Name',
      hintText: 'Province Name',
      icon: Icon(Icons.location_city),
      fillColor: Colors.grey
    ),
  );
}

void _submit_advert(){
if(_form_key.currentState.validate()){
  _form_key.currentState.save();
  print('submiting form');

  _server_call_save_business_info();

}else{
  print('some validation failed');
}
}

// static Widget ultimate_business = SimpleDialogOption(
//   child: const Text('Ultimate Business In Africa'),
//   onPressed: (){
//     print('ultimate business in africa pressed');

//     _category_controller.text = "Ultimate Business In Africa";
    
//     _about_company_focus = new FocusNode();
//     _bussiness_category_focus = new FocusNode();
//     _province_focus = new FocusNode();

//     FocusScope.of(_scaffold_key.currentContext).requestFocus(_about_company_focus);
//     Navigator.of(_scaffold_key.currentContext).pop();
//   },
// );

// static Widget governement_departments = SimpleDialogOption(
//   child: const Text('government departments'),
//   onPressed: (){
//     print('government departments pressed');
//   },
// );

// static Widget Kwazulu_natal = SimpleDialogOption(
//   child: const Text('Kwazulu-natal'),
//   onPressed: (){
//     print('Kwazulu-natal clicked');

//     _province_controller.text = "Kwazulu-natal";

//     _about_company_focus = new FocusNode();
//     _bussiness_category_focus = new FocusNode();
//     _province_focus = new FocusNode();

//     FocusScope.of(_scaffold_key.currentContext).requestFocus(_about_company_focus);
//     Navigator.of(_scaffold_key.currentContext).pop();
//   },
// );

// static SimpleDialog _province_dialog = SimpleDialog(
//   title: const Text('Choose Business Province'),
//   children: <Widget>[
//     Kwazulu_natal,
//   ],
// );

// static SimpleDialog _category_dialog = SimpleDialog(
//   title: const Text('Choose Business Category'),
//   children: <Widget>[
//     ultimate_business,
//     governement_departments
//   ],
// );

 Widget set_up_categories_dialog(){
  return Container(
    height: MediaQuery.of(_scaffold_key.currentContext).size.height,
    width: MediaQuery.of(_scaffold_key.currentContext).size.width,
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: Government_categories.length,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          onTap: (){
             print(Government_categories[index].name);
             _category_controller.text = Government_categories[index].name;
             
             setState((){
               category_id = Government_categories[index].id;
             });
             _bussiness_category_focus.unfocus();
             Navigator.of(_scaffold_key.currentContext).pop();
           },
          title: Text(Government_categories[index].name),
        );
      },
    ),
  );
}

Widget set_up_province_dialog(){
  return Container(
    height: MediaQuery.of(_scaffold_key.currentContext).size.height,
    width: MediaQuery.of(_scaffold_key.currentContext).size.width,
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: Provinces.length,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          onTap: (){
            print(Provinces[index].name);
            _province_controller.text = Provinces[index].name;

            setState((){
              province_id = Provinces[index].id;
            });
            _province_focus.unfocus();
            Navigator.of(_scaffold_key.currentContext).pop();
          },
          title: Text(Provinces[index].name),
        );
      },
    ),
  );
}
}
//Text Form Fields
//name
//physical address
//postal address
//telephone
//mobile
//fax
//email
//company website
//about us
//category
//province

//#required
//name
//addrss
//telephone
//email
//about_us

