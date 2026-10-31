
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/rewards_api_service.dart';

class RewardRedemptionScreen extends StatefulWidget {
  final Map<String, dynamic> reward;
  final List<Map<String, dynamic>> bundles;

  const RewardRedemptionScreen({
    super.key,
    required this.reward,
    required this.bundles,
  });

  @override
  State<RewardRedemptionScreen> createState() =>
      _RewardRedemptionScreenState();
}

class _RewardRedemptionScreenState
    extends State<RewardRedemptionScreen> {
  final RewardsApiService _api = RewardsApiService();
  final TextEditingController _phoneController =
  TextEditingController();

  String? _selectedNetwork;
  bool _submitting = false;
  String? _redemptionStatus;
  String? _message;

  Map<String, dynamic>? get _selectedBundle {
    if (_selectedNetwork == null) return null;

    for (final bundle in widget.bundles) {
      if (bundle['network']?.toString().toLowerCase() ==
          _selectedNetwork) {
        return bundle;
      }
    }

    return null;
  }

  List<String> get _availableNetworks {
    return widget.bundles
        .map((bundle) => bundle['network']
        ?.toString()
        .toLowerCase())
        .whereType<String>()
        .where((network) =>
        ['mtn', 'airtel', 'glo'].contains(network))
        .toSet()
        .toList();
  }

  String _networkName(String network) {
    switch (network) {
      case 'mtn':
        return 'MTN';
      case 'airtel':
        return 'Airtel';
      case 'glo':
        return 'Glo';
      default:
        return network.toUpperCase();
    }
  }

  String _dataAmount(dynamic value, dynamic bundleName) {
    final amount = double.tryParse(value?.toString() ?? '');

    if (amount == null || amount <= 0) {
      final name = bundleName?.toString().trim() ?? '';
      return name.isNotEmpty ? name : 'Data bundle';
    }

    if (amount >= 1000) {
      final gb = amount / 1000;
      return '${gb.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '')} GB';
    }

    return '${amount.toStringAsFixed(0)} MB';
  }

  String? _validity(dynamic value) {
    final validity = value?.toString().trim() ?? '';
    return validity.isEmpty ? null : validity;
  }

  Future<void> _redeem() async {
    final rewardId = widget.reward['reward_id']?.toString() ?? '';
    final phone = _phoneController.text.trim();

    if (rewardId.isEmpty) {
      setState(() => _message = 'Reward information is unavailable.');
      return;
    }

    if (_selectedNetwork == null || _selectedBundle == null) {
      setState(() => _message = 'Please select a network.');
      return;
    }

    if (!RegExp(r'^(?:0[789]\d{9}|\+?234[789]\d{9})$')
        .hasMatch(phone)) {
      setState(() => _message = 'Enter a valid Nigerian phone number.');
      return;
    }

    setState(() {
      _submitting = true;
      _message = null;
    });

    try {
      final response = await _api.redeemReward(
        rewardId: rewardId,
        network: _selectedNetwork!,
        phone: phone,
      );

      final redemption = response['redemption'] is Map
          ? Map<String, dynamic>.from(response['redemption'])
          : response;

      if (!mounted) return;

      setState(() {
        _redemptionStatus =
            redemption['status']?.toString() ?? 'processing';
        _message = redemption['message']?.toString() ??
            response['message']?.toString();
      });

      if (_redemptionStatus == 'delivered') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your reward has been delivered.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _message = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final networks = _availableNetworks;
    final bundle = _selectedBundle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Redeem reward'),
      ),
      body: networks.isEmpty
          ? const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No data bundles are available for this reward.',
            textAlign: TextAlign.center,
          ),
        ),
      )
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Choose your network',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            initialValue: _selectedNetwork,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select network',
            ),
            items: networks.map((network) {
              return DropdownMenuItem(
                value: network,
                child: Text(_networkName(network)),
              );
            }).toList(),
            onChanged: _submitting
                ? null
                : (value) {
              setState(() {
                _selectedNetwork = value;
                _message = null;
              });
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'Data bundle',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: bundle == null
                ? const Text('Select a network to view its bundle.')
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dataAmount(
                    bundle['data_amount_mb'],
                    bundle['bundle_name'],
                  ),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                if (_validity(bundle['validity_label']) != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _validity(bundle['validity_label'])!,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Phone number',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _phoneController,
            enabled: !_submitting &&
                _redemptionStatus == null,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9+]'),
              ),
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter recipient phone number',
            ),
          ),

          if (_message != null) ...[
            const SizedBox(height: 14),
            Text(
              _message!,
              style: TextStyle(
                color: _redemptionStatus == 'delivered'
                    ? Colors.green
                    : Theme.of(context).colorScheme.error,
              ),
            ),
          ],

          if (_redemptionStatus != null) ...[
            const SizedBox(height: 16),
            Text(
              'Redemption status: ${_redemptionStatus!.replaceAll('_', ' ')}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ||
                  _redemptionStatus != null
                  ? null
                  : _redeem,
              child: _submitting
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Text('Confirm redemption'),
            ),
          ),
        ],
      ),
    );
  }
}
