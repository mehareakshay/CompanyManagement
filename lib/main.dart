import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/drawer.dart';
import 'pages/login.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:convert'; //for base64Encode
import 'package:http/http.dart' as http;
import '../urls.dart';
import 'package:fluttertoast/fluttertoast.dart';


// class Task{
//   final String dateController;
//   final String title;
//
//   Task(this.dateController,this.title);
// }


void main() {
  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    title: "Company Management",
    home: const SplashScreenPage(),

    theme: ThemeData(
        primarySwatch: Colors.blue
    ),
  ));
}

var finalusername;
var finalpassword;
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);




  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}




class _SplashScreenPageState extends State<SplashScreenPage> {
  late SharedPreferences prefLoginData;
  String userId="";
  String userDesignation="";
  @override
  void initState(){
super.initState();
getValidationData().whenComplete(() async{
  if (userId==""){
    Timer(const Duration(seconds: 2),() => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const login()), (_) => false));
  }else{
    getData();
    Timer(const Duration(seconds: 3),() => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  Myhome()), (_) => false));
  }
  // Timer(Duration(seconds: 3),() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>finalusername==null ? login() : Myhome())));
}

);
// Timer(Duration(seconds: 3),() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>login())));
  }


  Future getData() async{
    prefLoginData = await SharedPreferences.getInstance();
    String? employee_checkIn = prefLoginData.getString('checkIn');
    bool? employee_signedIn = prefLoginData.getBool('signedIn');
    String? attendance_id = prefLoginData.getString('attendance_id');


    setState(() {
      emp_checkIn = employee_checkIn!;
      emp_signedIn = employee_signedIn!;
      attendance_id = attendance_id!;
    });
  }



  Future getValidationData() async {
  prefLoginData = await SharedPreferences.getInstance();
  String? id= prefLoginData.getString("id");
  String? designation= prefLoginData.getString("designation");
    // var obtaineduser=sharedPreferences.getString('username');
    // var obtainpassword=sharedPreferences.getString('password');

    setState(() {
      userId=id!;
      userDesignation=designation!;
    });
    print(userId);
    print(userDesignation);
}
// @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Image.asset("assets/wings.png", width: 150,
        height: 150,
        fit:BoxFit.fill ),
    const SizedBox(height: 20,),
const CircularProgressIndicator()
  ],
),
      ),
    );
  }
}

class Myhome extends StatefulWidget {
  const Myhome({Key? key}) : super(key: key);

  @override
  _MyhomeState createState() => _MyhomeState();
}

bool signedIn = emp_signedIn;
String timeCheckIn = emp_checkIn;

class _MyhomeState extends State<Myhome> {
  var inTime = '';
  late SharedPreferences prefLoginData;
  // late SharedPreferences staffData;



  String base64Image='';
  late File _image= File("path");
  final picker=ImagePicker();
  // late File _image=File("path");

  Future getImage() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // print(_image.path);
        base64Image = base64Encode(_image.readAsBytesSync());
      } else {
        print('No image selected.');
      }
    });
  }

  String latitude = '00.00000';
  String longitude = '00.00000';
  late double distanceInMeters_1;
  late double distanceInMeters;

  getCurrentLocation() async{
    CircularProgressIndicator();
    bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
    await Geolocator.requestPermission();
    Position position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    distanceInMeters_1=Geolocator.distanceBetween(77.7610044, 21.9240002, position.longitude, position.latitude);
    print("Sign In ---------------------------");
    print(distanceInMeters_1);
    print(position.longitude);
    print(position.latitude);

    if (distanceInMeters_1 < 25598){
      print("itsidn------------------");
      await getImage();

      inTime = DateTime.now().hour.toString() + " : " +DateTime.now().minute.toString() ;
      print("@@@@@@@@@@@@@@@@@");
      prefLoginData = await SharedPreferences.getInstance();
      String? emp_employee_id= prefLoginData.getString('id');
      print(emp_employee_id);
      print("&&&&&&&&&&&&&&&&&&");

      setState(() {
        signedIn=true;
      });
      var response = await http.post(Uri.parse(Urls.topostAttendence),
          headers: {
            "Accept": "application/json",
          }, body: {
            "username_id": emp_employee_id.toString(),
            "time_in_latitude": position.latitude.toString(),
            "time_in_longitude": position.longitude.toString(),
            "time_in_image": base64Image,
          });
      var convertDatatoJson=jsonDecode(response.body.toString());
      print("________________________________");
      print(convertDatatoJson);
      print(convertDatatoJson['id'].toString());

      prefLoginData = await SharedPreferences.getInstance();
      prefLoginData.setString("checkIn", timeCheckIn);
      prefLoginData.setBool("signIn", signedIn);
      prefLoginData.setString("attandanceid", convertDatatoJson['id'].toString());
      attendance_id=convertDatatoJson['id'].toString();

      print(prefLoginData.getBool("signIn"));
      print(prefLoginData.getString("checkIn"));
      print(prefLoginData.getString("attandanceid"));

      print(prefLoginData.containsKey("attandanceid"));
      print(prefLoginData.containsKey("signIn"));
      print(prefLoginData.containsKey("checkIn"));
      print(prefLoginData.containsKey("id"));



    }


  }


  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text("Are You Sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Confirm"),
              onPressed: () async {
                bool isLocationServiceEnabled =
                await Geolocator.isLocationServiceEnabled();
                // print(isLocationServiceEnabled);
                LocationPermission permission =
                await Geolocator.requestPermission();
                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);

                distanceInMeters = Geolocator.distanceBetween(77.7610044, 20.9240002, position.longitude, position.latitude);

                if (distanceInMeters <25598) {
                  print(
                      "-----------------------****-------------------------------");
                  await getImage();
                  // attendance_id = prefLoginData.getString("attandanceid")!;
                  // print(attendance_id);
                  // print(emp_employee_id.toString());
                  Navigator.of(context).pop();

                  prefLoginData = await SharedPreferences.getInstance();
                  print("88888888888888888888");
                  // staffData = await SharedPreferences.getInstance();
                  setState(() {



                    signedIn = false;

                    prefLoginData.remove("checkIn");
                    // staffData.remove("longPressed");
                    prefLoginData.setBool("signedIn", signedIn);
                  });
                  await http.post(Uri.parse(Urls.toOutAttendence), headers: {
                    "Accept": "application/json",
                  }, body: {
                    "record_id": attendance_id.toString(),
                    "id": emp_employee_id.toString(),
                    "time_out_lat": position.latitude.toString(),
                    "time_out_long": position.longitude.toString(),
                    "time_out_image": base64Image,
                  });
                  print("!!!!!!!!!!!!!!!!!!!");

                } else {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: "In-Appropriate Check In/Out Point!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      fontSize: 14.0);
                }

                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Login()), (_) => false);
              },
            ),
            TextButton(
              child: const Text("Decline"),
              onPressed: () {
                //Put your code here which you want to execute on No button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [

          signedIn
              ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                showAlert(context);
              },
              child: Row(
                children: [
                  inTime == '' ?
                  Text(
                    timeCheckIn.toString(),
                    style: const TextStyle(fontSize: 12),
                  ): Text(inTime.toString()),
                  const Padding(
                    padding: EdgeInsets.only(left: 2.0),
                    child: Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                ],
              ),
              style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty
                      .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.white)))),
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    getCurrentLocation();
                    print(
                        "-------------------------------------------------");
                    print(longitude);
                    print(latitude);
                  });
                },
                child: Row(
                  children: const [Text("Sign In"), Icon(Icons.login)],
                ),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    shape:
                    MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                                color: Colors.white))))),
          )
        ],
          // Row(
          //   children: [
          //     // inTime == '' ? Text("data") : Text(inTime.toString()),
          //      IconButton(icon: Icon(Icons.login),
          //       onPressed: () {
          //        //ithe kaaraych
          //         signedIn?showAlert(context):
          //         getCurrentLocation();
          //         // async {
          //         //   // CircularProgressIndicator();
          //         //   bool isLocationServiceEnabled = await Geolocator
          //         //       .isLocationServiceEnabled();
          //         //   await Geolocator.requestPermission();
          //         //   Position position = await Geolocator.getCurrentPosition(
          //         //       desiredAccuracy: LocationAccuracy.high);
          //         //
          //         //   distanceInMeters_1 = Geolocator.distanceBetween(
          //         //       20.924075687585344, 77.76089887980201, position.longitude,
          //         //       position.latitude);
          //         //   print("Sign In ---------------------------");
          //         //   print(distanceInMeters_1);
          //         //   print(position.longitude);
          //         //   print(position.latitude);
          //         // }
          //
          //       })
          //
          //   ],
          // ),

        title: Text(
          "Ordinet Solution"
        ),
      ),
      drawer: drawer(),
    );
  }
}



