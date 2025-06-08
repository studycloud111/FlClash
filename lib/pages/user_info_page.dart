import 'package:fl_clash/v2board/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_clash/pages/subscription_page.dart';
import 'package:fl_clash/pages/plans_page.dart';

final userInfoProvider = FutureProvider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.getUserInfo();
});

class UserInfoPage extends ConsumerWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: userInfo.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (response) {
          final data = response.data['data'];
          final total = data['transfer_enable'] / (1024 * 1024 * 1024);
          final used = (data['d'] ?? 0) / (1024 * 1024 * 1024);
          final remaining = total - used;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Email'),
                      subtitle: Text(data['email']),
                    ),
                    ListTile(
                      title: const Text('Plan'),
                      subtitle: Text(data['plan']['name']),
                    ),
                    ListTile(
                      title: const Text('Traffic'),
                      subtitle: Text(
                          '${remaining.toStringAsFixed(2)} GB Remaining / ${total.toStringAsFixed(2)} GB Total'),
                      trailing: SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          value: total > 0 ? used / total : 0,
                          minHeight: 10,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Expired At'),
                      subtitle: Text(DateTime.fromMillisecondsSinceEpoch(data['expired_at'] * 1000).toString()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SubscriptionPage(),
                          ),
                        );
                      },
                      child: const Text('View Subscription'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlansPage(),
                          ),
                        );
                      },
                      child: const Text('Purchase Plan'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 