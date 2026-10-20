import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';

class MediaFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  final int imagesCount;
  final int videosCount;

  final bool showFolders;
  final int foldersCount;

  const MediaFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
    required this.imagesCount,
    required this.videosCount,
    this.showFolders = false,
    this.foldersCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final chips = <Widget>[
      _MediaFilterChip(
        icon: Icons.photo_rounded,
        label: l10n.images,
        count: imagesCount,
        value: 'images',
        selected: selectedFilter == 'images',
        onSelected: onChanged,
        compact: showFolders,
      ),
      _MediaFilterChip(
        icon: Icons.videocam_rounded,
        label: l10n.videos,
        count: videosCount,
        value: 'videos',
        selected: selectedFilter == 'videos',
        onSelected: onChanged,
        compact: showFolders,
      ),
      if (showFolders)
        _MediaFilterChip(
          icon: Icons.folder_rounded,
          label: l10n.folderTab,
          count: foldersCount,
          value: 'folders',
          selected: selectedFilter == 'folders',
          onSelected: onChanged,
          compact: true,
        ),
    ];

    // Saved: three equal-width tabs, without horizontal scrolling.
    if (showFolders) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          children: [
            for (var index = 0; index < chips.length; index++) ...[
              if (index > 0)
                const SizedBox(width: 6),
              Expanded(
                child: chips[index],
              ),
            ],
          ],
        ),
      );
    }

    // Statuses: preserve the existing two-chip layout.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        children: [
          chips[0],
          const SizedBox(width: 8),
          chips[1],
        ],
      ),
    );
  }
}

class _MediaFilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final String value;
  final bool selected;
  final ValueChanged<String> onSelected;
  final bool compact;

  const _MediaFilterChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.value,
    required this.selected,
    required this.onSelected,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final contentColor = selected
        ? Colors.white
        : AppColors.primaryDark;

    final labelContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: compact ? 18 : 20,
          color: contentColor,
        ),
        SizedBox(width: compact ? 4 : 6),
        Text(label),
        SizedBox(width: compact ? 4 : 6),
        Container(
          constraints: const BoxConstraints(
            minWidth: 20,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 4 : 6,
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
              color: contentColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );

    return ChoiceChip(
      label: compact
          ? FittedBox(
        fit: BoxFit.scaleDown,
        child: labelContent,
      )
          : labelContent,
      labelPadding: EdgeInsets.symmetric(
        horizontal: compact ? 4 : 8,
      ),
      selected: selected,
      onSelected: (_) => onSelected(value),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: selected
            ? Colors.white
            : AppColors.textPrimary,
        fontSize: compact ? 13 : 14,
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