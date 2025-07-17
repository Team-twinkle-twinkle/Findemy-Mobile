import 'package:findemy_mobile/core/constants/color.dart';
import 'package:findemy_mobile/models/subject_enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:findemy_mobile/presentation/academy_page/view/academy_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:findemy_mobile/core/components/header/logo_header.dart';
import 'package:findemy_mobile/models/mypage_model.dart';
import 'package:findemy_mobile/services/api_services.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  MyPageModel? _myPageData;
  String? _loggedInUserId;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeMyPage();
  }

  Future<void> _initializeMyPage() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await _loadLoggedInUserId();

    if (_loggedInUserId != null && _loggedInUserId!.isNotEmpty) {
      try {
        final data = await ApiServices.mypageData();
        if (mounted) {
          setState(() {
            _myPageData = data;
          });
        }
      } catch (e) {
        print('마이페이지 데이터 불러오기 실패: $e');
        if (mounted) {
          setState(() {
            _errorMessage = '마이페이지 데이터를 불러오는데 실패했습니다.';
            _myPageData = null;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _errorMessage = '로그인이 필요합니다. 사용자 정보를 찾을 수 없습니다.';
          _myPageData = null;
        });
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _loggedInUserId = prefs.getString('loggedInUserId');
    print('MyPage에서 불러온 사용자 ID: $_loggedInUserId');
    String? token = prefs.getString('accessToken');
    if (token != null && token.isNotEmpty) {
      ApiServices.setAuthorizationToken(token);
      print('MyPage: SharedPreferences에서 불러온 Access Token: ${token.substring(0, 10)}...');
    } else {
      print('MyPage: SharedPreferences에 저장된 토큰 없음.');
    }
    print('MyPage: 현재 Dio 헤더: ${ApiServices.dio.options.headers}');
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원', 'ko_KR');
    return formatter.format(amount);
  }

  int _getTotalAmount() {
    return _myPageData?.totalPrice ?? 0;
  }

  void _removeWishlistItem(int index) async {
    if (_myPageData == null || _myPageData!.favorites.isEmpty) return;

    final academyIdToRemove = _myPageData!.favorites[index].academyId;

    try {
      await ApiServices.deleteFavorite(academyIdToRemove);
      print('찜 취소 API 호출 성공: 학원 ID $academyIdToRemove');
      await _initializeMyPage();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('찜한 항목이 삭제되었습니다.')),
      );
    } catch (e) {
      print('찜 취소 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('찜 취소 실패: ${e.toString()}')),
      );
    }
  }

  void _navigateToAcademyDetail(String academyIdString) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcademyDetailPage(academyId: academyIdString),
      ),
    );
    await _initializeMyPage();
  }

  Widget _buildWishlistItem(Favorite item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FindemyColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FindemyColor.gray02),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: FindemyColor.gray01,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                item.academyName.substring(0, 1),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: FindemyColor.green500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToAcademyDetail(item.academyId.toString()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.academyName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: FindemyColor.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.address ?? '주소 정보 없음',
                    style: TextStyle(
                      fontSize: 12,
                      color: FindemyColor.gray05,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.subjects.map((s) => SubjectEnumExtension.fromString(s).displayName).join(', '),
                    style: TextStyle(
                      fontSize: 12,
                      color: FindemyColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _removeWishlistItem(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: FindemyColor.gray03,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: FindemyColor.gray05,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatCurrency(item.price),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: FindemyColor.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeMyPage,
                child: const Text('다시 시도 / 로그인 페이지로 이동'),
              ),
            ],
          ),
        ),
      );
    }

    if (_myPageData == null) {
      return Scaffold(
        body: Center(
          child: Text('마이페이지 데이터를 불러올 수 없습니다.'),
        ),
      );
    }


    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LogoHeader(),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 24),
              child: Text(
                // Use null-aware operator to safely access accountId
                '${_myPageData?.accountId ?? '사용자'}님의 마이페이지',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: FindemyColor.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: FindemyColor.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: FindemyColor.gray03),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '현재 예상 지출비용',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: FindemyColor.black,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '약 ${_formatCurrency(_getTotalAmount())}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: FindemyColor.green700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 38),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                '찜한 목록',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: FindemyColor.gray05,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (_myPageData!.favorites.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(
                        Symbols.favorite_border,
                        size: 48,
                        color: FindemyColor.gray04,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '찜한 학원이 없습니다',
                        style: TextStyle(
                          fontSize: 16,
                          color: FindemyColor.gray05,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (int i = 0; i < _myPageData!.favorites.length; i++)
                      _buildWishlistItem(_myPageData!.favorites[i], i),
                  ],
                ),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}