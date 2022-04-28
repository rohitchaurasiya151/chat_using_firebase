import 'package:chat_using_firebase/constant/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/circle_Image.dart';

class WidgetProfileIconWithQRCode extends StatelessWidget {
  const WidgetProfileIconWithQRCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleImage(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text("Rohit Chaurasiya"), Text("🧬️❤️️🎵 HAI")],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Icon(
                Icons.qr_code,
                size: 70.h,

                color: wcAppThemeColor.withOpacity(0.7),
              ),
            ),
          )
        ],
      ),
    );
  }
}
