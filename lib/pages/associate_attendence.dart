import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../urls.dart';
import 'package:http/http.dart' as http;
class associate_attendance extends StatefulWidget {
  const associate_attendance({Key? key}) : super(key: key);

  @override
  _associate_attendanceState createState() => _associate_attendanceState();
}

class _associate_attendanceState extends State<associate_attendance> {
  final TextEditingController _startingDate = TextEditingController();
  bool loadData=false;
  bool noData=false;

  final dateController = TextEditingController();
  final dateController1 = TextEditingController();
  late SharedPreferences prefLoginData;

  DateTime selectedStartingDate = DateTime.now();
  Future<void> _selectStartingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1901),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedStartingDate) {
      setState(() {
        selectedStartingDate = picked;
        _startingDate.text = DateFormat('yyyy-MM-dd')
            .format(picked)
            .toString(); //TextEditingValue(text: formatter.format(picked)) Use formatter to format selected date and assign to text field
      });
    }
  }

  DateTime selectedEndingDate = DateTime.now();
  final TextEditingController _endingDate = TextEditingController();

  // Future<void> _selectEndingDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(1901),
  //       lastDate: DateTime(2100));
  //   if (picked != null && picked != selectedEndingDate) {
  //     setState(() {
  //       selectedEndingDate = picked;
  //       _endingDate.text = DateFormat('yyyy-MM-dd')
  //           .format(picked)
  //           .toString(); //TextEditingValue(text: formatter.format(picked)) Use formatter to format selected date and assign to text field
  //     });
  //   }
  // }


  var jsonResponseByDate;
  Future getAttendenceDatabyemp() async {
    prefLoginData=await SharedPreferences.getInstance();
    String? employee_id = prefLoginData.getString('id');

    var response = await http.post(Uri.parse(Urls.toGetAttendanceListByDate),
        headers: {
          "Accept": "application/json",
        }, body: {
          "username_id": employee_id.toString(),
          'start_date' : _startingDate.text,
          'end_date' : _endingDate.text,

        });

    var jsonresponse=jsonDecode(response.body.toString());
    print("--++++++++++++++++");
    print(jsonresponse.toString());
    print("55555555555");
    jsonResponseByDate=jsonresponse["attendanceList"];
    print("--------------");
    print(jsonResponseByDate);
    print(jsonResponseByDate.length);

    if (jsonResponseByDate==0){
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
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.24,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1, bottom: 1, right: 2),
                    child: TextField(
                      controller: _startingDate,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: "Start Date",
                        labelText: "Start Date",
                      ),
                      focusNode: AlwaysDisabledFocusNode1(),
                      onTap: () async {
                        _selectStartingDate;
                        print(_selectStartingDate(context));
                        // print(selectedEndingDate);
                      },
                    ),
                  ),
                ),
                const Text("-"),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.24,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1, bottom: 1, left: 2),
                    child: TextField(
                        controller: _endingDate,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "End Date",
                            labelText: "End Date"),
                        focusNode: AlwaysDisabledFocusNode2(),
                        onTap: () async {
                          print("-----");
                          // _selectEndingDate;

                          var picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1901),
                              lastDate: DateTime(2100));
                          if (picked != null && picked != selectedEndingDate) {
                            setState(() {
                              selectedEndingDate = picked;
                              _endingDate.text = DateFormat('yyyy-MM-dd')
                                  .format(picked)
                                  .toString(); //TextEditingValue(text: formatter.format(picked)) Use formatter to format selected date and assign to text field
                            });
                          }
                          print(_endingDate.text);

                        }
                        // print(_selectEndingDate(context));


                        ),
                  ),
                ),
                ElevatedButton(onPressed: () {
                  getAttendenceDatabyemp();
                }, child: Text("Check")),
                ElevatedButton(onPressed: () {}, child: Text("Clear"))
              ],
            ),
          ),
          loadData?Expanded(
              child:ListView.builder(
                itemCount:jsonResponseByDate.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(jsonResponseByDate[index]['day'].toString() + ', '+jsonResponseByDate[index]['date'].toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[500]),)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Text("Status :" + jsonResponseByDate[index]['status'].toString(), style: const TextStyle(fontSize: 12, )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("In Time : " + jsonResponseByDate[index]['time_in'].toString() , style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                jsonResponseByDate[index]['time_out'].toString()=='null'? const Text("Out Time: On Duty", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)):Text("Out Time:"  + jsonResponseByDate[index]['time_out'].toString(), style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },)

          ):SizedBox()
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.35),
          //   child:const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // ),
        ],
      ),

    );
  }
}

class AlwaysDisabledFocusNode1 extends FocusNode {
  @override
  bool get hasFocus => false;
}

class AlwaysDisabledFocusNode2 extends FocusNode {
  @override
  bool get hasFocus => false;
}
