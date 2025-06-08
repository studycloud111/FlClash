import 'package:fl_clash/v2board/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionProvider = FutureProvider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.getSubscription();
});

class SubscriptionPage extends ConsumerWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
      ),
      body: subscription.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (response) {
          final subscriptionUrl = response.data['data']['subscribe_url'];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your Subscription URL:',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                SelectableText(
                  subscriptionUrl,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: subscriptionUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy URL'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 