import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/resources/color_resources.dart';

// ignore: must_be_immutable
class CommonButton extends StatelessWidget {
  String? text;
  Color? bgColor;
  Color? textColor;
  final VoidCallback ontap;
  BoxBorder? border;
  BorderRadiusGeometry? borderRadius;
  double? height;
  double? width;
  Widget? child;
  CommonButton({
    super.key,
    this.text,
    this.bgColor,
    required this.ontap,
    this.textColor,
    this.border,
    this.borderRadius,
    this.height,
    this.width,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: height ?? 55,
        alignment: Alignment.center,
        width: width ?? Get.width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius ?? BorderRadius.circular(15),
          color: bgColor,
          gradient: bgColor == null
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryColor,
                    const Color.fromARGB(255, 17, 99, 14),
                  ],
                )
              : null,
        ),
        child: child ??
            Text(
              text.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: textColor ?? Colors.white,
              ),
            ),
      ),
    );
  }
}
