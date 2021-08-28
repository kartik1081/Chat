import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmer extends StatelessWidget {
  const MyShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(0xFF31444B),
      highlightColor: Color(0xFF618A99),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(100.0)),
            height: 10.0,
            width: 10.0,
          ),
          SizedBox(
            width: 4.0,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(100.0)),
            height: 10.0,
            width: 10.0,
          ),
          SizedBox(
            width: 4.0,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(100.0)),
            height: 10.0,
            width: 10.0,
          ),
          SizedBox(
            width: 4.0,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(100.0)),
            height: 10.0,
            width: 10.0,
          ),
          SizedBox(
            width: 4.0,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(100.0)),
            height: 10.0,
            width: 10.0,
          ),
        ],
      ),
    );
  }
}
