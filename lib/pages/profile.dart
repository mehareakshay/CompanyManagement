
import 'dart:convert';
import 'dart:async';

// import 'package:companyp/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../widget/appbar_widget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../urls.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late SharedPreferences prefLoginData;
  late List data = [];
  // String memberId = '';
  // var dataCheck;
  late File _image = File("path");
  final picker = ImagePicker();
  String base64Image = '';

  @override
  void initState() {
    super.initState();
    imageCache?.clear();
    getData();
  }

  String emp_name = "", emp_employee_id = "", emp_employee_designation = "", emp_employee_username = "", emp_employee_role = "", emp_employee_mobile_no = "";


  Future getImage() async {

    print("getImage also executing.....");
    print(emp_employee_id);
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      base64Image = base64Encode(_image.readAsBytesSync());

      print(base64Image);

      var response = await http.post(Uri.parse(Urls.updateProfile),
          body: {
            "id": emp_employee_username,
            "image": base64Image
          },
          headers: {"Accept": "application/json"}
      );

      print("HI");
      print(response.body.toString());
    } else {
      print('No image selected.');
    }

    setState(() {});

  }


  // var  first_name="";
  // var mobile_no="";
  // Future getData() async {
  //
  //   var response = await http.post(Uri.parse(Urls.togetData),
  //               body: {
  //                 "id": "9",
  //                 // "image": base64Image
  //               },
  //               headers: {"Accept": "application/json"}
  //           );
  //   print(response.body);
  //   var convertDatatojson=jsonDecode(response.body.toString());
  //   print("========================================================================================================");
  //   first_name = convertDatatojson['UserData'][0]['first_name'];
  //   mobile_no=convertDatatojson['UserData'][0]['mobile_no'];
  //   print(first_name);
  //   print(mobile_no);
  //
  //
  //
  //   prefLoginData = await SharedPreferences.getInstance();
  //   print(prefLoginData.getString('first_name'));
  //
  //   setState(() {
  //
  //   });
  // }




  Future<void> getData() async{


    // var response = await http.post(Uri.parse(Urls.togetData),
    //     body: {
    //                     "id": prefLoginData,
    //                     // "image": base64Image
    //                   },
    //                   headers: {"Accept": "application/json"}
    //               );
    print("---------------------------urls works");
    // print(response.body.toString());
    prefLoginData = await SharedPreferences.getInstance();

    String? name= prefLoginData.getString('first_name');
    print("GetData executing______________________________");
    String? employee_id = prefLoginData.getString('id');
    String? employee_designation = prefLoginData.getString('designation');
    String? employee_username = prefLoginData.getString('username');

    String? employee_mobile_no = prefLoginData.getString('mobile_no');

    setState(() {
      print("setstate is executing____________________");
      emp_name = name!;
      emp_employee_id = employee_id!;
      emp_employee_designation = employee_designation!;
      emp_employee_username = employee_username!;
      emp_employee_mobile_no = employee_mobile_no!;
      print("__####################");
      print(employee_id);
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body:  SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 0, right: 0, top: 5, bottom: 5),
                            child: InkWell(
                              onTap: (){

                                getImage();
                              },
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5.0, bottom: 10),
                                    child: Text("Edit Profile Image", style: TextStyle(color: Colors.lightBlue, fontSize: 18, fontWeight: FontWeight.bold),),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(2)),
                                    child: _image.path == "path" ?
                                    Image.network('http://65.1.184.62:8000/media/profile/$emp_employee_username.jpeg',
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            "assets/profile.png");
                                      },
                                    )
                                        : Center(child: Image.file(_image)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        emp_name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                color: Colors.grey[100],
                alignment: Alignment.center,
                child: const Padding(
                  padding: EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  child: Text(
                    "Details",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blueAccent),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 18.0, top: 20.0, bottom: 0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      emp_employee_mobile_no.toString(),
                      style: const TextStyle(
                          color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 18.0, top: 20.0, bottom: 0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.sticky_note_2_rounded,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      emp_employee_designation.toString(),
                      style: const TextStyle(
                          color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 18.0, top: 20.0, bottom: 0),
                child: Row(
                  children: [
                    const SizedBox(
                        width: 25,
                        height: 25,
                        child: Image(image: AssetImage('assets/username_icon.png'))),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      emp_employee_id,
                      style: const TextStyle(
                          color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 18.0, top: 20.0, bottom: 0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle_rounded,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      emp_employee_username,
                      style: const TextStyle(
                          color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 18.0, top: 20.0, bottom: 0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      child: const Text(
                        'Change Password',
                        style: TextStyle(
                            color: Colors.lightBlue, fontSize: 18),
                      ),
                      onTap: () async {
                        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ResetPassword()
                        // ),
                        //
                        // );
                        /*var res;
                      List data1;
                      List listName = [];

                      if (data[0]["role_no"] == "1") {
                        // res = await http.post(
                        //     Uri.parse(Urls.getAppSitesFOS),
                        //     body: {"id": memberId},
                        //     headers: {"Accept": "application/json"});
                        //
                        // var convertDataTojson =
                        // jsonDecode(res.body.toString());
                        // data1 = convertDataTojson['data'];
                        //
                        // for (int i = 0; i < data1.length; i++) {
                        //   listName.add(data1[i]["site"]["name"]);
                        // }
                      } else if (data[0]["role_no"] == "2") {
                        // res = await http.post(
                        //     Uri.parse(Urls.getAppFOSOpM),
                        //     body: {"id": memberId},
                        //     headers: {"Accept": "application/json"});
                        //
                        // var convertDataTojson =
                        // jsonDecode(res.body.toString());
                        // data1 = convertDataTojson['data'];
                        //
                        // for (int i = 0; i < data1.length; i++) {
                        //   listName.add(data1[i]["field_officer"]["name"]);
                        // }
                      } else if (data[0]["role_no"] == "3") {
                        // res = await http.post(Uri.parse(Urls.getAppOMGM),
                        //     body: {"id": memberId},
                        //     headers: {"Accept": "application/json"});
                        //
                        // var convertDataTojson =
                        // jsonDecode(res.body.toString());
                        // data1 = convertDataTojson['data'];
                        //
                        // for (int i = 0; i < data1.length; i++) {
                        //   listName
                        //       .add(data1[i]["operation_manager"]["name"]);
                        // }
                      }

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Container(
                              width:
                              MediaQuery.of(context).size.width * 1,
                              color: Colors.grey[100],
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 10,
                                    bottom: 10),
                                child: Text(
                                  data.isEmpty
                                      ? ""
                                      : data[0]["role_no"] == "1"
                                      ? "Sites"
                                      : data[0]["role_no"] == "2"
                                      ? "Field Officers"
                                      : data[0]["role_no"] == "3"
                                      ? "Operation Managers"
                                      : "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.blueAccent),
                                ),
                              ),
                            ),
                            content: SizedBox(
                              height:
                              300.0, // Change as per your requirement
                              width:
                              300.0, // Change as per your requirement
                              child: listName != null
                                  ? ListView.builder(
                                itemCount: listName.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(
                                        7, 5, 0, 5),
                                    child: InkWell(
                                      child: Text(
                                        listName[index],
                                        style: const TextStyle(
                                            fontSize: 18),
                                      ),
                                    ),
                                  );
                                },
                              )
                                  : Center(
                                child: listName.isNotEmpty
                                    ? const CircularProgressIndicator()
                                    : const Text("No Details"),
                              ),
                            ),
                          );
                        },
                      );*/
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      // : const Center(child: CircularProgressIndicator()),
    );
  }
}






/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  List data = [];
  late SharedPreferences prefLoginData;
  String userId = '';

  @override
  void initState() {
*/
/*
    // TODO: implement initState
    super.initState();
    // this.getJsonData();
    getSharedData().whenComplete(() {
      if (userId != ""){
        //ignore: avoid_print
        print(userId);
        getJsonData();

      } else{
        return "u don't have userId";
      }
    });
*//*

  }

*/
/*  Future<String> getJsonData() async{

    var response = await http.post(
        Uri.parse(Urls.adDetails),
        headers: {"Accept": "application/json",},
        body: {
          "admin_userName" : userId,
        }
    );
    //ignore: avoid_print
    print(response.body.toString());
    setState(() {
      var convertDataToJson = jsonDecode(response.body.toString());
      if (convertDataToJson != "") {
        data = convertDataToJson['AdminDetails'];
      }
    });
    print("----------------------------------------");
    print(Urls.ip1+ "/media" + data[0]['image'].toString());
    return "Success";
  }

  Future getSharedData() async{
    prefLoginData = await SharedPreferences.getInstance();
    String? user = prefLoginData.getString('userName');

    setState(() {
      userId = user!;
    });
  }*//*



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0.1,
      ),
      body: */
/*data.isNotEmpty? *//*
SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              // CircleAvatar(
              //   radius: 100,
              //   backgroundImage: NetworkImage(Urls.ip1 + "/media" +data[0]['image'].toString()),
              //   backgroundColor: Colors.grey[300],
              // ),
              SizedBox(
                  height: 180,
                  width: 180,
                  child:FadeInImage(
                      height: 50,
                      width: 50,
                      fadeInDuration: const Duration(milliseconds: 500),
                      fadeInCurve: Curves.easeInExpo,
                      fadeOutCurve: Curves.easeOutExpo,

                      placeholder: const AssetImage("asset/human_bg.png"),
                      image: const NetworkImage("https://picsum.photos/250?image=9"),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset("asset/human_bg.png");
                      },
                      fit: BoxFit.cover)
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10,left: 10, right: 10),
                child: Text(
                  */
/*data[0]['admin_name'],*//*

                  "Tejas Kadu",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  */
/*data[0]['admin_userName'],*//*

                  "Tejas",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.blue,

                  ),
                ),
              ),
              Container(
                color: Colors.grey[200],
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Details", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           */
/* SizedBox(
                              width: MediaQuery.of(context).size.width*0.4-10,
                              child: const Text("Admin Name:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6-10,

                              child: Text(data[0]['admin_name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),*//*

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(

                              width: MediaQuery.of(context).size.width*0.4-10,
                              child: const Text("Post :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6-10,

                              child: Text("Supervisor/Manager", style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(

                              width: MediaQuery.of(context).size.width*0.4-10,
                              child: const Text("Shift :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6-10,
                              child: Text("11.00 AM to 3.00 PM", style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(

                              width: MediaQuery.of(context).size.width*0.4-10,
                              child: const Text("Mobile :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6-10,

                              child: Text("9999999999999999999", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            SizedBox(

                              width: MediaQuery.of(context).size.width*0.4-10,
                              child: const Text("WhatsApp No :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6-10,

                              child: Text("hhhhhhhhhh", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(

                              width: MediaQuery.of(context).size.width*0.4-10,
                              child: const Text("Email :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6-10,

                              child: Text("HIUXG@fgbkk", style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(

                              width: MediaQuery.of(context).size.width*0.4-10,
                              child: const Text("Address :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6-10,
                              // child: const Text("nsue anfuwafnaw  8udn8ua", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              child: Text("Afaxcgfehfncv", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(

                              width: MediaQuery.of(context).size.width*0.4-10,
                              child: const Text("Age :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6-10,
                              // child: const Text("112", style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              child: Text("jcsivcnaivna", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(

                              width: MediaQuery.of(context).size.width*0.4-10,
                              child: const Text("Aadhaar Card :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6-10,
                              // child: const Text("123567", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              child: Text("7748782734728947847", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(

                              width: MediaQuery.of(context).size.width*0.4-10,
                              child: const Text("Pan Card :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.6-10,
                              // child: const Text("5687665", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                              child: Text("UHUU^%%&^Nn", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.5-15,
                        child: ElevatedButton(
                          onPressed: (){
                            // Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditProfile(data: data[0],)));
                          },
                          // style: ButtonStyle(
                          //   backgroundColor: MaterialStateProperty.all(const Color(0xff90CC50)),
                          // ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.edit),
                              Text(" Edit Profile", style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.5-15,
                        child: ElevatedButton(
                          onPressed: (){
                            // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ResetPassword()));
                          },
                          // style: ButtonStyle(
                          //   backgroundColor: MaterialStateProperty.all(const Color(0xff2CC2C6)),
                          // ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.change_circle_outlined),
                              Text(" Reset Password", style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ) */
/*:
      const Center(
          child:CircularProgressIndicator(color:  Color(0xff2cc2c6),) )*//*
,
    );
  }
}

*/
