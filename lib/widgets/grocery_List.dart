import 'package:flutter/material.dart';
import '../data/dummy_itemsData.dart';
import 'new_Item.dart';

class GroceriesItem extends StatefulWidget {
  const GroceriesItem({super.key});

  @override
  State<GroceriesItem> createState() => _GroceriesItemState();
}

class _GroceriesItemState extends State<GroceriesItem> {
  void _addItem(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NewItem()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text("Your Groceries"),actions:[
        IconButton(onPressed: _addItem, icon: Icon(Icons.add),)
      ]),
      body: ListView.builder(
          itemCount:groceryItems.length,
        itemBuilder: (context,index) =>
ListTile(
    leading:Container(
    height:24,
    width:24,
    color:groceryItems[index].category.color),
    title:Text(groceryItems[index].id),
    trailing:Text(groceryItems[index].quantity.toString())))
    );
  }
}
