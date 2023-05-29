import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MytextField extends StatelessWidget{
  final labeledtext, hintedtext;
  final TextEditingController mycontroller;
  MytextField(
  {
   required this.labeledtext,
   required this.hintedtext,
   required this.mycontroller,
  });

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: mycontroller,
      validator: (value){
         if(value!.isEmpty){
           return "the $labeledtext is required" ;
      }
      },

      decoration: InputDecoration(
        labelText: labeledtext,
        hintText: hintedtext,
        enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Color(0xFF5CA7BA))) ,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Color(0xFF2E8FA8))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.red)) ,
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.red)),
               ),

    );

  }
}