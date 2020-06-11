import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de compras',
      theme: ThemeData(
        primarySwatch: Colors.green),
      home: HomePage(),
    );
  }
}



class HomePage extends StatefulWidget {
  var items = new List<Item>();
  
  HomePage(){
    items = [];
    // items.add(Item(title:'Manga', done: false));
    // items.add(Item(title:'Melancia', done: false));
    // items.add(Item(title:'Laranja', done: true));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var novointem = TextEditingController();

  void addItem(){
    if(novointem.text.isEmpty) return;
    setState(() {
      widget.items.add(Item(title: novointem.text, done: false),
      );
      novointem.text = "";
    });
  }

  void removeItem(int index){
    setState(() {
      widget.items.removeAt(index);
    });
  }

  Future load() async{
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null){
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }

  }

_HomePageState() {
  load();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: novointem,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            ),
            decoration: InputDecoration(
              labelText: 'novo item',
              labelStyle: TextStyle(
                fontSize: 20,
                color: Colors.white
              )
            ),
        ),
      ),
      body: ListView.builder( 
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index){
          final item = widget.items[index];

          return Dismissible(
            child: CheckboxListTile(
              checkColor: Colors.white,
              activeColor: Colors.red,
              title: Text(item.title),
              
              value: item.done,
              onChanged: (value){
                setState(() {
                  item.done = value;
                });
            },
          ),
          key: Key(item.title),
          background: Container(
            color: Colors.red.withOpacity(0.2),
          ),
          onDismissed: (direction){
            removeItem(index);
          },
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItem,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        ),
    );
  }
}