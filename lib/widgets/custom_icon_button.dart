import 'package:flutter/material.dart';
import '../colors/colors.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const CustomIconButton({
    required this.iconData,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        iconData,
        color: AppColors.iconColor,
      ),
      onPressed: onPressed,
    );
  }
}
