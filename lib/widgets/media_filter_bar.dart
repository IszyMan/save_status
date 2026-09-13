import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MediaFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  final int imagesCount;
  final int videosCount;

  const MediaFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
    required this.imagesCount,
    required this.videosCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          _MediaFilterChip(
            label: 'Images',
            count: imagesCount,
            value: 'images',
            selected: selectedFilter == 'images',
            onSelected: onChanged,
          ),

          const SizedBox(
            width: 8,
          ),

          _MediaFilterChip(
            label: 'Videos',
            count: videosCount,
            value: 'videos',
            selected: selectedFilter == 'videos',
            onSelected: onChanged,
          ),
        ],
      ),
    );
  }
}

class _MediaFilterChip extends StatelessWidget {
  final String label;
  final int count;
  final String value;
  final bool selected;
  final ValueChanged<String> onSelected;

  const _MediaFilterChip({
    required this.label,
    required this.count,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),

          const SizedBox(
            width: 6,
          ),

          Container(
            constraints: const BoxConstraints(
              minWidth: 20,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white.withValues(alpha: 0.20)
                  : AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : AppColors.primaryDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      selected: selected,
      onSelected: (_) {
        onSelected(value);
      },
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: selected
            ? Colors.white
            : AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(
        color: selected
            ? AppColors.primary
            : AppColors.divider,
      ),
      showCheckmark: false,
    );
  }
}