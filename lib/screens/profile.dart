import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_container/responsive_container.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  List<IconData> list =[
    Icons.home,
    Icons.control_point,
    Icons.payment,
    Icons.notifications,
    Icons.settings_input_component,
    Icons.mic
  ];

  List<String> text = ["Add a Branch", "Management Control", "Payment",
    "Notification", "Settings", "Promotions"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white, fontSize: 25),),
        backgroundColor: Color(0xff1f154a),
        leading: ResponsiveContainer(
          heightPercent: 10.0,
          widthPercent: 10.0,
          child: Image.asset(
            'images/logo.png',
          ), //any widget
        ),
      ),
      backgroundColor: Colors.purple,
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xff322763),
                    Color(0xff2d225c),
                    Color(0xff2a1f59),
                    Color(0xff231850),
                    Color(0xff1f154a)
                  ],
                begin: Alignment.bottomCenter,
                end: Alignment.topRight,
              ),

            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "0.00",
                      style: TextStyle(color: Colors.white,
                      fontSize: 35, fontWeight: FontWeight.bold)),
                  TextSpan(text: " LE",
                      style: TextStyle(color: Colors.white,
                          fontSize: 25, fontWeight: FontWeight.bold)),
                ]
              ) ,

            ),
          ),

          Container(
            color: Color(0xffebeaec),
            height: MediaQuery.of(context).size.height - 150,
            child: GridView.builder(
                itemCount: list.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio: 1.2
                ),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) =>
                    item(index)),
          )
        ],
      ),
    );
  }

  item(int index){
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(list[index], color:  Color(0xff01adef), size: 35,),
          Text(
            text[index],
            style: TextStyle(
                color: Color(0xff20154a),
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),);
  }
}
