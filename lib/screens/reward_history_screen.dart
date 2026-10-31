
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';


class RewardHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> enrolments;

  const RewardHistoryScreen({
    super.key,
    required this.enrolments,
  });

  List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  List<Map<String, dynamic>> _getRewards() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final enrolment in enrolments) {
      final tasks = _asMapList(enrolment['tasks']);

      for (final progress in tasks) {
        final task = _asMap(progress['task']);
        final taskTitle =
            task['title']?.toString() ?? 'Completed task';

        final rewards = _asMapList(progress['rewards']);

        for (final reward in rewards) {
          final rewardId = reward['reward_id']?.toString() ?? '';

          if (rewardId.isEmpty) continue;

          grouped.putIfAbsent(taskTitle, () => []);

          grouped[taskTitle]!.add({
            ...reward,
            'task_title': taskTitle,
            'campaign_name':
            enrolment['campaign_name']?.toString() ??
                'Rewards campaign',
          });
        }
      }
    }

    return grouped.entries.map((entry) {
      return {
        'task_title': entry.key,
        'rewards': entry.value,
      };
    }).toList();
  }


  String _rewardName(Map<String, dynamic> reward) {
    final redemption = _asMap(reward['redemption']);
    final bundle = _asMap(redemption['bundle']);

    final network = (
        redemption['network'] ??
            bundle['network'] ??
            ''
    ).toString().trim().toLowerCase();

    final amount = double.tryParse(
      (bundle['data_amount_mb'] ?? '').toString(),
    );

    String amountText;

    if (amount != null && amount > 0) {
      if (amount >= 1000) {
        final gb = amount / 1000;
        amountText =
        '${gb.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '')} GB';
      } else {
        amountText = '${amount.toStringAsFixed(0)}MB';
      }
    } else {
      amountText = (
          bundle['bundle_name'] ??
              bundle['name'] ??
              bundle['variation_name'] ??
              'Data reward'
      ).toString().trim();
    }

    final networkName = network.isEmpty
        ? ''
        : network == 'mtn'
        ? 'MTN'
        : network[0].toUpperCase() + network.substring(1);

    if (networkName.isNotEmpty) {
      return '$networkName Data $amountText';
    }

    return 'Data $amountText';
  }


  String _formatDate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Not available';
    }

    final date = DateTime.tryParse(value.toString());

    if (date == null) return 'Not available';

    final localDate = date.toLocal();

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final day = localDate.day.toString().padLeft(2, '0');

    return '$day ${months[localDate.month - 1]} ${localDate.year}';
  }

  String _formatStatus(dynamic value) {
    final status = value?.toString().trim() ?? '';

    if (status.isEmpty) return 'Unknown';

    return status
        .split('_')
        .map((word) => word.isEmpty
        ? word
        : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF128C7E);
      case 'processing':
      case 'pending':
        return const Color(0xFFE69A16);
      case 'review':
        return const Color(0xFF7B2FF7);
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildInformationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(BuildContext context, Map<String, dynamic> reward,) {
    final redemption = _asMap(reward['redemption']);

    final rewardName = _rewardName(reward);
    final status = _formatStatus(reward['status']);

    final deliveredAt =
        reward['delivered_at'] ?? redemption['delivered_at'];

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 4,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          leading: const CircleAvatar(
            radius: 19,
            backgroundColor: Color(0xFFE1F5EF),
            child: Icon(
              Icons.card_giftcard_rounded,
              color: Color(0xFF128C7E),
              size: 20,
            ),
          ),
          title: Text(
            rewardName,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              status,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: _statusColor(
                  reward['status']?.toString() ?? '',
                ),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          children: [
            const Divider(height: 20),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Information',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 14),
            _buildInformationRow(
              'Campaign',
              reward['campaign_name']?.toString() ??
                  'Rewards campaign',
            ),
            _buildInformationRow(
              'Reward',
              rewardName,
            ),
            _buildInformationRow(
              'Date earned',
              _formatDate(reward['earned_at']),
            ),
            _buildInformationRow(
              'Date redeemed',
              deliveredAt == null
                  ? 'Not redeemed'
                  : _formatDate(deliveredAt),
            ),
            _buildInformationRow(
              'Status',
              status,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskContainer(BuildContext context,Map<String, dynamic> group) {
    final taskTitle =
        group['task_title']?.toString() ?? 'Completed task';

    final rewards = _asMapList(group['rewards']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskTitle,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),

            ...rewards.map((reward) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildRewardCard(context, reward),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = _getRewards();

    final totalRewards = groups.fold<int>(
      0,
          (total, group) =>
      total + _asMapList(group['rewards']).length,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward History'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Reward History',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'All your earned rewards and their redemption status.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          if (groups.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 52,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 14),
                  Text(
                    'No reward history yet',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rewards you earn from campaigns will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Text(
              '$totalRewards ${totalRewards == 1 ? 'reward' : 'rewards'}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ...groups.map((group) => _buildTaskContainer(context, group)),
          ],
        ],
      ),
    );
  }
}
