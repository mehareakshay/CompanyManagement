import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../urls.dart';

String emp_checkIn= "", emp_employee_id = "", attendance_id="";
bool emp_signedIn= false;

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  late SharedPreferences prefLoginData;
  //for validate _formKey
  final _formKey = GlobalKey<FormState>();


  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();


  // Future getData() async{
  //   prefLoginData = await SharedPreferences.getInstance();
  //   String? employee_checkIn = prefLoginData.getString('checkIn');
  //   bool? employee_signedIn = prefLoginData.getBool('signedIn');
  //   String? attendance_id = prefLoginData.getString('attendance_id');
  //
  //
  //   setState(() {
  //     emp_checkIn = employee_checkIn!;
  //     emp_signedIn = employee_signedIn!;
  //     attendance_id = attendance_id!;
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
appBar: AppBar(
title: const Text("Login"),
),
body: SingleChildScrollView(
child: Column(
  children: <Widget>[
Padding(padding: const EdgeInsets.only(top: 40.0),
child: Image.asset("assets/wings.png",width: 150,height: 150,),
),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Form(
      key: _formKey,
      // autovalidateMode: false,
      child: Column(
        children: [
          TextFormField(
            // inputFormatters: [new LengthLimitingTextInputFormatter(4)],
            validator: (value){
              if (value==null || value.isEmpty){
                return 'Enter the Username';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction ,
            controller: usernameController,
decoration: const InputDecoration(

border:OutlineInputBorder(),
  labelText:"username",
  hintText:"Enter a username"

),

          ),

          Padding(padding: const EdgeInsets.only(
              left: 2.0, right: 15.0, top: 15, bottom: 0),
            child: TextFormField(

              validator: (value) {
                if (value==null || value.isEmpty){
                  return 'Enter the password';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction ,
              controller: passwordcontroller,
              obscureText: true,
              decoration:const InputDecoration(
                  border:OutlineInputBorder(),
                  labelText:"Password",
                  hintText:"Enter Secure Password"
              ),
            ),
          ),




        ],
      ),
    ),
    ),
    const SizedBox(
      height: 50,
    ),
Container(
  height: 50,
  width: 250,
  decoration: BoxDecoration(
color:Colors.blue,borderRadius:BorderRadius.circular(5),
  ),
child: TextButton(
  onPressed: () async {
    
    
  if (_formKey.currentState!.validate()){
    // final SharedPreferences sharedPrefernces=await SharedPreferences.getInstance();

    final String username = usernameController.text;

    final String password = passwordcontroller.text;
    // sharedPrefernces.setString('username', usernameController.text);
    // sharedPrefernces.setString('password', passwordcontroller.text);
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Myhome()));
    // yahase chalu krna hai
    prefLoginData=await SharedPreferences.getInstance();
    List data;
    var response = await http.post(Uri.parse(Urls.checkApplogin), body: {
      "username": username,
      "password": password,
    }, headers: {
      "Accept": "application/json"
    });

    print(response.body);


    setState(() {
      var convertDatatojson=jsonDecode(response.body.toString());

      print(convertDatatojson.toString());

      print(response.body.toString());


    if (convertDatatojson['success'] == 0) {
      print("Invalid Username/Password");
      Fluttertoast.showToast(
          msg: "Invalid Username/Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      // Navigator.pop(context, true);
    }else{
      print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

      prefLoginData.setString("id",convertDatatojson['UserData'][0]['id'].toString());
      prefLoginData.setString("first_name", convertDatatojson['UserData'][0]['first_name']);
      prefLoginData.setString("dob", convertDatatojson['UserData'][0]['dob']);
      prefLoginData.setString("mobile_no", convertDatatojson['UserData'][0]['mobile_no']);
      prefLoginData.setString("username", convertDatatojson['UserData'][0]['username']);
      prefLoginData.setString("email", convertDatatojson['UserData'][0]['email']);
      prefLoginData.setString("designation", convertDatatojson['UserData'][0]['designation']);
      prefLoginData.setString("address", convertDatatojson['UserData'][0]['address']);






      // prefLoginData.setString(password, converDatatojson['password']);
      print("___________________________");
      print(prefLoginData.getString("id"));
      print("###################################");
      print(prefLoginData.getString("first_name"));
      print(prefLoginData.getString("address"));

      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => SplashScreenPage()), (_) => false);
    }
    
    });

  }


  },
  child: const Text("Login",
  style: TextStyle(color: Colors.white, fontSize: 18),
  ),

),
),
Align(
  alignment: Alignment.bottomRight,
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: GestureDetector(
onTap: () {
  Fluttertoast.showToast(
msg:"Contact Admin to get Password",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
},
    child: const Text("Forgot Password?",style: TextStyle(color: Colors.blue, fontSize: 15),),
  ),
),
),
    const SizedBox(height: 20,),
  ],
),
),
    );
  }
}
