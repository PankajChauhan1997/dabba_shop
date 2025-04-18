import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import '../data/categoriesData.dart';
import '../model/groceryItemModel.dart';
import 'new_Item.dart';

class GroceriesItem extends StatefulWidget {
  const GroceriesItem({super.key});

  @override
  State<GroceriesItem> createState() => _GroceriesItemState();
}

class _GroceriesItemState extends State<GroceriesItem> {
   List<GroceryItem>_groceryItems=[];
  String? isError;
   var _isLoading=true;

  void initState(){

    super.initState();
    _loadItems();
  }

void _loadItems()async{

  final uri=Uri.https('dabbashop-5eddb-default-rtdb.firebaseio.com','dabba_Shopping_List.json');

    final response = await http.get(uri);
    print("response....${response.body}");
    if (response.statusCode >= 400 || response.body == null ||
        response.body == 'null' || response.body.isEmpty) {
        isError = 'Failed to fetch data, Please try again later!!!';

    }
    if (response.statusCode >= 400 || response.body == null ||
        response.body == 'null' || response.body.isEmpty) {
        isError = 'Failed to fetch data, Please try again later!!!';
    }

    final Map<String, dynamic>data = json.decode(response.body);
    final List<GroceryItem>loaditem = [];
    for (final item in data.entries) {
      final category = categories.entries
          .firstWhere((catItem) =>
      catItem.value.title == item.value['category'])
          .value;
      loaditem.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category
      ));
    }
    setState(() {
      _groceryItems = loaditem;
      _isLoading = false;
    });

  }
  void _addItem()async{

    final newItem=await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(builder: (context)=>const NewItem()));

    if(newItem==null){
      return;
    }
    setState((){
      _groceryItems.add(newItem);

    });
  }
  void _removeItem(GroceryItem item)async{
    final _index=_groceryItems.indexOf(item);
    setState((){
      _groceryItems.remove(item);

    });
    final uri=Uri.https('dabbashop-5eddb-default-rtdb.firebaseio.com','dabba_Shopping_List/${item.id}.json');
     final response=await http.delete(uri);
     if(response.statusCode>=400){

    setState((){
      _groceryItems.insert(_index,item);

    });}
  }

  @override
  Widget build(BuildContext context) {
    Widget content=Center(child:Text("No items added yet Please add some"));
    if(isError!=null){
      content= Center(child:Text(isError!));
    }
    if(_groceryItems.isNotEmpty){
content=ListView.builder(
    itemCount:_groceryItems.length,
    itemBuilder: (context,index) =>
        Dismissible(key:ValueKey(_groceryItems[index].id),
          onDismissed:(direction){
          _removeItem(_groceryItems[index]);
          },
          child: ListTile(
              leading:Container(
                  height:24,
                  width:24,
                  color:_groceryItems[index].category.color),
              title:Text(_groceryItems[index].name),
              trailing:Text(_groceryItems[index].quantity.toString())),
        ));
    }
    
    return Scaffold(
      appBar:AppBar(title:Text("Your Groceries"),actions:[
        IconButton(onPressed: _addItem, icon: Icon(Icons.add),)
      ]),
      body:content
    );
  }
}
