import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerScreen extends StatefulWidget {
  @override
  _ShimmerScreenState createState() => _ShimmerScreenState();
}

class _ShimmerScreenState extends State<ShimmerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Shimmer.fromColors(
          period: Duration(milliseconds: 600 ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                   backgroundColor: Colors.white,
                ),
                SizedBox(height: ScreenUtil().setHeight(20),),
                Container(
                  height:ScreenUtil().setHeight(50),width: ScreenUtil().setWidth(500),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),border: Border.all(
                       color: Colors.white,
                      width: 1
                    )
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20),),
                 Container(
                  height:ScreenUtil().setHeight(45),width: ScreenUtil().setWidth(400),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                     color: Colors.white
                  ),
                )
              ],
            ),
          ),
         baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100]),
      ),
    );
  }
}