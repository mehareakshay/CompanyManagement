import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../urls.dart';

class rajected_application extends StatefulWidget {
  const rajected_application({Key? key}) : super(key: key);

  @override
  _rajected_applicationState createState() => _rajected_applicationState();
}

class _rajected_applicationState extends State<rajected_application> {


  bool loadData=false;
  bool noData=false;
  var jsonresponseData;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRajectedApplication();
  }
  Future getRajectedApplication() async {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: loadData ?ListView.builder(
                    itemCount: jsonresponseData.length,
                    // shrinkWrap: true,
                    itemBuilder:(BuildContext context,index){
                      return jsonresponseData[index]['status'] == 'Rajected' ?
                      Card(
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



                      )
                          : SizedBox(height: 0,);
                    }




                ) : Center(child: CircularProgressIndicator(),),

              ),
            ),
    );
  }
}
