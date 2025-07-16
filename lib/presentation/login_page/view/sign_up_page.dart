import 'package:findemy_mobile/core/components/button/elevated_button.dart';
import 'package:findemy_mobile/core/components/text_form_field/custom_input_field.dart';
import 'package:findemy_mobile/core/constants/color.dart';
import 'package:findemy_mobile/models/sign_up_model.dart';
import 'package:findemy_mobile/models/user_model.dart';
import 'package:findemy_mobile/presentation/main_app.dart';
import 'package:findemy_mobile/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:dio/dio.dart';

class SignUpSuccessPage extends StatefulWidget {
  const SignUpSuccessPage({super.key});

  @override
  State<SignUpSuccessPage> createState() => _SignUpSuccessPageState();
}

class _SignUpSuccessPageState extends State<SignUpSuccessPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainApp()),
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const RadialGradient(
                  center: Alignment.center,
                  radius: 0.6,
                  colors: [Color(0xFFC2FF92), Color(0xFF8CEF3F)],
                ).createShader(bounds);
              },
              child: const Icon(
                Symbols.check_circle,
                size: 51,
                color: Colors.white,
                fill: 1,
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '회원가입',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: FindemyColor.black,
                    ),
                  ),
                  TextSpan(
                    text: '이\n완료되었습니다',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: FindemyColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordMatch = true;
  bool _isIdValid = false;
  bool _isPasswordValid = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _idController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    final currentPasswordMatch =
        _passwordController.text == _confirmPasswordController.text;

    final currentIdValid = _idController.text.length >= 10;

    final currentPasswordValid = _passwordController.text.isNotEmpty &&
        _passwordController.text.length <= 20 &&
        _passwordController.text.contains(RegExp(r'[a-zA-Z]')) &&
        _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    setState(() {
      _isPasswordMatch = currentPasswordMatch || _confirmPasswordController.text.isEmpty;
      _isIdValid = currentIdValid;
      _isPasswordValid = currentPasswordValid;
      _isFormValid = _isIdValid && _isPasswordValid && _isPasswordMatch && _confirmPasswordController.text.isNotEmpty;
    });
  }

  Future<void> _handleSignUp() async {
    try {
      final user = UserModel(
        accountId: _idController.text,
        password: _passwordController.text,
      );
      await ApiServices.signupUser(user);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpSuccessPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 65),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Symbols.arrow_back_ios,
                    color: FindemyColor.green400,
                  ),
                ),
                SvgPicture.asset(
                  'assets/image/logo.svg',
                  width: 84,
                  height: 35,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '회원가입',
                    style: TextStyle(
                      color: FindemyColor.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 54),
                  CustomInputField(
                    label: '아이디',
                    hintText: '10자 이상으로 입력해주세요',
                    controller: _idController,
                    isRequired: true,
                  ),
                  const SizedBox(height: 40),
                  CustomInputField(
                    label: '비밀번호',
                    hintText: '20자 이하 영어와 특수문자를 포함하여 입력해주세요',
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    showVisibilityToggle: true,
                    isPasswordVisible: _isPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    isRequired: true,
                  ),
                  const SizedBox(height: 40),
                  CustomInputField(
                    label: '비밀번호 확인',
                    hintText: '20자 이하 영어와 특수문자를 포함하여 입력해주세요',
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    showVisibilityToggle: true,
                    isPasswordVisible: _isConfirmPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    isRequired: true,
                  ),

                  if (_confirmPasswordController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _isPasswordMatch
                                ? '비밀번호가 일치합니다'
                                : '비밀번호가 일치하지 않습니다',
                            style: TextStyle(
                              color: _isPasswordMatch
                                  ? FindemyColor.green
                                  : FindemyColor.error,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: CustomElevatedButton(
                      text: '회원가입 하기',
                      onPressed: _isFormValid ? _handleSignUp : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}