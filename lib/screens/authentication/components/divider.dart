
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class buildDivider extends StatelessWidget {
  const buildDivider({
    super.key, required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal: 40.0),
      child:  Row(
        children: [
          Expanded(child: Divider(thickness: 1,color: Colors.black,height: 1,)),
          SizedBox(width: 5,),
          Text(text,style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18
          ),),
          SizedBox(width: 5,),

          Expanded(child: Divider(thickness: 1,color: Colors.black,)),
        ],
      ),
    );
  }
}
