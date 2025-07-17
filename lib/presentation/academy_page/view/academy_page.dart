import 'package:findemy_mobile/core/components/button/elevated_button.dart';
import 'package:findemy_mobile/core/components/header/logo_header.dart';
import 'package:findemy_mobile/core/constants/color.dart';
import 'package:findemy_mobile/models/academy_model.dart';
import 'package:findemy_mobile/models/all_academy_model.dart';
import 'package:findemy_mobile/models/academy_sesarch_model.dart'; // Add this import for AcademySearchModel
import 'package:findemy_mobile/models/subject_enum.dart';
import 'package:findemy_mobile/presentation/academy_page/view/academy_detail_page.dart';
import 'package:findemy_mobile/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcademyPage extends StatefulWidget {
  const AcademyPage({super.key});

  @override
  State<AcademyPage> createState() => _AcademyPageState();
}

class _AcademyPageState extends State<AcademyPage> {
  bool _isFilterVisible = false;
  String _selectedFilterType = '전체';
  String? _selectedCity;
  String? _selectedDistrict;

  List<Academy>? _allAcademies;
  List<Academy>? _filteredAcademies;
  bool _isLoading = true;
  bool _hasError = false;

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController(); // Added TextEditingController

  final List<String> _grades = [
    '전체', '초등생 1학년', '초등생 2학년', '초등생 3학년', '초등생 4학년', '초등생 5학년', '초등생 6학년',
    '중등생 1학년', '중등생 2학년', '중등생 3학년', '고등생 1학년', '고등생 2학년', '고등생 3학년'
  ];
  final List<String> _frequencies = [
    '전체', '주 1회', '주 2회', '주 3회', '주 4회', '주 5회', '주 6회'
  ];
  final List<String> _subjects = [
    '전체', '국어', '수학', '영어', '사회', '과학'
  ];

  final List<String> _cities = [
    '서울특별시', '부산광역시', '인천광역시', '대구광역시', '대전광역시', '광주광역시', '울산광역시', '세종특별자치시', '경기도', '충청북도', '충청남도', '전라남도', '경상북도', '경상남도', '강원특별자치도', '전북특별자치도', '제주특별자치도'
  ];
  final Map<String, List<String>> _districts = {
    '서울특별시': ['종로', '중구', '용산구', '성동구', '광진구', '동대문구', '중랑구', '성북구', '강북구', '도봉구', '노원구', '은평구', '서대문구', '마포구', '양천구', '강서구', '구로구', '금천구', '영등포구', '동작구', '관악구', '서초구', '강남구', '송파구', '강동구'],
    '부산광역시': ['중구', '서구', '동구', '영도구', '부산진구', '동래구', '남구', '북구', '해운대구', '사하구', '금정구', '강서구', '연제구', '수영구', '사상구', '기장군'],
    '인천광역시': ['중구', '동구', '미추홀구', '연수구', '남동구', '부평구', '계양구', '서구', '강화군', '옹진군'],
    '대구광역시': ['중구', '동구', '서구', '남구', '북구', '수성구', '달서구', '군위군'],
    '대전광역시': ['동구', '중구', '서구', '유성구', '대덕구'],
    '광주광역시': ['동구', '서구', '남구', '북구', '광산구'],
    '울산광역시': ['중구', '남구', '동구', '북구', '울주군'],
    '세종특별자치시': [],
    '경기도': ['수원시', '용인시', '고양시', '화성시', '성남시', '부천시', '남양주시', '안산시', '평택시', '시흥시', '파주시', '김포시', '의정부시', '광주시', '하남시', '양주시', '광명시', '군포시', '오산시', '이천시', '안성시', '구리시', '포천시', '의왕시', '양평군', '여주시', '동두천시', '과천시', '가평군', '연천군'],
    '충청북도': ['청주시', '충주시', '제천시', '보은군', '옥천군', '영동군', '증평군', '진천군', '괴산군', '음성군', '단양군'],
    '충청남도': ['천안시', '공주시', '보령시', '아산시', '서산시', '논산시', '계룡시', '당진시', '금산군', '부여군', '서천군', '청양군', '홍성군', '예산군', '태안군'],
    '전라남도': ['목포시', '여수시', '순천시', '나주시', '광양시', '담양군', '곡성군', '구례군', '고흥군', '보성군', '화순군', '장흥군', '강진군', '해남군', '영암군', '무안군', '함평군', '영광군', '장성군', '완도군', '진도군', '신안군'],
    '경상북도': ['포항시', '경주시', '김천시', '안동시', '구미시', '영주시', '영천시', '상주시', '문경시', '경산시', '의성군', '청송군', '영양군', '청도군', '고령군', '성주군', '칠곡군', '예천군', '봉화군', '울진군', '울릉군'],
    '경상남도': ['창원시', '진주시', '통영시', '사천시', '김해시', '밀양시', '거제시', '양산시', '의령군', '함안군', '창녕군', '고성군', '남해군', '하동군', '산청군', '함양군', '거창군', '합천군'],
    '강원특별자치도': ['춘천시', '원주시', '강릉시', '동해시', '태백시', '속초시', '삼척시', '홍천군', '횡성군', '영월군', '평창군', '정선군', '철원군', '화천군', '양구군', '인제군', '고성군', '양양군'],
    '전북특별자치도': ['전주시', '군산시', '익산시', '정읍시', '남원시', '김제시', '완주군', '진안군', '무주군', '장수군', '임실군', '순창군', '고창군', '부안군'],
    '제주특별자치도': ['제주시', '서귀포시'],
  };

  final Map<String, Set<String>> _selectedChips = {
    '나이': {'나이_전체'},
    '차수': {'차수_전체'},
    '과목': {'과목_전체'},
  };

  @override
  void initState() {
    super.initState();
    _initializeAuthAndLoadData();
  }

  // Dispose the TextEditingController when the widget is removed from the tree
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeAuthAndLoadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      print('저장된 토큰: $accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        print('토큰이 없습니다. 로그인이 필요합니다.');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
        return;
      }

      ApiServices.setAuthorizationToken(accessToken);

      await Future.delayed(const Duration(milliseconds: 100));

      _loadInitialData();
    } catch (e) {
      print('토큰 초기화 중 오류: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  void _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final AllAcademyModel response = await ApiServices.allAcademies();
      if (mounted) {
        setState(() {
          _allAcademies = response.academies;
          _isLoading = false;
        });
        _applyFilters();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          print('오류: $e');
        });
      }
    }
  }

  void _applyFilters() {
    if (_allAcademies == null) {
      _filteredAcademies = [];
      return;
    }

    List<Academy> tempAcademies = List.from(_allAcademies!);

    // Removed client-side search filtering here, as it will be handled by API call
    // if (_searchQuery.isNotEmpty) {
    //   tempAcademies = tempAcademies.where((academy) =>
    //   (academy.academyName.contains(_searchQuery)) ||
    //       (academy.address?.contains(_searchQuery) == true) ||
    //       (academy.subjects.any((subject) => subject.contains(_searchQuery)))
    //   ).toList();
    // }

    if (_selectedCity != null && _selectedCity != '전체') {
      tempAcademies = tempAcademies.where((academy) =>
      academy.address?.contains(_selectedCity!) == true).toList();
    }
    if (_selectedDistrict != null && _selectedDistrict != '전체') {
      tempAcademies = tempAcademies.where((academy) =>
      academy.address?.contains(_selectedDistrict!) == true).toList();
    }

    final List<String> selectedSubjects = _getFilterValues('과목');
    if (selectedSubjects.isNotEmpty) {
      tempAcademies = tempAcademies.where((academy) {
        return selectedSubjects.any((selectedSubjectName) =>
            academy.subjects.any((subject) => subject == selectedSubjectName));
      }).toList();
    }

    // Add filtering for grades and frequencies if your Academy model supports them
    // For example:
    // final List<String> selectedGrades = _getFilterValues('나이');
    // if (selectedGrades.isNotEmpty && !selectedGrades.contains('전체')) {
    //   tempAcademies = tempAcademies.where((academy) =>
    //       selectedGrades.any((grade) => academy.grades.contains(grade)) // Assuming academy.grades exists
    //   ).toList();
    // }

    setState(() {
      _filteredAcademies = tempAcademies;
    });
  }

  List<String> _getFilterValues(String category) {
    final Set<String> chips = _selectedChips[category] ?? {};
    if (chips.contains('${category}_전체')) {
      return [];
    }
    return chips.map((chip) => chip.substring(chip.indexOf('_') + 1)).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (_isFilterVisible) {
                  setState(() {
                    _isFilterVisible = false;
                  });
                }
              },
              child: AbsorbPointer(
                absorbing: _isFilterVisible,
                child: SingleChildScrollView(
                  physics: _isFilterVisible ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const LogoHeader(),
                      const SizedBox(height: 16),
                      _buildSearchBar(),
                      const SizedBox(height: 16),
                      Divider(color: FindemyColor.gray02),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '필요한 학원을 효율적이게',
                              style: TextStyle(
                                color: FindemyColor.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildFilterButtons(),
                      const SizedBox(height: 18),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _hasError
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('데이터를 불러오는데 실패했습니다.', style: TextStyle(color: Colors.red),),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => _loadInitialData(),
                              child: const Text('재시도'),
                            ),
                          ],
                        ),
                      )
                          : (_filteredAcademies == null || _filteredAcademies!.isEmpty)
                          ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('검색 결과가 없습니다.'),
                        ),
                      )
                          : _buildAcademyList(),
                    ],
                  ),
                ),
              ),
            ),
            if (_isFilterVisible) _buildFilterOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: SearchBar(
        controller: _searchController, // Assign the controller
        backgroundColor: WidgetStatePropertyAll(FindemyColor.gray01),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStateProperty.all(
          ContinuousRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        hintText: '수능특강',
        trailing: [Icon(Symbols.search, color: FindemyColor.gray05)],
        onTap: () {
          // Optional: You might want to show the filter overlay here
          // setState(() {
          //   _isFilterVisible = true;
          //   _selectedFilterType = '전체'; // Or a relevant filter type for search
          // });
        },
        onSubmitted: (query) async { // Made async to await API call
          setState(() {
            _searchQuery = query; // Update the search query state
            _isLoading = true; // Show loading indicator
            _hasError = false; // Clear previous errors
            _selectedFilterType = '전체'; // Reset filter type when searching
            _selectedCity = null; // Clear city selection
            _selectedDistrict = null; // Clear district selection
            _selectedChips.forEach((key, value) { // Clear chip selections
              value.clear();
              value.add('${key}_전체');
            });
          });

          try {
            // Call the API service for search
            final List<AcademySearchModel> searchResults = await ApiServices.searchAcademies(query);
            if (mounted) {
              setState(() {
                // Map AcademySearchModel to Academy objects
                _filteredAcademies = searchResults.map((e) => e.academy).toList();
                _isLoading = false; // Hide loading indicator
              });
            }
          } catch (e) {
            if (mounted) {
              setState(() {
                _isLoading = false; // Hide loading indicator
                _hasError = true; // Set error state
                _filteredAcademies = []; // Clear results on error
                print('학원 검색 중 오류 발생: $e');
              });
            }
          }
        },
      ),
    );
  }

  Widget _buildFilterButtons() {
    final List<String> mainFilterCategories = [
      "전체", "학년", "차수", "과목", "시/군/구"
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: mainFilterCategories.length,
        itemBuilder: (context, index) {
          final category = mainFilterCategories[index];
          final isSelected = _selectedFilterType == category;

          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: isSelected
                    ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilterType = category;
                      _isFilterVisible = (category != '전체');
                      if (category == '전체') {
                        _selectedCity = null;
                        _selectedDistrict = null;
                        _selectedChips.forEach((key, value) {
                          value.clear();
                          value.add('${key}_전체');
                        });
                        _searchQuery = '';
                        _searchController.clear();
                        _applyFilters();
                      }
                    });
                  },
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
                  onPressed: () {
                    setState(() {
                      _selectedFilterType = category;
                      _isFilterVisible = (category != '전체');
                      if (category == '전체') {
                        _selectedCity = null;
                        _selectedDistrict = null;
                        _selectedChips.forEach((key, value) {
                          value.clear();
                          value.add('${key}_전체');
                        });
                        _searchQuery = ''; // Clear search query when selecting "전체" filter
                        _searchController.clear(); // Clear search bar text
                        _applyFilters();
                      }
                    });
                  },
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
              if (category == "전체")
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

  Widget _buildFilterOverlay() {
    return Positioned.fill(
      top: 0, // 상태바 영역까지 포함하여 전체 화면 덮기
      child: Container(
        color: Colors.black.withValues(alpha: 0.5), // 전체 화면 반투명 배경
        child: Column(
          children: [
            // 상단 빈 공간 (터치 시 오버레이 닫기)
            Expanded(
              flex: 3, // 30% 공간
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFilterVisible = false;
                    _selectedFilterType = '전체';
                  });
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // 하단 필터 모달
            Expanded(
              flex: 7, // 70% 공간
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: FindemyColor.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 헤더 부분
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '필터',
                            style: TextStyle(
                              color: FindemyColor.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFilterVisible = false;
                                _selectedFilterType = '전체';
                              });
                            },
                            child: Icon(Symbols.close, color: FindemyColor.gray05),
                          ),
                        ],
                      ),
                    ),
                    // 스크롤 가능한 필터 내용
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCityDistrictFilter(),
                            const SizedBox(height: 24),
                            Divider(color: FindemyColor.gray02),
                            const SizedBox(height: 24),
                            _buildGradeFilter(),
                            const SizedBox(height: 24),
                            Divider(color: FindemyColor.gray02),
                            const SizedBox(height: 24),
                            _buildFrequencyFilter(),
                            const SizedBox(height: 24),
                            Divider(color: FindemyColor.gray02),
                            const SizedBox(height: 24),
                            _buildSubjectFilter(),
                            const SizedBox(height: 100), // 하단 버튼 공간 확보
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: FindemyColor.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCity = null;
                                  _selectedDistrict = null;
                                  _selectedChips.forEach((key, value) {
                                    value.clear();
                                    value.add('${key}_전체');
                                  });
                                  _searchQuery = ''; // 검색어 초기화
                                  _searchController.clear(); // Clear search bar text
                                  _applyFilters(); // 필터 초기화 후 다시 필터 적용
                                });
                              },
                              child: Text(
                                '맞춤 필터링 검색 초기화',
                                style: TextStyle(
                                  color: FindemyColor.gray05,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationColor: FindemyColor.gray05,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomElevatedButton(
                              text: '적용 및 검색하기',
                              onPressed: () {
                                setState(() {
                                  _isFilterVisible = false;
                                  _searchQuery = _searchController.text; // Ensure _searchQuery is updated from the bar
                                  _applyFilters(); // 필터 적용
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityDistrictFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '시/도',
          style: TextStyle(
            color: FindemyColor.gray05,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: FindemyColor.gray03),
            borderRadius: BorderRadius.circular(4),
            color: FindemyColor.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedCity,
              hint: const Text('-', style: TextStyle(color: FindemyColor.gray05)),
              icon: Icon(Symbols.arrow_drop_down, color: FindemyColor.gray05),
              dropdownColor: FindemyColor.white,
              items: _cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(
                    city,
                    style: TextStyle(color: FindemyColor.black),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue;
                  _selectedDistrict = null;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '시/군/구',
          style: TextStyle(
            color: FindemyColor.gray05,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: FindemyColor.gray03),
            borderRadius: BorderRadius.circular(4),
            color: FindemyColor.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedDistrict,
              hint: const Text('-', style: TextStyle(color: FindemyColor.gray05)),
              icon: Icon(Symbols.arrow_drop_down, color: FindemyColor.gray05),
              dropdownColor: FindemyColor.white,
              items: _selectedCity != null && _districts[_selectedCity] != null
                  ? _districts[_selectedCity]!.map((String district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(
                    district,
                    style: TextStyle(color: FindemyColor.black),
                  ),
                );
              }).toList()
                  : [],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDistrict = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '학년',
          style: TextStyle(
            color: FindemyColor.gray05,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _grades.map((grade) => _buildFilterChip(grade, '나이', grade)).toList(),
        ),
      ],
    );
  }

  Widget _buildFrequencyFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '차수',
          style: TextStyle(
            color: FindemyColor.gray05,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _frequencies.map((freq) => _buildFilterChip(freq, '차수', freq)).toList(),
        ),
      ],
    );
  }

  Widget _buildSubjectFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '과목',
          style: TextStyle(
            color: FindemyColor.gray05,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _subjects.map((subject) => _buildFilterChip(subject, '과목', subject)).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String category, String value) {
    bool isSelected = _selectedChips[category]?.contains('${category}_$value') ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          final Set<String> currentCategoryChips = _selectedChips[category]!;

          if (label == '전체') {
            currentCategoryChips.clear();
            currentCategoryChips.add('${category}_전체');
          } else {
            if (currentCategoryChips.contains('${category}_전체')) {
              currentCategoryChips.remove('${category}_전체');
            }
            if (isSelected) {
              currentCategoryChips.remove('${category}_$value');
            } else {
              currentCategoryChips.add('${category}_$value');
            }

            if (currentCategoryChips.isEmpty) {
              currentCategoryChips.add('${category}_전체');
            }
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: FindemyColor.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? FindemyColor.green500 : FindemyColor.gray04,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? FindemyColor.green500 : FindemyColor.gray04,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAcademyList() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(50),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: FindemyColor.gray04),
            const SizedBox(height: 16),
            Text('학원 정보를 불러오는데 실패했습니다.',
                style: TextStyle(color: FindemyColor.gray04, fontSize: 14),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadInitialData, child: const Text('다시 시도')),
          ],
        ),
      );
    }

    if (_filteredAcademies == null || _filteredAcademies!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Icon(Icons.school_outlined, size: 48, color: FindemyColor.gray04),
            const SizedBox(height: 16),
            Text(
              '검색 결과가 없습니다.',
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
      itemCount: _filteredAcademies!.length,
      separatorBuilder: (context, index) => Divider(
        color: FindemyColor.gray02,
        height: 1,
      ),
      itemBuilder: (context, index) {
        final academy = _filteredAcademies![index];
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
  final Academy academy;
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
                  Text(academy.academyName,
                      style:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(academy.address ?? '주소 없음',
                      style: TextStyle(color: FindemyColor.gray04, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: academy.subjects.map((subject) {
                      final String koreanSubject = SubjectEnumExtension.toKorean(subject);
                      return Text(
                        '#$koreanSubject',
                        style: TextStyle(
                          color: FindemyColor.gray04,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: FindemyColor.gray04,
                        ),
                      );
                    }).toList(),
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