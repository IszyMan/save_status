import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import 'package:share_plus/share_plus.dart';
import '../services/rewards_api_service.dart';
import 'reward_redemption_screen.dart';

class CampaignProgressScreen extends StatefulWidget {
  final Map<String, dynamic> enrolment;
  final String? referralCode;

  const CampaignProgressScreen({
    super.key,
    required this.enrolment,
    this.referralCode,
  });

  @override
  State<CampaignProgressScreen> createState() =>
      _CampaignProgressScreenState();
}

class _CampaignProgressScreenState extends State<CampaignProgressScreen> {
  final RewardsApiService _api = RewardsApiService();

  late Map<String, dynamic> _enrolment;

  @override
  void initState() {
    super.initState();
    _enrolment = Map<String, dynamic>.from(widget.enrolment);
  }

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

  int _intValue(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _progress(int current, int target) {
    if (target <= 0) return 0;
    return (current / target).clamp(0.0, 1.0).toDouble();
  }

  String get _referralLink {
    final code = Uri.encodeComponent(widget.referralCode ?? '');

    return 'https://play.google.com/store/apps/details'
        '?id=com.iszyman.statusly&referrer=referral_code%3D$code';
  }

  Future<void> _copyReferralLink(BuildContext context) async {
    if (widget.referralCode == null || widget.referralCode!.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: _referralLink));

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Referral link copied.')));
  }

  Future<void> _shareReferralLink(BuildContext context) async {
    if (widget.referralCode == null || widget.referralCode!.isEmpty) return;

    await SharePlus.instance.share(
      ShareParams(
        title: 'Join me on Statusly',
        text:
            'Save WhatsApp statuses with Statusly!\n\n'
            'Download the app using my referral link:\n'
            '$_referralLink',
      ),
    );
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
      await _refreshEnrolment();
    }
  }

  Future<void> _refreshEnrolment() async {
    try {
      final response = await _api.getEnrolments();
      final data = Map<String, dynamic>.from(response as Map? ?? {});
      final enrolments = _asMapList(data['enrolments']);

      final campaignCode = _enrolment['campaign_code']?.toString();

      for (final item in enrolments) {
        if (item['campaign_code']?.toString() == campaignCode) {
          if (!mounted) return;

          setState(() {
            _enrolment = item;
          });
          return;
        }
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not refresh reward status: ${error.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _enrolment['campaign_name']?.toString() ?? 'Campaign progress';
    final status = _enrolment['campaign_status']?.toString() ?? 'active';
    final tasks = _asMapList(_enrolment['tasks']);

    return Scaffold(
      appBar: AppBar(title: const Text('Campaign progress')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    size: 38,
                    color: Color(0xFF7B2FF7),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Campaign status: ${status.replaceAll('_', ' ')}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Your tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),

          if (tasks.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text('No task progress is available yet.'),
              ),
            )
          else
            ...tasks.map(_buildTaskCard),

          if (tasks.any((progress) {
            final task = _asMap(progress['task']);
            return task['type']?.toString() == 'referrals';
          })) ...[
            const SizedBox(height: 20),
            _buildReferralCard(context),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> progress) {
    final task = _asMap(progress['task']);
    final title = task['title']?.toString() ?? 'Task';
    final description = task['description']?.toString() ?? '';
    final current = _intValue(progress['progress_count']);
    final target = _intValue(task['target_count']);
    final completed =
        progress['completed_at'] != null || (target > 0 && current >= target);
    final rewards = _asMapList(progress['rewards']);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  completed
                      ? Icons.check_circle_rounded
                      : Icons.track_changes_rounded,
                  color: completed
                      ? const Color(0xFF25D366)
                      : const Color(0xFF128C7E),
                ),
              ],
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    target > 0
                        ? '$current of $target completed'
                        : '$current completed',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                if (completed)
                  const Text(
                    'Completed',
                    style: TextStyle(
                      color: Color(0xFF128C7E),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: target > 0 ? _progress(current, target) : null,
                minHeight: 9,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  completed ? const Color(0xFF25D366) : const Color(0xFF128C7E),
                ),
              ),
            ),
            if (rewards.any(
                  (reward) => reward['status']?.toString() == 'earned',
            )) ...[
              const SizedBox(height: 14),
              const Text(
                'Rewards earned',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              ...rewards
                  .where((reward) => reward['status']?.toString() == 'earned')
                  .map((reward) {
                final bundles = _asMapList(progress['bundles']);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5EF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.card_giftcard_rounded,
                            color: Color(0xFF128C7E),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Data reward earned',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
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
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReferralCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.people_alt_rounded,
                  color: Color(0xFF7B2FF7),
                  size: 28,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Invite friends',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Share Statusly with friends to make progress on this '
              'referral task. Referrals must meet the campaign rules '
              'before they count.',
              style: TextStyle(height: 1.45),
            ),
            const SizedBox(height: 14),
            if (widget.referralCode == null || widget.referralCode!.isEmpty)
              const Text('Your referral code is not available yet.')
            else ...[
              SelectableText(
                widget.referralCode!,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _copyReferralLink(context),
                  icon: const Icon(Icons.link_rounded),
                  label: const Text('Copy referral link'),
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _shareReferralLink(context),
                  icon: const Icon(Icons.share_rounded),
                  label: const Text('Share referral link'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
