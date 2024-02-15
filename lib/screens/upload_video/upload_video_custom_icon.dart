import 'package:flutter/material.dart';

class UploadVideoCustomIcon extends StatelessWidget {
  const UploadVideoCustomIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: 46,
      child: Stack(
        children: [
          Container(
              margin: EdgeInsets.only(left: 12),
              width: 40,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 250, 45, 108),
                borderRadius: BorderRadius.circular(8),
              )),
          Container(
            margin: EdgeInsets.only(right: 12),
            width: 40,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 32, 212, 234),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Center(
            child: Container(
              height: double.infinity,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.add,color: Colors.black,size: 24,),
            ),
          )
        ],
      ),
    );
  }
}
