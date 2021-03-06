import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new TodoApp());


class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: "Todo List",
      home: new TodoList()
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];
  String _newTask = "";

  void _addTodoItem(String task) {
    if(task.length > 0) {
      setState(() {
        _todoItems.add(task);
      });
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  void _promptRemoveTodoItem(int index){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Vous voulez supprimer "${_todoItems[index]}" ?'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('ANNULER'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            new FlatButton(
              child: new Text('SUPPRIMER LA NOTE'),
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  void _setNewTaskState(String task) {
    if(task.length > 0){
      setState(() {
        _newTask =task;
      });
    }
  }
  
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if(index < _todoItems.length){
          return _buildTodoItem(_todoItems[index], index);
        }
      },
    );
  }
  
  Widget _buildTodoItem(String todoText, int index){
    return new Container(
      child: new ListTile(
        title: new Text(
          todoText, 
          textDirection: TextDirection.ltr ,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        onTap: () => _promptRemoveTodoItem(index),
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
    );
    
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo List')
      ),
      body:_buildTodoList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Ajouter',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return _buildScreenAddTodo();
        }
      )
    );
  }

  Widget _buildScreenAddTodo() {
    Widget _textElement() {
      return new TextField(
        autofocus: true,
        onSubmitted: (val) {
          _addTodoItem(val);
        },
        onChanged: (val) {
          debugPrint('ajouter');
          _setNewTaskState(val);
        },
        decoration: new InputDecoration(
          hintText: 'Enter votre note ...',
          contentPadding: EdgeInsets.all(16)
        ),
      );
    }
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Ajouter une nouvelle note')
      ),
      body: new Container(
        padding: EdgeInsets.all(16),
        child: new Column(
          children: <Widget>[
            _textElement(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new RaisedButton(
                  padding: const EdgeInsets.all(8.0),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    _addTodoItem(_newTask);
                    Navigator.pop(context);
                  },
                  child: new Text("Ajouter"),
                ),
              ],
            )  
          ],
        )
      )
    );
  }

}