import 'package:findemy_mobile/core/components/button/elevated_button.dart';
import 'package:findemy_mobile/models/academy_model.dart';
import 'package:findemy_mobile/models/subject_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:findemy_mobile/core/components/header/logo_header.dart';
import 'package:findemy_mobile/core/constants/color.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:findemy_mobile/presentation/academy_page/view/academy_detail_page.dart';

// Import API services and models
import 'package:findemy_mobile/services/api_services.dart'; // Make sure this path is correct
import 'package:findemy_mobile/models/all_academy_model.dart'; // Make sure this path is correct


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

  // Change _allAcademies to hold data fetched from API
  List<AcademyModel>? _allAcademies;
  List<AcademyModel>? _filteredAcademies;
  bool _isLoading = true;
  bool _hasError = false;

  String _searchQuery = '';

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
    _loadInitialData();
  }

  // Modified to fetch from API
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
        _applyFilters(); // Apply filters once data is loaded
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

    List<AcademyModel> tempAcademies = List.from(_allAcademies!);

    if (_searchQuery.isNotEmpty) {
      tempAcademies = tempAcademies.where((academy) =>
      (academy.academyName?.contains(_searchQuery) == true) ||
          (academy.address?.contains(_searchQuery) == true) ||
          (academy.subjects?.any((subject) => subject.displayName.contains(_searchQuery)) == true)
      ).toList();
    }

    if (_selectedCity != null && _selectedCity != '전체') {
      tempAcademies = tempAcademies.where((academy) =>
      academy.address?.contains(_selectedCity!) == true).toList();
    }
    if (_selectedDistrict != null && _selectedDistrict != '전체') {
      tempAcademies = tempAcademies.where((academy) =>
      academy.address?.contains(_selectedDistrict!) == true).toList();
    }

    // You commented these out previously, but if AcademyModel is updated with grades/frequency,
    // you would uncomment and adjust these to match the AcademyModel properties.
    // Assuming for now AcademyModel doesn't directly have 'grades' or 'frequency' fields as strings
    // final List<String> selectedGrades = _getFilterValues('나이');
    // if (selectedGrades.isNotEmpty) {
    //   tempAcademies = tempAcademies.where((academy) {
    //     if (academy.grades == null) return false;
    //     return selectedGrades.any((grade) => academy.grades!.contains(grade));
    //   }).toList();
    // }
    //
    // final List<String> selectedFrequencies = _getFilterValues('차수');
    // if (selectedFrequencies.isNotEmpty) {
    //   tempAcademies = tempAcademies.where((academy) {
    //     if (academy.frequency == null) return false;
    //     return selectedFrequencies.any((freq) => academy.frequency! == freq);
    //   }).toList();
    // }

    final List<String> selectedSubjects = _getFilterValues('과목');
    if (selectedSubjects.isNotEmpty) {
      tempAcademies = tempAcademies.where((academy) {
        if (academy.subjects == null) return false;
        return selectedSubjects.any((selectedSubjectName) =>
            academy.subjects!.any((subjectEnum) => subjectEnum.displayName == selectedSubjectName));
      }).toList();
    }

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
        onSubmitted: (query) {
          setState(() {
            _searchQuery = query;
            _applyFilters();
          });
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
                        _searchQuery = '';
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
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.7,
            child: Container(
              padding: const EdgeInsets.all(20),
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
                  Row(
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
                          });
                        },
                        child: Icon(Symbols.close, color: FindemyColor.gray05),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
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
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  Row(
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
                              _searchQuery = '';
                              _applyFilters();
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
                              _applyFilters();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
                  _selectedDistrict = null; // Reset district when city changes
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
              // Only enable if a city is selected
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
                  : [], // Empty list if no city selected
              onChanged: _selectedCity == null
                  ? null // Disable if no city selected
                  : (String? newValue) {
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
          // Value used for filtering should match AcademyModel property (if added)
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
          // Value used for filtering should match AcademyModel property (if added)
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
          // Value used for filtering should match SubjectEnum.displayName
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
          // No need to call _applyFilters here, it will be called by '적용 및 검색하기'
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
    if (_filteredAcademies == null || _filteredAcademies!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('검색 결과가 없습니다.'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredAcademies!.length,
      itemBuilder: (context, index) {
        final academy = _filteredAcademies![index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AcademyDetailPage(academyId: academy.academyId.toString()),
              ),
            );
          },
          child: Padding(
            key: ValueKey(academy.academyId), // Use ValueKey for better performance in lists
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: FindemyColor.gray02, // Placeholder background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: academy.academyImgUrl != null && academy.academyImgUrl!.isNotEmpty
                      ? Image.network(
                    academy.academyImgUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to asset image on error
                      return Center(
                        child: SvgPicture.asset('assets/image/character.svg', width: 30),
                      );
                    },
                  )
                      : Center(
                    // Fallback to asset image if no URL
                    child: SvgPicture.asset('assets/image/character.svg', width: 30),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        academy.academyName ?? '이름 없음', // Handle null name
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        academy.address ?? '주소 없음', // Handle null address
                        style: TextStyle(color: FindemyColor.gray04, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: academy.subjects?.map((subject) {
                          return Text(
                            '#${subject.displayName}', // Use displayName from SubjectEnumExtension
                            style: TextStyle(
                              color: FindemyColor.gray04,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: FindemyColor.gray04,
                            ),
                          );
                        }).toList() ?? [], // Handle null subjects list
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}