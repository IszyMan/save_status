
import 'package:flutter/material.dart';

import '../services/rewards_api_service.dart';
import '../theme/app_theme.dart';
import 'campaign_progress_screen.dart';
import 'reward_redemption_screen.dart';
import 'reward_history_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final RewardsApiService _api = RewardsApiService();

  late Future<Map<String, dynamic>> _dataFuture;
  String? _joiningCampaignCode;

  String? _referralCode;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<Map<String, dynamic>> _loadData() async {
    final results = await Future.wait([
      _api.getDeviceProfile(),
      _api.getCampaigns(),
      _api.getEnrolments(),
    ]);

    final profile = Map<String, dynamic>.from(
      results[0] as Map? ?? {},
    );

    final device = Map<String, dynamic>.from(
      profile['device'] as Map? ?? {},
    );

    _referralCode = device['referral_code']?.toString();

    return {
      'profile': results[0],
      'campaigns': results[1],
      'enrolments': results[2],
    };
  }

  Future<void> _refresh() async {
    final future = _loadData();

    setState(() {
      _dataFuture = future;
    });

    try {
      await future;
    } catch (_) {
      // The FutureBuilder displays the error and retry button.
    }
  }

  Future<void> _joinCampaign(String campaignCode) async {
    setState(() {
      _joiningCampaignCode = campaignCode;
    });

    try {
      await _api.joinCampaign(campaignCode);

      final refreshedData = await _loadData();

      if (!mounted) return;

      setState(() {
        _dataFuture = Future.value(refreshedData);
      });

      final profile = Map<String, dynamic>.from(
        refreshedData['profile'] as Map? ?? {},
      );
      final device = Map<String, dynamic>.from(
        profile['device'] as Map? ?? {},
      );

      _referralCode = device['referral_code']?.toString();

      final enrolmentsResponse = Map<String, dynamic>.from(
        refreshedData['enrolments'] as Map? ?? {},
      );

      final enrolments = _asMapList(
        enrolmentsResponse['enrolments'],
      );

      Map<String, dynamic>? enrolment;

      for (final item in enrolments) {
        if (item['campaign_code']?.toString() == campaignCode) {
          enrolment = item;
          break;
        }
      }

      if (enrolment == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Campaign joined, but its progress could not be loaded. '
                  'Please refresh and try again.',
            ),
          ),
        );
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CampaignProgressScreen(
            enrolment: enrolment!,
            referralCode: device['referral_code']?.toString(),
          ),
        ),
      );

      if (mounted) {
        await _refresh();
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not join campaign: ${_errorMessage(error)}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _joiningCampaignCode = null;
        });
      }
    }
  }

  String _errorMessage(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  int _intValue(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<void> _openRedemption({
    required Map<String, dynamic> reward,
    required List<Map<String, dynamic>> bundles,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RewardRedemptionScreen(
          reward: reward,
          bundles: bundles,
        ),
      ),
    );

    if (mounted) {
      await _refresh();
    }
  }

  List<Map<String, dynamic>> _getEarnedRewards(
      List<Map<String, dynamic>> enrolments,
      ) {
    final earned = <Map<String, dynamic>>[];

    for (final enrolment in enrolments) {
      final tasks = _asMapList(enrolment['tasks']);

      for (final progress in tasks) {
        final rewards = _asMapList(progress['rewards']);
        final bundles = _asMapList(progress['bundles']);
        final task = Map<String, dynamic>.from(
          progress['task'] as Map? ?? {},
        );

        for (final reward in rewards) {
          if (reward['status']?.toString() != 'earned') {
            continue;
          }

          if ((reward['reward_id']?.toString() ?? '').isEmpty) {
            continue;
          }

          earned.add({
            ...reward,
            'campaign_name':
            enrolment['campaign_name']?.toString() ?? 'Rewards campaign',
            'task_title':
            task['title']?.toString() ?? 'Completed task',
            'bundles': bundles,
          });
        }
      }
    }

    return earned;
  }

  int _getRewardHistoryCount(
      List<Map<String, dynamic>> enrolments,
      ) {
    int count = 0;

    for (final enrolment in enrolments) {
      final tasks = _asMapList(enrolment['tasks']);

      for (final task in tasks) {
        final rewards = _asMapList(task['rewards']);

        count += rewards.where((reward) {
          return (reward['reward_id']?.toString() ?? '').isNotEmpty;
        }).length;
      }
    }

    return count;
  }

  Widget _buildRewardHistoryCard(
      List<Map<String, dynamic>> enrolments,
      ) {
    final count = _getRewardHistoryCount(enrolments);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RewardHistoryScreen(
                enrolments: enrolments,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFE1F5EF),
                child: Icon(
                  Icons.history_rounded,
                  color: Color(0xFF128C7E),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reward History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$count ${count == 1 ? 'reward' : 'rewards'}',
                      style: const TextStyle(
                        color: Color(0xFF128C7E),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'View your previous rewards, redemption '
                          'details and delivery status.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'View history',
                      style: TextStyle(
                        color: Color(0xFF128C7E),
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllRewards(
      List<Map<String, dynamic>> enrolments,
      ) {
    final rewards = _getEarnedRewards(enrolments);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'All Rewards',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '${rewards.length}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (rewards.isEmpty)
          _buildEmptyCard(
            icon: Icons.card_giftcard_rounded,
            title: 'No rewards earned yet',
            message:
            'Complete campaign tasks to earn rewards. '
                'Your available rewards will appear here.',
          )
        else
          ...rewards.map((reward) {
            final bundles = _asMapList(reward['bundles']);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFFE1F5EF),
                          child: Icon(
                            Icons.card_giftcard_rounded,
                            color: Color(0xFF128C7E),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Data reward',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      reward['campaign_name']?.toString() ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reward['task_title']?.toString() ?? '',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: bundles.isEmpty
                            ? null
                            : () => _openRedemption(
                          reward: reward,
                          bundles: bundles,
                        ),
                        child: const Text('Redeem reward'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        actions: [
          IconButton(
            tooltip: 'Refresh rewards',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Could not load your rewards.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage(snapshot.error!),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _refresh,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data ?? {};

          final campaignsResponse = Map<String, dynamic>.from(
            data['campaigns'] as Map? ?? {},
          );
          final enrolmentsResponse = Map<String, dynamic>.from(
            data['enrolments'] as Map? ?? {},
          );

          final campaigns = _asMapList(campaignsResponse['campaigns']);
          final enrolments = _asMapList(enrolmentsResponse['enrolments']);

          final enrolmentsByCode = <String, Map<String, dynamic>>{};

          for (final enrolment in enrolments) {
            final code = enrolment['campaign_code']?.toString();
            if (code != null && code.isNotEmpty) {
              enrolmentsByCode[code] = enrolment;
            }
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildBanner(),
                const SizedBox(height: 16),

                _buildRewardHistoryCard(enrolments),

                const SizedBox(height: 24),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Available campaigns',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      '${campaigns.length}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (campaigns.isEmpty)
                  _buildEmptyCard(
                    icon: Icons.card_giftcard_rounded,
                    title: 'No active campaigns yet',
                    message:
                    'New rewards campaigns will appear here when '
                        'they are published and active.',
                  )
                else
                  ...campaigns.map((campaign) {
                    final code = campaign['code']?.toString() ?? '';
                    final enrolment = enrolmentsByCode[code];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildCampaignCard(
                        campaign: campaign,
                        enrolment: enrolment,
                      ),
                    );
                  }),

                const SizedBox(height: 28),

                _buildAllRewards(enrolments),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7B2FF7),
            Color(0xFFF107A3),
            Color(0xFFFFB800),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.card_giftcard_rounded,
            color: Colors.white,
            size: 44,
          ),
          SizedBox(height: 16),
          Text(
            'Save statuses. Refer friends. Earn rewards.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Join eligible campaigns, complete tasks and '
                'track your progress right here.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCampaignCard({
    required Map<String, dynamic> campaign,
    required Map<String, dynamic>? enrolment,
  }) {
    final name = campaign['name']?.toString() ?? 'Rewards campaign';
    final description = campaign['description']?.toString() ?? '';
    final code = campaign['code']?.toString() ?? '';
    final tasks = _asMapList(campaign['tasks']);
    final joined = enrolment != null;
    final isJoining = _joiningCampaignCode == code;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFEDE4FF),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xFF7B2FF7),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          description,
                          style: const TextStyle(height: 1.45),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (tasks.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Campaign tasks',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...tasks.map((task) {
                final title =
                    task['title']?.toString() ?? 'Complete task';
                final target = _intValue(task['target_count']);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 18,
                        color: Color(0xFF128C7E),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(title)),
                      if (target > 0)
                        Text(
                          'Target: $target',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: joined
                  ? OutlinedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CampaignProgressScreen(
                        enrolment: enrolment,
                        referralCode: _referralCode,
                      ),
                    ),
                  );

                  if (mounted) {
                    await _refresh();
                  }
                },
                child: const Text('View progress'),
              )
                  : FilledButton(
                onPressed: code.isEmpty || isJoining
                    ? null
                    : () => _joinCampaign(code),
                child: isJoining
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Text('Join campaign'),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildEmptyCard({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: const TextStyle(height: 1.45),
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
