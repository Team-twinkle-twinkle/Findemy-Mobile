import 'dart:math' as math;
import 'package:findemy_mobile/core/components/button/elevated_button.dart';
import 'package:findemy_mobile/core/components/checkbox.dart';
import 'package:findemy_mobile/core/components/text_form_field/custom_text_form_field.dart';
import 'package:findemy_mobile/core/constants/color.dart';
import 'package:findemy_mobile/presentation/login_page/view/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberLogin = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: SvgPicture.asset(
                    'assets/image/character.svg',
                    width: 48,
                    height: 45,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '효율적인 학원 선택을 위한',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: FindemyColor.black,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '찾아데미',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: FindemyColor.black,
                            ),
                          ),
                          TextSpan(
                            text: '입니다.',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: FindemyColor.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 28),
            CustomTextField(
              controller: _userIdController,
              hintText: '아이디를 입력해주세요',
            ),
            SizedBox(height: 24),
            CustomTextField(
              controller: _passwordController,
              hintText: '비밀번호를 입력해주세요',
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Symbols.visibility
                      : Symbols.visibility_off,
                  color: FindemyColor.green400,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _errorMessage != null
                      ? Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: FindemyColor.error,
                      fontSize: 12,
                    ),
                  )
                      : SizedBox.shrink(),
                ),
                CustomCheckbox(
                  value: _rememberLogin,
                  onChanged: (bool? value) {
                    setState(() {
                      _rememberLogin = value ?? false;
                    });
                  },
                  text: '로그인 상태 유지',
                ),
              ],
            ),
            SizedBox(height: 32),
            CustomElevatedButton(
              text: '로그인',
              onPressed: () {
                setState(() {
                  _errorMessage = '일치하는 사용자가 없습니다.';
                });
                print('login');
              },
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '계정이 없으신가요?',
                  style: TextStyle(color: FindemyColor.black, fontSize: 12),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      color: FindemyColor.green500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}