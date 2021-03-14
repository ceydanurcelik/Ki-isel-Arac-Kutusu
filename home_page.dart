import 'package:deneme_button/hesapwidgets.dart';
import 'package:deneme_button/todolistwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'contacswidgets.dart';

class todolist extends StatelessWidget {
  const todolist({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrvTodo(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Homepage(),
      ),
    );
  }
}

class rehber extends StatelessWidget {
  const rehber({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContacsProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeContacs(),
      ),
    );
  }
}

class hesapmakinesi extends StatelessWidget {
  const hesapmakinesi({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePageCal(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedTabIndex = 0;

  List _pages = [
    rehber(
      key: PageStorageKey('Page1'),
    ),
    todolist(
      key: PageStorageKey('Page2'),
    ),
    hesapmakinesi(
      key: PageStorageKey('Page2'),
    ),
  ];

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
            child:
                new Text('MY PERSONAL TOOLBOX', textAlign: TextAlign.center)),
      ),
      body: Center(child: _pages[_selectedTabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedTabIndex,
        onTap: _changeIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note),
              title: Text("Kişi Rehberi"),
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.check),
              title: Text("To Do List"),
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(IconData(58914, fontFamily: 'MaterialIcons')),
              title: Text("Hesap Makinesi"),
              backgroundColor: Colors.black),
        ],
      ),
    );
  }
}
