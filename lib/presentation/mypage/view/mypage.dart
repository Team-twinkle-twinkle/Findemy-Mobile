import 'package:findemy_mobile/core/components/header/logo_header.dart';
import 'package:findemy_mobile/presentation/academy_page/view/academy_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:findemy_mobile/core/constants/color.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:intl/intl.dart';

class WishlistItem {
  final String academyId;
  final String academyName;
  final String academyAddress;
  final List<String> subjects;
  final int totalPrice;
  final String academyImageUrl;

  WishlistItem({
    required this.academyId,
    required this.academyName,
    required this.academyAddress,
    required this.subjects,
    required this.totalPrice,
    required this.academyImageUrl,
  });
}

class MyPage extends StatefulWidget {
  final String userName;

  const MyPage({super.key, this.userName = '권수현'});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<WishlistItem> _wishlistItems = [];

  @override
  void initState() {
    super.initState();
    _loadWishlistItems();
  }

  void _loadWishlistItems() {
    // 샘플 데이터
    _wishlistItems = [
      WishlistItem(
        academyId: '1',
        academyName: '메가스터디 교육',
        academyAddress: '서울 서초구 서초 1동',
        subjects: ['수학'],
        totalPrice: 550000,
        academyImageUrl: '',
      ),
      WishlistItem(
        academyId: '2',
        academyName: '파고다어학원',
        academyAddress: '서울 서초구 서초 4동',
        subjects: ['영어'],
        totalPrice: 380000,
        academyImageUrl: '',
      ),
      WishlistItem(
        academyId: '3',
        academyName: '우성학원',
        academyAddress: '서울 서초구 서초 3동',
        subjects: ['수학', '국어', '영어'],
        totalPrice: 900000,
        academyImageUrl: '',
      ),
      WishlistItem(
        academyId: '4',
        academyName: '필학원',
        academyAddress: '서울 서초구 서초 1동',
        subjects: ['국어'],
        totalPrice: 980000,
        academyImageUrl: '',
      ),
    ];
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원', 'ko_KR');
    return formatter.format(amount);
  }

  int _getTotalAmount() {
    return _wishlistItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void _removeWishlistItem(int index) {
    setState(() {
      _wishlistItems.removeAt(index);
    });
  }

  void _navigateToAcademyDetail(String academyId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcademyDetailPage(academyId: academyId),
      ),
    );

    if (result != null && result is List<WishlistItem>) {
      setState(() {
        for (var newItem in result) {
          if (!_wishlistItems.any((item) => item.academyId == newItem.academyId && item.subjects.toSet().difference(newItem.subjects.toSet()).isEmpty && newItem.subjects.toSet().difference(item.subjects.toSet()).isEmpty)) {
            _wishlistItems.add(newItem);
          }
        }
      });
    }
  }

  Widget _buildWishlistItem(WishlistItem item, int index) {
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
          // 학원 로고/이미지
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
          // 학원 정보
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToAcademyDetail(item.academyId),
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
                    item.academyAddress,
                    style: TextStyle(
                      fontSize: 12,
                      color: FindemyColor.gray05,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.subjects.join(', '),
                    style: TextStyle(
                      fontSize: 12,
                      color: FindemyColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 가격과 삭제 버튼
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
                _formatCurrency(item.totalPrice),
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoHeader(),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 24),
              child: Text(
                '${widget.userName}님의 마이페이지',
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
            if (_wishlistItems.isEmpty)
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
                    for (int i = 0; i < _wishlistItems.length; i++)
                      _buildWishlistItem(_wishlistItems[i], i),
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