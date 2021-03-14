import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Contacs {
  final String id;
  String name;
  String no;
  var sayac = 1;
  Contacs({
    this.id,
    this.name,
    this.no,
  });
}

class ContacsProvider with ChangeNotifier {
  List<Contacs> get itemsList {
    databasevalue();
    return _contacsList;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var id, name, no;
  var sayac2 = 1;
  void databasevalue() {
    if (Contacs().sayac == sayac2) {
      _firestore.collection("rehber2").get().then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          debugPrint(value.docs[i].data().toString());
          id = value.docs[i].data()["id"];
          name = value.docs[i].data()["name"];
          no = value.docs[i].data()["no"];

          createContacs(
            Contacs(id: id, name: name, no: no),
          );
        }
        sayac2++;
      });
    }
  }

  List<Contacs> _contacsList = [];

  Contacs getById(String id) {
    return itemsList.firstWhere((contacs) => contacs.id == id);
  }

  void createContacs(Contacs contacs) {
    var bayrak = 0;
    final newContacs = Contacs(
      id: contacs.id,
      name: contacs.name,
      no: contacs.no,
    );
    for (var i = 0; i < _contacsList.length; i++) {
      if (newContacs.name == _contacsList[i].name) bayrak = 1;
    }
    if (bayrak == 0) {
      itemsList.add(newContacs);
      notifyListeners();
    }
  }

  void deleteDatabaseContacs(String id) async {
    print("{$id}");
    await _firestore.collection("rehber2").get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        var deleteid = value.docs[i].data()["id"];
        if (deleteid == id) {
          var docid = value.docs[i].id;
          _firestore.doc("rehber2/$docid").delete();
        }
      }
    });
  }

  void editContacs(Contacs contacs) {
    deleteContacs(contacs.id); //eleman siliyor
    createContacs(contacs);
  }

  void deleteContacs(String id) {
    itemsList.removeWhere((contacs) =>
        contacs.id == id); //aldığı id ye sahip elemanı listeden kaldırıyor
    notifyListeners();
  }
}

class HomeContacs extends StatelessWidget {
  var sayac = 1;
  int getSayac() {
    return sayac;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: List1(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          showModalBottomSheet(
            context: context,
            builder: (_) => CreateContacs(isEditMode: false),
          );
        },
        tooltip: 'Add a new item!',
      ),
    );
  }
}

class List1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contacsList = Provider.of<ContacsProvider>(context).itemsList;
    return ListView.builder(
      itemCount: contacsList.length,
      itemBuilder: (context, index) {
        return MaterialList(contacsList[index]);
      },
    );
  }
}

class MaterialList extends StatefulWidget {
  final Contacs contacs;

  MaterialList(this.contacs);

  @override
  _MaterialListState createState() => _MaterialListState();
}

class _MaterialListState extends State<MaterialList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var id, name, no;
  var sayac2 = HomeContacs().getSayac();
  @override
  void initState() {
    //databasevalue();
    sayac2++;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.contacs.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<ContacsProvider>(context, listen: false)
            .deleteContacs(widget.contacs.id);
      },
      child: GestureDetector(
        child: Container(
          height: 65,
          child: Card(
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                        padding: EdgeInsets.all(1.0),
                        iconSize: 50,
                        icon: Icon(
                          IconData(60176, fontFamily: 'MaterialIcons'),
                        ),
                        onPressed: () {}),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text("      "),
                            Text(
                              widget.contacs.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("      "),
                            Text(
                              widget.contacs.no,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => CreateContacs(
                            id: widget.contacs.id,
                            isEditMode: true,
                          ),
                        );
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            Provider.of<ContacsProvider>(context, listen: false)
                                .deleteDatabaseContacs(widget.contacs.id);
                            Provider.of<ContacsProvider>(context, listen: false)
                                .deleteContacs(widget.contacs.id);
                          });
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateContacs extends StatefulWidget {
  final String id;
  final bool isEditMode;

  CreateContacs({
    this.id,
    this.isEditMode,
  });

  @override
  _CreateContacsState createState() => _CreateContacsState();
}

class _CreateContacsState extends State<CreateContacs> {
  Contacs contacs;
  String _inputName;
  String _inputNo;
  final _formKey = GlobalKey<FormState>();

  void _validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (!widget.isEditMode) {
        Provider.of<ContacsProvider>(context, listen: false).createContacs(
          Contacs(
            id: DateTime.now().toString(),
            name: _inputName,
            no: _inputNo,
          ),
        );
      } else {
        Provider.of<ContacsProvider>(context, listen: false).editContacs(
          Contacs(
            id: contacs.id,
            name: _inputName,
            no: _inputNo,
          ),
        );
        Provider.of<ContacsProvider>(context, listen: false)
            .deleteDatabaseContacs(contacs.id);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    if (widget.isEditMode) {
      contacs = Provider.of<ContacsProvider>(context, listen: false)
          .getById(widget.id);
      _inputName = contacs.name;
      _inputNo = contacs.no;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return Container(
      height: 300,
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Write The Persons Fullname',
                style: Theme.of(context).textTheme.subtitle),
            TextFormField(
              initialValue: _inputName == null ? null : _inputName,
              decoration: InputDecoration(
                hintText: 'FullName',
              ),
              onSaved: (value) {
                _inputName = value;
              },
            ),
            Text("   ", style: Theme.of(context).textTheme.subtitle),
            Text("   ", style: Theme.of(context).textTheme.subtitle),
            Text("Write The Persons Telephone Number",
                style: Theme.of(context).textTheme.subtitle),
            TextFormField(
              initialValue: _inputName == null ? null : _inputNo,
              decoration: InputDecoration(
                hintText: 'Telephone Number',
              ),
              onSaved: (value) {
                _inputNo = value;
              },
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                child: Text(
                  !widget.isEditMode ? 'ADD CONTACS' : 'EDIT CONTACS',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontFamily: 'Lato',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _validateForm();
                  _firestore.collection('rehber2').add({
                    'id': DateTime.now().toString(),
                    'name': _inputName,
                    'no': _inputNo
                  });
                  //getir();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
