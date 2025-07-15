import 'package:findemy_mobile/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _labels = ['홈', '학원', '마이페이지'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FindemyColor.white,
        border: Border(
          top: BorderSide(color: FindemyColor.gray02, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (index) {
              final isSelected = currentIndex == index;
              final iconColor = isSelected ? FindemyColor.green500 : FindemyColor.gray05;

              Widget icon;

              if (index == 1) {
                final svgPath = isSelected
                    ? 'assets/icon/navi_icon_selected.svg'
                    : 'assets/icon/navi_icon.svg';

                icon = SvgPicture.asset(
                  svgPath,
                  width: 28,
                  height: 28,
                );
              } else {
                final materialIcon = index == 0 ? Symbols.home : Symbols.person;
                icon = Icon(
                  materialIcon,
                  color: iconColor,
                  size: 28,
                  fill: 1,
                );
              }

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon,
                      Text(
                        _labels[index],
                        style: TextStyle(
                          fontSize: 12,
                          color: iconColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}