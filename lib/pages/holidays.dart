import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../urls.dart';
import 'dart:async';
import 'drawer.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'dart:core';
List date = [];
List titleList = [];
//
// class Task{
// final String dateController;
// final String title;
//
// Task(this.dateController,this.title);
// }

class holidays extends StatefulWidget {
  const holidays({Key? key}) : super(key: key);
  @override
  _holidaysState createState() => _holidaysState();
}

class _holidaysState extends State<holidays> {
  // List data=[];

  bool noData = false;
  bool loadData = false;
  final dateController = new TextEditingController();
  final title=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHolidayData();
    // loadData = false;
    // if(date.length > 0)
    //   {
    //     loadData = true;
    //   }
  }
  @override
  // void dispose() {
  //   // Clean up the controller when the widget is removed
  //   dateController.dispose();
  //   super.dispose();
  // }


  var JsonData;
  Future getHolidayData() async{
    
    var response=await http.get(Uri.parse(Urls.showholidaydata),
    // body: {},
      headers:{"Accept": "application/json"}
    );
    print("gettingg..........................");
    print(response.body.toString());

    var converdatatoJson=jsonDecode(response.body.toString());

    JsonData=converdatatoJson['Holiday'];
    print(JsonData);
    print(JsonData[0]["date"]);


    if (JsonData.length==0){
      setState(() {
        noData=true;
      });
    }else{
      setState(() {
        loadData=true;
      });
    }

//     this.setState(() {
//       data=jsonDecode(response.body);
//     });
//     print("data------------");
// print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hoildays"),
        automaticallyImplyLeading: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_)=>drawer())
          );
        }
        ),
      ),

      body: Container(
        child: loadData ?ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: JsonData.length,
          itemBuilder: (BuildContext context, index){
            return index==JsonData.length?SizedBox():Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Date: " +  JsonData[index]["date"] , style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child:
                                Text("Reason For Holiday: " + JsonData[index]["occassion"], style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[600])
                            ,)
                            ) ,
                          ),


                        ],
                      ),



                    ],
                  ),
                )
            );

          },
        ) :  Center(child: CircularProgressIndicator()),

      ),
      floatingActionButton: FloatingActionButton(
    child: Icon(Icons.add),
    onPressed: (){
      
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCustomForm()));
      
    },
    ));
  }
}


class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {

  // TextEditingController TextController = new TextEditingController();

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final  title = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Add a Holiday"
        ),
        // automaticallyImplyLeading: false, //remove back button in appbar.
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 10.0,left: 10.0,right: 5.0),
          child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [



                    TextFormField(

                      validator: (value){
                        if (value==null || value.isEmpty){
                          return 'Please pick a Date';
                        }
                        return null;
                      },

                      controller: dateController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.holiday_village),

                          // icon: Icon(Icons.celebration),
                          hintText: "Pick a Date",
                          labelText: "Date of holiday"
                      ),
                      focusNode: AlwaysDisabledFocusNode1(),
                      onTap: () async {
                        var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        dateController.text = date.toString().substring(0, 10);

                        print(dateController);
                      },
                    ),
                    TextFormField(
                      controller: title,
                        keyboardType: TextInputType.text,
                      validator: (value){
                        if (value==null || value.isEmpty){
                          return 'Enter a Title';
                        }
                        return null;
                      },


                      // onChanged: (value) => TextController.text = value,
                      decoration:  InputDecoration(
                        prefixIcon: Icon(Icons.title),


                        // icon: Icon(Icons.title_sharp),
                        hintText: "Enter Title",
                        labelText: "Reason for holiday",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 70.0, top: 40.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: 200,height: 50),
                        child: ElevatedButton(

                          // style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                          child: Text("Add"),
                          onPressed: () async {

                            if (_formKey.currentState!.validate()){
                              // print("______________________________________________");
                              date.add(dateController.text);
                              print(dateController.text);
                              titleList.add(title.text);
                              print(title.text);

                              var response= await http.post(Uri.parse(Urls.addholidays),
                                body: {
                                "date": dateController.text,
                                  "occassion":title.text,
                                },
                                headers: {
                                "Accept": "application/json"
                                }
                              );

                              print("-------------------------------------");
                              print(response.body.toString());
                              print(response.body.toString()=="success");

                              if (response.body.toString()=="success"){
                                // Navigator.pop(context);
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>holidays()
                                ));
                            }

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(content: Text('Please wait...'))
                              // );
                              // Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>holidays()));
                            }

                          },
                        ),
                      ),
                    )
                  ],
                )
            ),
        ),
      ),

    );
  }
}

//for disable text editing mode and enable only for calender
class AlwaysDisabledFocusNode1 extends FocusNode {
  @override
  bool get hasFocus => false;
}
