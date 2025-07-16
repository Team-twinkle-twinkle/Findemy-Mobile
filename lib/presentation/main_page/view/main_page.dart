import 'dart:async';
import 'package:findemy_mobile/core/components/header/logo_header.dart';
import 'package:findemy_mobile/core/constants/color.dart';
import 'package:findemy_mobile/models/academy_model.dart';
import 'package:findemy_mobile/models/all_academy_model.dart';
import 'package:findemy_mobile/models/subject_enum.dart';
import 'package:findemy_mobile/presentation/academy_page/view/academy_detail_page.dart';
import 'package:findemy_mobile/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _bannerPageController;
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;

  final List<String> _bannerImages = [
    'assets/image/banner1.svg',
    'assets/image/banner2.svg'
  ];

  String _selectedCategory = "전체";
  final List<String> _categories = [
    "전체",
    ...SubjectEnum.values.map((e) => e.displayName)
  ];

  List<AcademyModel> _allAcademies = [];
  List<AcademyModel> _filteredAcademies = [];

  bool _isLoadingAcademies = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController(viewportFraction: 0.9);
    _loadInitialData();
    _startBannerAutoSlide();
  }

  Future<void> _loadInitialData() async {
    await _fetchAllAcademies();
    _applyCategoryFilter();
  }

  Future<void> _fetchAllAcademies() async {
    if (!mounted) return;

    setState(() {
      _isLoadingAcademies = true;
      _errorMessage = null;
    });

    try {
      final AllAcademyModel response = await ApiServices.allAcademies();
      if (mounted) {
        setState(() {
          _allAcademies = response.academies ?? [];
          _isLoadingAcademies = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingAcademies = false;
          _errorMessage = '학원 정보를 불러오는데 실패했습니다: $e';
        });
      }
    }
  }

  void _applyCategoryFilter() {
    if (_selectedCategory == "전체") {
      _filteredAcademies = List.from(_allAcademies);
    } else {
      _filteredAcademies = _allAcademies.where((academy) {
        return academy.subjects?.any((subjectEnum) =>
        subjectEnum.displayName == _selectedCategory) ==
            true;
      }).toList();
    }
    setState(() {});
  }

  void _startBannerAutoSlide() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_currentBannerIndex < _bannerImages.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }

      if (_bannerPageController.hasClients) {
        _bannerPageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _onCategoryChanged(String category) async {
    if (_selectedCategory == category) return;

    setState(() {
      _selectedCategory = category;
    });

    _applyCategoryFilter();
  }

  Future<void> _onRefresh() async {
    await _loadInitialData();
  }

  @override
  void dispose() {
    _bannerPageController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const LogoHeader(),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildBannerSection(),
                const SizedBox(height: 20),
                Divider(color: FindemyColor.gray02),
                const SizedBox(height: 6),
                _buildSectionTitle(),
                _buildCategoryFilter(),
                const SizedBox(height: 20),
                _buildAcademyList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: SearchBar(
        backgroundColor: WidgetStatePropertyAll(FindemyColor.gray01),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStateProperty.all(
          ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        hintText: '수능특강',
        trailing: [Icon(Symbols.search, color: FindemyColor.gray05)],
        onTap: () {
          // 검색 바 탭 시 로직 추가 (예: 검색 페이지로 이동)
        },
        onSubmitted: (query) {
          // 검색 기능 추가 시 여기에 로직 구현
          // 현재는 카테고리 필터링만 있으므로 검색어 필터링 로직은 추가되지 않음
          // 만약 검색 기능을 클라이언트에서 구현하려면 _allAcademies를 기반으로 추가 필터링 필요
          print('검색어 제출: $query');
        },
      ),
    );
  }

  Widget _buildBannerSection() {
    return SizedBox(
      height: 192,
      child: PageView.builder(
        itemCount: _bannerImages.length,
        controller: _bannerPageController,
        onPageChanged: (index) {
          setState(() {
            _currentBannerIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final bannerImage = _bannerImages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SvgPicture.asset(
                bannerImage,
                width: double.infinity,
                height: 192,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle() {
    return const Padding(
      padding: EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '나와 우리 아이를 위한 학원',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: isSelected
                    ? ElevatedButton(
                  onPressed: () => _onCategoryChanged(category),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FindemyColor.green500,
                    foregroundColor: FindemyColor.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                )
                    : OutlinedButton(
                  onPressed: () => _onCategoryChanged(category),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: FindemyColor.white,
                    foregroundColor: FindemyColor.black,
                    side: BorderSide(color: FindemyColor.gray03),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              if (index == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    height: 26,
                    width: 1,
                    color: FindemyColor.gray02,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAcademyList() {
    if (_isLoadingAcademies) {
      return const Padding(
        padding: EdgeInsets.all(50),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: FindemyColor.gray04),
            const SizedBox(height: 16),
            Text(_errorMessage!,
                style: TextStyle(color: FindemyColor.gray04, fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _onRefresh, child: const Text('다시 시도')),
          ],
        ),
      );
    }

    if (_filteredAcademies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Icon(Icons.school_outlined, size: 48, color: FindemyColor.gray04),
            const SizedBox(height: 16),
            Text(
              '선택하신 카테고리에 해당하는 학원이 없습니다.',
              style: TextStyle(color: FindemyColor.gray04, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      itemCount: _filteredAcademies.length,
      separatorBuilder: (context, index) => Divider(
        color: FindemyColor.gray02,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final academy = _filteredAcademies[index];
        return _AcademyCard(
          academy: academy,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AcademyDetailPage(academyId: academy.academyId.toString()),
              ),
            );
          },
        );
      },
    );
  }
}

class _AcademyCard extends StatelessWidget {
  final AcademyModel academy;
  final VoidCallback? onTap;

  const _AcademyCard({
    required this.academy,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: FindemyColor.gray02,
              ),
              child: (academy.academyImgUrl != null && academy.academyImgUrl!.isNotEmpty)
                  ? Image.network(
                academy.academyImgUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: SvgPicture.asset('assets/image/character.svg', width: 40, height: 40),
                  );
                },
              )
                  : Center(
                child: SvgPicture.asset('assets/image/character.svg', width: 40, height: 40),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(academy.academyName ?? '이름 없음',
                      style:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(academy.address ?? '주소 없음',
                      style: TextStyle(color: FindemyColor.gray04, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: academy.subjects?.map((subjectEnum) {
                      return Text(
                        '#${subjectEnum.displayName}',
                        style: TextStyle(
                          color: FindemyColor.gray04,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: FindemyColor.gray04,
                        ),
                      );
                    }).toList() ?? [],
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