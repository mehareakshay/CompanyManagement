
// import 'dart:html';

import 'package:flutter/material.dart';
import '../urls.dart';
import 'associate_attendence.dart';
import 'drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';



class attendance extends StatefulWidget {
  const attendance({Key? key}) : super(key: key);

  @override
  _attendanceState createState() => _attendanceState();
}

class _attendanceState extends State<attendance> {
  var attendanceController;
  bool loadData=false;
  bool noData=false;

  bool selectDate = false;
  DateTime selectedStartingDate = DateTime.now();
  final TextEditingController _startingDate =  TextEditingController();

  Future<void> _selectStartingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1901),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedStartingDate) {
      setState(() {
        selectedStartingDate = picked;
        _startingDate.text = DateFormat('yyyy-MM-dd').format(picked).toString(); //TextEditingValue(text: formatter.format(picked)) Use formatter to format selected date and assign to text field
      });
    }
  }

  // String url= "http://127.0.0.1:8000/register";
  // var data=['Monday','2022-04-19','Present','14:01:06','','22:00:00'];


  var appBarTitle = "Attendance";

  get username => username;

  get email => email;
  late SharedPreferences prefLoginData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("anyyhhggg");
    getAttendenceDatabyemp();



  }
  var jsonresponseAttendenceData;
  Future getAttendenceDatabyemp() async {
    prefLoginData=await SharedPreferences.getInstance();
    String? employee_id = prefLoginData.getString('id');

    var response = await http.post(Uri.parse(Urls.toGetAttendenceList),
        headers: {
          "Accept": "application/json",
        }, body: {
          "username_id": employee_id.toString(),
        });

    var jsonresponse=jsonDecode(response.body.toString());
    print("--++++++++++++++++");
    print(jsonresponse.toString());
    jsonresponseAttendenceData=jsonresponse["Attendence"];
    print(jsonresponseAttendenceData);


    if (jsonresponseAttendenceData==0){
      setState(() {
        noData=true;
      });

    }else{
      setState(() {
        loadData=true;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Attendance"),

          bottom: TabBar(
            tabs: [
              Tab(text: "My Attendance",),
              Tab(text: "Associates Attendance"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: loadData?
                ListView.builder(
                  itemCount: jsonresponseAttendenceData.length,
                  itemBuilder:(context,index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                child: Text(jsonresponseAttendenceData[index]['day'].toString()+',  '+jsonresponseAttendenceData[index]['date'].toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey[500]),
                                ),

                                // ListTile(
                                //   title: Text(data[0].toString()),
                                //   subtitle: Text("Stetus: ${data[1].toString()}"),
                                //   //leading :,
                                // ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Stetus :" +jsonresponseAttendenceData[index]['status'].toString(),style: const TextStyle(fontSize: 12),)
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("In Time : " + jsonresponseAttendenceData[index]['time_in'].toString() , style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                  jsonresponseAttendenceData[index]['time_out'].toString()=='null'? const Text("Out Time: On Duty", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)):Text("Out Time:  "  + jsonresponseAttendenceData[index]['time_out'].toString(), style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );

                  },
                )
                    :Center(child: CircularProgressIndicator(),
                ),
              ),
            ),
            associate_attendance()
          ],

        ),

      ),
    );
  }
}
