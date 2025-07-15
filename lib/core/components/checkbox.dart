import 'package:findemy_mobile/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Icon(
            value ? Symbols.check_circle : Symbols.radio_button_unchecked,
            color: value ? FindemyColor.green400 : FindemyColor.gray03,
            size: 13,
          ),
        ),
        SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: FindemyColor.black,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}