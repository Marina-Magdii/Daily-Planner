import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
   CustomTextField({
     super.key,
     required this.hintText,
     required this.validator,
     required this.obscure,
     required this.controller,
     required this.isPass
   });
   final String hintText;
    bool obscure=false;
   final TextEditingController controller;
   final String? Function(String?)? validator;
   bool isPass=false;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.all(25.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscure,
        validator:widget.validator ,
        decoration: InputDecoration(
          suffixIcon: widget.isPass? IconButton(onPressed: (){
            widget.obscure=!widget.obscure;
            setState(() {
            });
          }, icon: widget.obscure?Icon(Icons.visibility_off):Icon(Icons.visibility)):null,
          hintText:widget.hintText ,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: Colors.transparent, width: 2.w),
          ),
          focusedBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: Colors.transparent, width: 2.w),
          ) ,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: Colors.transparent, width: 2.w),
          )
        ),
      ),
    );
  }
}
