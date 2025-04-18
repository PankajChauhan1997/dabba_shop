import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/categoriesData.dart';
import '../model/categoryModel.dart';
import '../model/groceryItemModel.dart';
import 'package:http/http.dart'as http;

class NewItem extends StatefulWidget{
  const NewItem({super.key});

  @override
 State<NewItem>createState(){
    return _NewItemState();
  }

}

class _NewItemState extends State<NewItem>{
  final _formKey=GlobalKey<FormState>();
  var _enteredName='';
  var _enteredQuantity=1;
  var _selectedCategory=categories[Categories.vegetables]!;
  var _isSending=false;


  void _savedItem()async {
    if(_formKey.currentState!.validate()){
    _formKey.currentState!.save();
    setState((){
      _isSending=true;
    });
    final url=Uri.https('dabbashop-5eddb-default-rtdb.firebaseio.com','dabba_Shopping_List.json');
    final response=await http.post(
        url,
        headers:{'Content-Type':'application/json'},
        body:json.encode({
        'name': _enteredName,
        'quantity': _enteredQuantity,
        'category': _selectedCategory.title
        })
    );
    final Map<String, dynamic>resData=json.decode(response.body);
    if(!context.mounted) {
      return;
    }
    Navigator.of(context).pop(GroceryItem(
        id: resData['name'],
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _selectedCategory));
    }
  }
  @override
Widget build(BuildContext context){
    return Scaffold(
        appBar:AppBar(title:Text("Add a new item")),
        body:Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key:_formKey,
            child: Column(children:[
           TextFormField(
               maxLength:50,
               decoration:InputDecoration(label:Text('Name')),
                validator:(value){
             if(value==null||value.isEmpty||value.trim().length<=1||value.trim().length>50){
               return "Please enter name between 1 to 50 character";
             }
             return null;
                },
             onSaved:(value){
                 _enteredName=value!;
             },),

            Row(crossAxisAlignment:CrossAxisAlignment.end,
                children:[
              Expanded(
                child: TextFormField(
                    decoration:InputDecoration(label:Text("Quantity"),),
                    keyboardType:TextInputType.number,
                    initialValue:_enteredQuantity.toString(),
                    validator:(value){
                      if(value==null||
                          value.isEmpty||
                          int.tryParse(value)==null||
                          int.tryParse(value)!<=0){
                        return "Must be a positive number";
                      }
                      return null;

                },
                    onSaved:(value){
                      _enteredQuantity=int.tryParse(value!)!;
                }),
              ),
              SizedBox(width:8),
              Expanded(child:
              DropdownButtonFormField(
value:_selectedCategory,
                items: [
for(final category in categories.entries)
  DropdownMenuItem(
    value:category.value,
    child:
  Row(children:[
    Container(
        height:16,
        width:16,
        color:category.value.color),
    SizedBox(width:6),
    Text(category.value.title)
  ]),)
              ], onChanged: (value) {
  setState((){
    _selectedCategory=value!;

  });
              },))
            ]),
              SizedBox(height:20),
              Row(
                mainAxisAlignment:MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed:_isSending?null: _savedItem,
                    child: _isSending?
                    SizedBox(height:16,width:16,child:CircularProgressIndicator()):Text("Add Item"),),
                  TextButton(onPressed: _isSending?null:() {
                    _formKey.currentState!.reset();
                    // Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),)

                ],
              ),
            ])
          ),),
        );
  }

}