import 'package:findemy_mobile/core/constants/color.dart';
import 'package:findemy_mobile/models/bookmark_model.dart';
import 'package:findemy_mobile/presentation/main_page/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:findemy_mobile/core/components/button/elevated_button.dart';
import 'package:intl/intl.dart';
import 'package:findemy_mobile/services/api_services.dart';
import 'package:findemy_mobile/models/academy_detail_model.dart';
import 'package:findemy_mobile/models/lesson_model.dart';
import 'package:findemy_mobile/models/subject_enum.dart';
import 'package:findemy_mobile/models/wishlist_item.dart'; // WishlistItem 모델 import

class AcademyDetailPage extends StatefulWidget {
  final String academyId;

  const AcademyDetailPage({super.key, required this.academyId});

  @override
  State<AcademyDetailPage> createState() => _AcademyDetailPageState();
}

class _AcademyDetailPageState extends State<AcademyDetailPage> {
  AcademyDetailModel? _academyDetail;
  List<LessonModel>? _lessons;
  List<bool> _checked = [];
  bool _isSearchBarVisible = false;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchAcademyDetail();
  }

  void _fetchAcademyDetail() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final fetchedDetail = await ApiServices.detailAcademies(int.parse(widget.academyId));
      if (mounted) {
        setState(() {
          _academyDetail = fetchedDetail;
          _lessons = fetchedDetail.lessons;
          _checked = List<bool>.filled(_lessons?.length ?? 0, false);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
          print('오류: $e');
        });
      }
    }
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
        onTap: () {
          // 메인 검색 페이지로 이동하는 로직을 추가
        },
        onSubmitted: (query) {
          // 검색 결과 페이지로 이동
        },
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
    if (_academyDetail?.academyImgUrl != null && _academyDetail!.academyImgUrl!.isNotEmpty) {
      return Image.network(
        _academyDetail!.academyImgUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 320,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: SvgPicture.asset(
              'assets/image/character.svg',
              width: double.infinity,
              height: 320,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    } else {
      return Center(
        child: SvgPicture.asset(
          'assets/image/character.svg',
          width: double.infinity,
          height: 320,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError || _academyDetail == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('학원 정보를 불러오는데 실패했습니다.', style: TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _fetchAcademyDetail,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    final academy = _academyDetail!;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
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
                  borderRadius: const BorderRadius.only(
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
                      academy.academyName ?? '학원 이름 없음',
                      style: TextStyle(
                        color: FindemyColor.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      academy.address ?? '주소 정보 없음',
                      style: TextStyle(
                        color: FindemyColor.gray05,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: FindemyColor.gray03),
                        borderRadius: BorderRadius.circular(8),
                        color: FindemyColor.white,
                      ),
                      child: Text(
                        academy.introduction ?? '학원 소개 없음',
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
                            children: academy.subjects?.map((subjectEnum) {
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
                                  subjectEnum.displayName,
                                  style: TextStyle(
                                    color: FindemyColor.green500,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList() ?? [],
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
                            academy.address ?? '상세 주소 정보 없음',
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
                          academy.telNumber ?? '전화번호 정보 없음',
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
                    if (_lessons != null && _lessons!.isNotEmpty)
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          for (int i = 0; i < _lessons!.length; i++)
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
                                            _lessons![i].subject?.displayName ?? 'N/A',
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
                                            _lessons![i].grade?.displayName ?? 'N/A',
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
                                            _lessons![i].number?.displayName ?? 'N/A',
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
                                            _formatCurrency(_lessons![i].amount ?? 0),
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
                      )
                    else // 수업 정보가 없을 경우
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('수업 정보가 없습니다.'),
                        ),
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
            // academy_detail_page.dart의 '찜 하기' 버튼 onPressed 부분만 수정
            onPressed: () async {
              if (_lessons == null || _lessons!.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('선택할 수업이 없습니다.')),
                );
                return;
              }

              final selectedLessons = _lessons!
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

              // 선택된 수업들의 총 금액 계산 (현재 로직에서는 사용되지 않지만, 유지)
              final totalPrice = selectedLessons.fold<int>(0, (sum, lesson) => sum + (lesson.amount ?? 0));

              try {
                // 1. 먼저 현재 북마크 상태를 가져옴
                final currentBookmarks = await ApiServices.mypageData();
                List<int> currentBookmarkIds = currentBookmarks.favorites.map((f) => f.academyId).toList();

                // 2. 새로운 학원 ID 추가
                final newAcademyId = academy.academyId!;
                if (!currentBookmarkIds.contains(newAcademyId)) {
                  currentBookmarkIds.add(newAcademyId);
                }

                // 3. 업데이트된 북마크 리스트로 API 호출
                final updatedBookmarkData = BookMarkModel(academyId: currentBookmarkIds); // Corrected spelling and parameter name

                // ✨ 요청 본문 로그 추가
                print('--- [찜하기 버튼 클릭 - POST /favorite 요청] ---');
                print('보내는 북마크 ID 리스트: ${updatedBookmarkData.academyId}'); // Corrected to .academyId
                print('-------------------------------------------');

                await ApiServices.postBookmarks(updatedBookmarkData, academy.academyId!);

                print('찜하기 성공: 학원 ID ${academy.academyId}');

                // 4. 성공 메시지 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('찜 목록에 추가되었습니다.')),
                );

                // 5. 이전 화면으로 돌아가기
                Navigator.pop(context);

              } catch (e) {
                print('찜하기 실패: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('찜하기 실패: ${e.toString()}')),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}