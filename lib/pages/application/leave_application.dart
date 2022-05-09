
import 'dart:convert';

import 'package:companyp/pages/application/rajected_application.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'application.dart';
import '../../urls.dart';
import '../drawer.dart';
import 'approved_application.dart';
// import '../drawer.dart';

class application extends StatefulWidget {
  const application({Key? key}) : super(key: key);

  @override
  State<application> createState() => _applicationState();
}

class _applicationState extends State<application> {
  final dateController = new TextEditingController();
  final title=TextEditingController();
  bool noData = false;
  bool loadData = false;
  String StrValue="";
  // late SharedPreferences prefLoginData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLeaveApplication();
    // loadData = false;
    // if(date.length > 0)
    //   {
    //     loadData = true;
    //   }
  }
  String emp_employee_username = "";


  @override
  var jsonresponseData;
  Future getLeaveApplication() async {
    // prefLoginData = await SharedPreferences.getInstance();
    // String? name= prefLoginData.getString('first_name');
    // setState(() {
    //   emp_employee_username = name!;
    //   print("__________________________________________");
    //   print(emp_employee_username);
    // });
    var response=await http.get(Uri.parse(Urls.checkLeaveApllication),
        // body: {},
        headers:{"Accept": "application/json"}
    );
    var jsonresponse=jsonDecode(response.body.toString());
    print("response.body.toString()----------------------");
    print(response.body.toString());
    print('jsonresponse---------------------');
    print(jsonresponse);

    jsonresponseData=jsonresponse["application"];
    print("jsonresponseData#######################");
    print(jsonresponseData);
    print("------------yeeee----------------");
    print(jsonresponseData[0]['id']);
    // print(jsonresponseData[0]['username']['first_name']);
    // print(jsonresponseData[0]['username']['first_name']);


    if (jsonresponseData.length==0){
      setState(() {
        noData=true;
      });
    }else{
      setState(() {
        loadData=true;
      });
    }

}

  Future<void> _showMyDialogCompleted(int index) async{
    // getLeaveApplication();
    return showDialog(
        context: context,
        builder:(BuildContext context) {
          return loadData?AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(3.0))
            ),
            // backgroundColor: Colors.white70,
            elevation: 5,

            // insetPadding: EdgeInsets.all(10),
            title: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Name :  " +jsonresponseData[index]['username']['first_name'],
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Title    :  " +jsonresponseData[index]['title'],
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Reason:  " +jsonresponseData[index]['description'],
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("From Date:  " +jsonresponseData[index]['start_date'],
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("To Date:  " +jsonresponseData[index]['end_date'],
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Expanded(child: TextButton(onPressed: () async{

                          setState(() {
                            StrValue="Rajected";
                            print(StrValue);
                          });
                          // print("@@@@@@@@@@@@@@@@@@@");
                          print(jsonresponseData[index]["id"].toString());
                          var response= await http.post(Uri.parse(Urls.updateStatusOfApplication),
                              body: {
                                "username_id": jsonresponseData[index]["id"].toString(),
                                "status":StrValue

                              },
                              headers: {
                                "Accept": "application/json"
                              }
                          );

                          print("^^^^^^^^^^^^^^^^^");
                          print(response.body.toString());

                          if (response.body.toString()=="success"){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>application()));
                          }else{
                            print("cannot attendence");
                          }




                        }, child: Text(
                            "Raject"
                        ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            primary: Colors.black,
                            shadowColor: Colors.red[400],
                            elevation: 3,
                          ),
                        )
                        ),
                        Spacer(),

                        Expanded(
                          child: TextButton(
                            child: Text(
                              "Approve",
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.lightGreen,
                              primary: Colors.black,
                              shadowColor: Colors.lightGreen,
                              elevation: 3,
                            ),
                            onPressed: () async{
                              setState(() {
                                StrValue="Approved";
                                print(StrValue);
                              });
                              print("@@@@@@@@@@@@@@@@@@@");
                              print(jsonresponseData[index]["id"].toString());
                              var response= await http.post(Uri.parse(Urls.updateStatusOfApplication),
                                  body: {
                                    "username_id": jsonresponseData[index]["id"].toString(),
                                    "status":StrValue

                                  },
                                  headers: {
                                    "Accept": "application/json"
                                  }
                              );

                              print("^^^^^^^^^^^^^^^^^");
                              print(response.body.toString());

                              if (response.body.toString()=="success"){
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>application()));
                              }else{
                                print("cannot attendence");
                              }



                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>application()));


                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1,),




                  ],
                ),
                // Text("Name : " + jsonresponseData[index]['username']['first_name'], style: const TextStyle( fontSize: 17, color: Colors.black),
                //
                // ),


          ):SizedBox(width: 0,height: 0,);
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child:
        Scaffold(
        appBar: AppBar(
          title: Text("Leave Applications"),
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>drawer())
                );
              }
          ),
          bottom: TabBar(
              tabs: [
                Tab(text: "Applications",),
                Tab(text: "Approved",),
                Tab(text: "Rajected",)
              ]),
        ),
        body: TabBarView(
          children: [
            Container(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loadData ?ListView.builder(
          itemCount: jsonresponseData.length,
            // shrinkWrap: true,
            itemBuilder:(BuildContext context,index){
          return jsonresponseData[index]['status'] == 'raised' ?
          InkWell(
            onTap:() {
              _showMyDialogCompleted(index);

              print("========================================================================");
              print(jsonresponseData[index]);
              // selectedIndex = index;
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Name : " + jsonresponseData[index]['username']['first_name']
                          // data[0].toString()+',  '+data[1].toString()
                          ,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey[500]),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Status : " +jsonresponseData[index]['status'],
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Title : " +jsonresponseData[index]['title'],
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Reason :" + jsonresponseData[index]['description']

                          ,style: const TextStyle(fontSize: 12),)
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("From Date : "+ jsonresponseData[index]["start_date"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                          // data[4].toString()=='null' ? const
                          Text("To Date: "+jsonresponseData[index]["end_date"], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                              // :Text("Out Time:" "dateee"
                        // + data[5].toString()
                // , style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold )),
                        ],
                      ),
                    )
                  ],
                ),
              ),



            ),
          )
              : SizedBox(height: 0,);
        }




        ) : Center(child: CircularProgressIndicator(),),

            ),
            ),
            approved_applications(),
            rajected_application()
          ],
        ),
        // drawer: drawer()
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
      onPressed: (){

        Navigator.push(context, MaterialPageRoute(builder: (context)=>writeApllication()));

      },
      ),
      )
    );

  }
}




class writeApllication extends StatefulWidget {
  const writeApllication({Key? key}) : super(key: key);

  @override
  _writeApllicationState createState() => _writeApllicationState();
}

class _writeApllicationState extends State<writeApllication> {
  String? _chosenValue;
  List listitems=[
    'Earned Leaves',
    'Sick Leaves',
    'Casual Leaves',
    'Marriege Leaves',
    'Maternity Leaves',
    'Annual Leaves'
  ];
  late SharedPreferences prefLoginData;
  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final dateController1 = TextEditingController();
  // final  title = new TextEditingController();
  final  description = new TextEditingController();

  String emp_name = "", emp_employee_id = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
            "Leave Application"
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Form(

          key: _formKey,

          child: Container(
            margin: EdgeInsets.only(top: 10.0,left: 10.0,right: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  validator: (value){
          if (value==null || value.isEmpty){
          return 'Please Select Your Title from Dropdown';
          }
          return null;
          },

                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.title)
                  ),
                  value: _chosenValue,
                  items: [
                    'Earned Leaves',
                    'Sick Leaves',
                    'Casual Leaves',
                    'Marriege Leaves',
                    'Maternity Leaves',
                    'Annual Leaves'
                  ].map((label) => DropdownMenuItem(child: Text(
                      label.toString()),
                    value: label,

                  )
                  ).toList(),
                  icon: Icon(Icons.arrow_drop_down_sharp),
                  hint: const Text("Select title for leaves",
                 ),
                  onChanged: (val){
                    setState(() {
                      _chosenValue=val!;
                      print(_chosenValue);
                    });
                  },


                ),
                TextFormField(

                  validator: (value){
                    if (value==null || value.isEmpty){
                      return 'Please pick a Date';
                    }
                    return null;
                  },

                  controller: dateController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today_outlined),

                      // icon: Icon(Icons.calendar_today_outlined),
                      hintText: "From Date",
                      labelText: "Select Starting Data"
                  ),
                  focusNode: AlwaysDisabledFocusNode1(),
                  onTap: () async {
                    var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));
                    dateController.text = date.toString().substring(0, 10);

                    // print(dateController);
                  },
                ),TextFormField(

                  validator: (value){
                    if (value==null || value.isEmpty){
                      return 'Please pick a Date';
                    }
                    return null;
                  },

                  controller: dateController1,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      // icon: Icon(Icons.calendar_today_outlined),
                      hintText: "To Date",
                      labelText: "Select Ending Data"
                  ),
                  focusNode: AlwaysDisabledFocusNode1(),
                  onTap: () async {
                    var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));
                    dateController1.text = date.toString().substring(0, 10);

                    // print(dateController);
                  },
                ),
                TextFormField(

                  controller: description,
                  keyboardType: TextInputType.text,
                  validator: (value){
                    if (value==null || value.isEmpty){
                      return 'Enter a Description';
                    }
                    return null;
                  },

                  decoration:  InputDecoration(

                    prefixIcon: Icon(Icons.message_sharp),
                    // icon: Icon(Icons.title_sharp),
                    hintText: "Enter Reason for leave",
                    labelText: "Reason for leave",
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 80.0, top: 40.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 200,height: 50),
                    child: ElevatedButton(
                      child: Text("Submit"),
                      onPressed: () async {
                        print("-----------------------------");
                      print(dateController.text);
                      // print(emp_employee_id);
                      prefLoginData = await SharedPreferences.getInstance();
                        // print(prefLoginData.getString("id"));
                        String? emp_employee_id= prefLoginData.getString('id');
                        // print("%%%%%%%%%%%%%%%%%%%");
                        // print(emp_employee_id);
                        // print(prefLoginData.getString("id"));
                        if (_formKey.currentState!.validate()) {
                          print(emp_employee_id);
                          var response = await http.post(Uri.parse(
                              Urls.sendLeaveApplication),
                              body: {
                                "username_id": emp_employee_id.toString(),
                                "start_date": dateController.text,
                                "end_date": dateController1.text,
                                "description": description.text,
                                "title": _chosenValue.toString(),
                              },
                              headers: {
                                "Accept": "application/json"
                              }
                          );
                          print(
                              "-----------------------##################----");
                          print(response.body.toString());
                          //   print("-------------------------------------");
                          //   print(response.body.toString());
                          //   print(response.body.toString()=="success");
                          //
                          if (response.body.toString() == "success") {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => application()));
                          } else {
                            print("I unable to send it");
                          }

                          //     ));
                          //   }
                          //
                          // }
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          )
      ),

    );

  }
}

// for disable text editing mode and enable only for calender
class AlwaysDisabledFocusNode1 extends FocusNode {
  @override
  bool get hasFocus => false;
}


// items: listitems.map<DropdownMenuItem<String>>((valueitem){
// return DropdownMenuItem(
// value: valueitem,
// child: Text(valueitem),
// );
// }).toList(),


// DropdownButtonFormField<String>(
// focusColor:Colors.white,
// icon: Icon(Icons.arrow_drop_down),
// iconSize: 20.0,
// style: TextStyle(color: Colors.white),
// iconEnabledColor: Colors.black,
// value: _chosenValue,
// onChanged: (String? newvalue){
// setState(() {
// _chosenValue=newvalue;
// });
// },
// items: listitems.map((valueitem) => DropdownMenuItem(child: Text(valueitem.toString()),
// value: valueitem,
// )).toList(),
//
//
// ),