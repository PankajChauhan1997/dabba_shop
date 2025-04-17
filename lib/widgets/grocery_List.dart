import 'package:flutter/material.dart';
import '../model/groceryItemModel.dart';
import 'new_Item.dart';

class GroceriesItem extends StatefulWidget {
  const GroceriesItem({super.key});

  @override
  State<GroceriesItem> createState() => _GroceriesItemState();
}

class _GroceriesItemState extends State<GroceriesItem> {
  final List<GroceryItem>_groceryItems=[];

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
    setState((){
      _groceryItems.remove(item);

    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content=Center(child:Text("No items added yet Please add some"));
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
              title:Text(_groceryItems[index].id),
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
