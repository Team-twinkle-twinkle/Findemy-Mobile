import 'package:findemy_mobile/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool showVisibilityToggle;
  final VoidCallback? onVisibilityToggle;
  final bool isPasswordVisible;
  final bool isRequired;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.showVisibilityToggle = false,
    this.onVisibilityToggle,
    this.isPasswordVisible = false,
    this.isRequired = false,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    setState(() {
      // 텍스트 변경 시 상태 업데이트
    });
  }

  Color _getBorderColor() {
    if (_hasFocus) {
      // 포커스 상태일 때 초록색
      return FindemyColor.green400;
    } else if (widget.controller.text.isNotEmpty) {
      // 텍스트가 있을 때 검은색
      return FindemyColor.black;
    } else {
      // 기본 상태 (포커스 없고 텍스트 없음) 회색
      return FindemyColor.gray03;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: TextStyle(
              color: FindemyColor.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            children: widget.isRequired
                ? [
              TextSpan(
                text: '*',
                style: TextStyle(color: FindemyColor.error),
              ),
            ]
                : [],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: FindemyColor.gray03,
              fontSize: 13,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _getBorderColor()),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: FindemyColor.green400),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _getBorderColor()),
            ),
            suffixIcon: widget.showVisibilityToggle
                ? IconButton(
              icon: Icon(
                widget.isPasswordVisible ? Symbols.visibility : Symbols.visibility_off,
                color: FindemyColor.green400,
              ),
              onPressed: widget.onVisibilityToggle,
            )
                : null,
          ),
        ),
      ],
    );
  }
}