import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Todo {
  final String id;
  String content;
  bool isDone;
  var sayac = 1;

  Todo({
    @required this.id,
    @required this.content,
    this.isDone = false,
  });
}

class PrvTodo with ChangeNotifier {
  final List<Todo> listTodo = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var id, content;
  var sayac2 = 1;

  List<Todo> get materialList {
    databasevalue();
    return listTodo;
  }

  void databasevalue() {
    if (Todo().sayac == sayac2) {
      _firestore.collection("notlar").get().then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          debugPrint(value.docs[i].data().toString());
          id = value.docs[i].data()["id"];
          content = value.docs[i].data()["content"];

          buildNewTodo(
            Todo(id: id, content: content),
          );
        }
        sayac2++;
      });
    }
  }

  Todo getById(String id) {
    return listTodo.firstWhere((todo) => todo.id == id);
  }

  void buildNewTodo(Todo todo) {
    var bayrak = 0;
    final newTodo = Todo(
      id: todo.id,
      content: todo.content,
    );
    for (var i = 0; i < listTodo.length; i++) {
      if (newTodo.content == listTodo[i].content) bayrak = 1;
    }
    if (bayrak == 0) {
      materialList.add(newTodo);
      notifyListeners();
    }
  }

  void editTodo(Todo todo) {
    deleteTodo(todo.id); //eleman siliyor
    buildNewTodo(todo);
  }

  void deleteDatabaseTodo(String id) async {
    await _firestore.collection("notlar").get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        var deleteid = value.docs[i].data()["id"];
        if (deleteid == id) {
          var docid = value.docs[i].id;
          _firestore.doc("notlar/$docid").delete();
        }
      }
    });
  }

  void deleteTodo(String id) {
    listTodo.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void changeStatus(String id) {
    int index = listTodo.indexWhere((todo) => todo.id == id);
    listTodo[index].isDone = !listTodo[index].isDone;
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: List1(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => CreateTodo(isEditMode: false),
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
    final todoList = Provider.of<PrvTodo>(context).materialList;
    return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (context, index) {
        return MaterialList(todoList[index]);
      },
    );
  }
}

class MaterialList extends StatefulWidget {
  final Todo todo;

  MaterialList(this.todo);

  @override
  _MaterialListState createState() => _MaterialListState();
}

class _MaterialListState extends State<MaterialList> {
  @override
  Widget build(BuildContext context) {
    void _checkItem() {
      setState(() {
        Provider.of<PrvTodo>(context, listen: false)
            .changeStatus(widget.todo.id);
      });
    }

    return Dismissible(
      key: ValueKey(widget.todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<PrvTodo>(context, listen: false).deleteTodo(widget.todo.id);
      },
      child: GestureDetector(
        onTap: _checkItem,
        child: Container(
          height: 65,
          child: Card(
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: widget.todo.isDone,
                      onChanged: (_) => _checkItem(),
                    ),
                    if (widget.todo.isDone)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.todo.content,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                    if (!widget.todo.isDone)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            widget.todo.content,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Row(
                  children: [
                    if (!widget.todo.isDone)
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => CreateTodo(
                              id: widget.todo.id,
                              isEditMode: true,
                            ),
                          );
                        },
                      ),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            Provider.of<PrvTodo>(context, listen: false)
                                .deleteDatabaseTodo(widget.todo.id);
                            Provider.of<PrvTodo>(context, listen: false)
                                .deleteTodo(widget.todo.id);
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

class CreateTodo extends StatefulWidget {
  final String id;
  final bool isEditMode;

  CreateTodo({
    this.id,
    this.isEditMode,
  });

  @override
  _CreateTodoState createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  Todo todo;
  String _inputcontent;
  final _formKey = GlobalKey<FormState>();

  void _validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (!widget.isEditMode) {
        Provider.of<PrvTodo>(context, listen: false).buildNewTodo(
          Todo(
            id: DateTime.now().toString(),
            content: _inputcontent,
          ),
        );
      } else {
        Provider.of<PrvTodo>(context, listen: false).editTodo(
          Todo(
            id: todo.id,
            content: _inputcontent,
          ),
        );
        Provider.of<PrvTodo>(context, listen: false)
            .deleteDatabaseTodo(todo.id);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    if (widget.isEditMode) {
      todo = Provider.of<PrvTodo>(context, listen: false).getById(widget.id);
      _inputcontent = todo.content;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return Container(
      height: 200,
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Your Todo', style: Theme.of(context).textTheme.subtitle),
            TextFormField(
              initialValue: _inputcontent == null ? null : _inputcontent,
              decoration: InputDecoration(
                hintText: 'Describe your todo',
              ),
              onSaved: (value) {
                _inputcontent = value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                child: Text(
                  !widget.isEditMode ? 'ADD TODO' : 'EDIT TODO',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontFamily: 'Lato',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _validateForm();
                  _firestore.collection('notlar').add({
                    'id': DateTime.now().toString(),
                    'content': _inputcontent
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
