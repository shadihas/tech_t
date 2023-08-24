import 'package:flutter/material.dart';

import '../../../core/utils/utils.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.homeTextEditingController,
    required this.hintText,
  });

  final TextEditingController homeTextEditingController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: homeTextEditingController,
      cursorColor: AppColors.lightBlueColor,
      decoration: InputDecoration( 
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.greyTextColor,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.greyTextColor,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.greyTextColor,
          ),),
          hintText: hintText,
          hintStyle: AppFontStyle.appTextStyle(color: AppColors.greyTextColor)
              ),
    );
  }
}