import 'package:findemy_mobile/core/constants/color.dart';
import 'package:findemy_mobile/presentation/main_page/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:findemy_mobile/core/components/button/elevated_button.dart';
import 'package:intl/intl.dart';

class AcademyDetail {
  final String id;
  final String name;
  final String address;
  final String description;
  final List<String> tags;
  final String phone;
  final String detailedAddress;
  final String headerImageUrl;

  AcademyDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.tags,
    required this.phone,
    required this.detailedAddress,
    required this.headerImageUrl,
  });
}

class Lesson {
  final String subject;
  final String grade;
  final String frequency;
  final int price;

  Lesson({
    required this.subject,
    required this.grade,
    required this.frequency,
    required this.price,
  });
}

class AcademyDetailPage extends StatefulWidget {
  final String academyId;

  const AcademyDetailPage({super.key, required this.academyId});

  @override
  State<AcademyDetailPage> createState() => _AcademyDetailPageState();
}

class _AcademyDetailPageState extends State<AcademyDetailPage> {
  late AcademyDetail _academyDetail;
  late List<Lesson> _lessons;
  List<bool> _checked = [];
  bool _isSearchBarVisible = false;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _academyDetail = AcademyDetail(
      id: '1',
      name: '메가스터디 교육',
      address: '서울 서초구 서초 1동',
      description:
      '서초구에서 OO초등학생 조기 중학교 입학율 7명, 작년 서울대 합격 20명, 고려대/연세대 합격 30명이라는 기록을 달성하며 학원과 같이 성장해 나가는 메가스터디 교육입니다.',
      tags: ['국어', '수학', '영어'],
      phone: '02-1234-1231',
      detailedAddress: '서울 서초구 효령로 321 덕원빌딩\n(서울 서초구 서초동 1603-54)',
      headerImageUrl: '',
    );

    _lessons = [
      Lesson(subject: '수학', grade: '고1', frequency: '주 3회', price: 550000),
      Lesson(subject: '수학', grade: '고1', frequency: '주 3회', price: 380000),
      Lesson(subject: '수학', grade: '고1', frequency: '주 3회', price: 380000),
      Lesson(subject: '수학', grade: '고1', frequency: '주 3회', price: 550000),
      Lesson(subject: '수학', grade: '고1', frequency: '주 3회', price: 380000),
    ];

    _checked = List<bool>.filled(_lessons.length, false);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: SearchBar(
        backgroundColor: const WidgetStatePropertyAll(FindemyColor.gray01),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStateProperty.all(
          ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        hintText: '수능특강',
        trailing: [Icon(Symbols.search, color: FindemyColor.gray05)],
        onTap: () {},
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###원', 'ko_KR');
    return formatter.format(amount);
  }

  Widget _buildTableCell(Widget child, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: child,
    );
  }

  Widget _buildHeaderImage() {
    if (_academyDetail.headerImageUrl.isEmpty) {
      return Image.asset(
        'assets/image/character.svg',
        fit: BoxFit.cover,
        width: double.infinity,
        height: 320,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Container(
              width: 150,
              height: 320,
              child: SvgPicture.asset('assets/image/character.svg', width: 150, height: 150,),
            ),
          );
        },
      );
    } else {
      return Image.network(
        _academyDetail.headerImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 320,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/image/character.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 320,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final academy = _academyDetail;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
                child: _buildHeaderImage(),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Symbols.arrow_back_ios, color: FindemyColor.black),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const MainPage()),
                                        (route) => false,
                                  );
                                },
                                child: Icon(Symbols.home, color: FindemyColor.black),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isSearchBarVisible = !_isSearchBarVisible;
                                  });
                                },
                                child: Icon(Symbols.search, color: FindemyColor.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_isSearchBarVisible) _buildSearchBar(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                border: Border(
                  top: BorderSide(color: FindemyColor.gray02, width: 2)
                )
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      academy.name,
                      style: TextStyle(
                        color: FindemyColor.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      academy.address,
                      style: TextStyle(
                        color: FindemyColor.gray05,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: FindemyColor.gray03),
                        borderRadius: BorderRadius.circular(8),
                        color: FindemyColor.white,
                      ),
                      child: Text(
                        academy.description,
                        style: TextStyle(
                          color: FindemyColor.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '학원정보',
                      style: TextStyle(
                        color: FindemyColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            '교육 과목',
                            style: TextStyle(
                              color: FindemyColor.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: academy.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: FindemyColor.white,
                                  border: Border.all(
                                    color: FindemyColor.green500,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    color: FindemyColor.green500,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            '상세 주소',
                            style: TextStyle(
                              color: FindemyColor.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            academy.detailedAddress,
                            style: TextStyle(
                              color: FindemyColor.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            '상담 전화번호',
                            style: TextStyle(
                              color: FindemyColor.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          academy.phone,
                          style: TextStyle(
                            color: FindemyColor.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      '수업정보',
                      style: TextStyle(
                        color: FindemyColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                             Radius.circular(5)
                            ),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: _buildTableCell(
                                    Center(
                                      child: Text(
                                        '체크',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: FindemyColor.black,
                                        ),
                                      ),
                                    ),
                                    isHeader: true,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  color: FindemyColor.white,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: _buildTableCell(
                                    Center(
                                      child: Text(
                                        '과목',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: FindemyColor.black,
                                        ),
                                      ),
                                    ),
                                    isHeader: true,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  color: FindemyColor.white,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: _buildTableCell(
                                    Center(
                                      child: Text(
                                        '학년',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: FindemyColor.black,
                                        ),
                                      ),
                                    ),
                                    isHeader: true,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  color: FindemyColor.white,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: _buildTableCell(
                                    Center(
                                      child: Text(
                                        '차수',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: FindemyColor.black,
                                        ),
                                      ),
                                    ),
                                    isHeader: true,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  color: FindemyColor.white,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: _buildTableCell(
                                    Center(
                                      child: Text(
                                        '금액',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: FindemyColor.black,
                                        ),
                                      ),
                                    ),
                                    isHeader: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        for (int i = 0; i < _lessons.length; i++)
                          Container(
                            decoration: BoxDecoration(
                              color: FindemyColor.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: FindemyColor.gray02,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: _buildTableCell(
                                      Center(
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: _checked[i]
                                                ? FindemyColor.green500
                                                : FindemyColor.white,
                                            border: Border.all(
                                              color: _checked[i]
                                                  ? FindemyColor.green500
                                                  : FindemyColor.gray03,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _checked[i] = !_checked[i];
                                                });
                                              },
                                              borderRadius: BorderRadius.circular(4),
                                              child: _checked[i]
                                                  ? Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: FindemyColor.white,
                                                  size: 12,
                                                ),
                                              )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _buildTableCell(
                                      Center(
                                        child: Text(
                                          _lessons[i].subject,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: FindemyColor.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _buildTableCell(
                                      Center(
                                        child: Text(
                                          _lessons[i].grade,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: FindemyColor.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _buildTableCell(
                                      Center(
                                        child: Text(
                                          _lessons[i].frequency,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: FindemyColor.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _buildTableCell(
                                      Center(
                                        child: Text(
                                          _formatCurrency(_lessons[i].price),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: FindemyColor.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: CustomElevatedButton(
            text: '찜 하기',
            onPressed: () {
              final selectedLessons = _lessons
                  .asMap()
                  .entries
                  .where((entry) => _checked[entry.key])
                  .map((e) => e.value)
                  .toList();

              if (selectedLessons.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('하나 이상의 수업을 선택해주세요.')),
                );
                return;
              }

              Navigator.pushNamed(
                  context, '/wishlist', arguments: selectedLessons);
            },
          ),
        ),
      ),
    );
  }
}