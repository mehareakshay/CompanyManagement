// import 'package:companyp/pages/application/application.dart';
import 'package:companyp/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyAttendence.dart';
import 'application/leave_application.dart';
import 'holidays.dart';
import 'profile.dart';
import 'login.dart';
import '../main.dart';

class drawer extends StatefulWidget {
  const drawer({Key? key}) : super(key: key);

  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  // final name = TextEditingController();
  // final email = TextEditingController();
  var name="Akshay Mehare";
  var email="gdghfdvh@gmail.com";
  var imagePath= "http://wallpapersdsc.net/wp-content/uploads/2017/05/Hawk-free-images.jpg";
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
Container(
  color: Colors.blue,
  height: MediaQuery.of(context).size.height*0.33,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.start,
  children: [
    UserAccountsDrawerHeader(accountName: Text(name,
      style: TextStyle(
        fontWeight: FontWeight.bold,

      )
      ,),accountEmail: Text(email),
    currentAccountPicture: CircleAvatar(
      backgroundImage: NetworkImage(imagePath),
    ),)

  ],
),
),
ListTile(
  leading: const Icon(Icons.home),
title: const Text(
'Home',
style: TextStyle(
fontSize:20,
),
),
  onTap: () {
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> Myhome()));
  },
),
          ListTile(
            leading: const Icon(Icons.wysiwyg),
title: const Text("Attendence",style: TextStyle(
  fontSize: 20
),
),
            onTap: () {
Navigator.of(context).push(MaterialPageRoute(builder: (_)=>  attendance()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile",style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder:(context)=>ProfilePage()));
            }

          ),

          ListTile(
              leading: const Icon(Icons.celebration),
              title: const Text("Holidays",style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=>holidays()));
              }

          ),
          ListTile(
              leading: const Icon(Icons.pages),
              title: const Text("Applications",style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder:(context)=>application()));
              }

          ),
Divider(),
        ListTile(
        leading: const Icon(Icons.logout),
    title: const Text("Logout",style: TextStyle(fontSize: 20),
    ),
    onTap: () async {

      final SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
      sharedPreferences.remove("username");
      sharedPreferences.remove("password");
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>login()));
    }
        )],
      ),
    );
  }
}
