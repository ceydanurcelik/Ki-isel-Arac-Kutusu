import 'package:flutter/material.dart';

class CalButton {
  final id;
  String text;
  Color color;

  CalButton({this.id, this.text, this.color = Colors.blueGrey});
}

class HomePageCal extends StatefulWidget {
  @override
  _HomePageCalState createState() => _HomePageCalState();
}

class _HomePageCalState extends State<HomePageCal> {
  List<CalButton> buttonsList;
  var num1 = 0, num2 = 0, sum = 0;
  String txt = "", islem = "";
  final TextEditingController t1 = new TextEditingController(text: "0");
  final TextEditingController t2 = new TextEditingController(text: "0");

  List<CalButton> doInit() {
    var num1 = 0, num2 = 0, sum = 0;
    var buttons = <CalButton>[
      new CalButton(id: 1, text: "/"),
      new CalButton(id: 2, text: "*"),
      new CalButton(id: 3, text: "+"),
      new CalButton(id: 4, text: "-"),
      new CalButton(id: 5, text: "1"),
      new CalButton(id: 6, text: "2"),
      new CalButton(id: 7, text: "3"),
      new CalButton(id: 8, text: "AC"),
      new CalButton(id: 9, text: "4"),
      new CalButton(id: 10, text: "5"),
      new CalButton(id: 11, text: "6"),
      new CalButton(id: 12, text: "="),
      new CalButton(id: 13, text: "7"),
      new CalButton(id: 14, text: "8"),
      new CalButton(id: 15, text: "9"),
      new CalButton(id: 16, text: "0"),
    ];
    return buttons;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonsList = doInit();
  }

  void Calculator(CalButton cb) {
    setState(() {
      if (cb.text == "1") {
        txt = txt + "1";
      }
      if (cb.text == "2") {
        txt = txt + "2";
      }
      if (cb.text == "3") {
        txt = txt + "3";
      }
      if (cb.text == "4") {
        txt = txt + "4";
      }
      if (cb.text == "5") {
        txt = txt + "5";
      }
      if (cb.text == "6") {
        txt = txt + "6";
      }
      if (cb.text == "7") {
        txt = txt + "7";
      }
      if (cb.text == "8") {
        txt = txt + "8";
      }
      if (cb.text == "9") {
        txt = txt + "9";
      }
      if (cb.text == "0") {
        txt = txt + "0";
      }
      if (cb.text == "=") {
        num2 = int.parse(txt);
        if (islem == "*") {
          sum = num1 * num2;
          txt = sum.toString();
        }
        if (islem == "/") {
          sum = num1 ~/ num2;
          txt = sum.toString();
        }
        if (islem == "+") {
          sum = num1 + num2;
          txt = sum.toString();
        }
        if (islem == "-") {
          sum = num1 - num2;
          txt = sum.toString();
        }
      }
      if (cb.text == "AC") {
        num1 = 0;
        num2 = 0;
        sum = 0;
        txt = "";
      }
      if (cb.text == "*") {
        num1 = int.parse(txt);
        txt = "";
        islem = "*";
      }

      if (cb.text == "/") {
        num1 = int.parse(txt);
        txt = "";
        islem = "/";
      }
      if (cb.text == "+") {
        num1 = int.parse(txt);
        txt = "";
        islem = "+";
      }
      if (cb.text == "-") {
        num1 = int.parse(txt);
        txt = "";
        islem = "-";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          child: Text(""),
          height: 80,
        ),
        new Text(
          "$txt",
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: 40, color: Colors.blueGrey),
        ),
        SizedBox(
          child: Text(""),
          height: 20,
        ),
        new Expanded(
          child: new GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.1,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 2.0),
            itemCount: buttonsList.length,
            itemBuilder: (context, i) => new SizedBox(
              width: 40.0,
              height: 40.0,
              child: new FloatingActionButton(
                onPressed: () => Calculator(buttonsList[i]),
                child: new Text(
                  buttonsList[i].text,
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                elevation: 10,
                backgroundColor: Colors.blueGrey,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
