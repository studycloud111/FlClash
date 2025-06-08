import 'package:fl_clash/v2board/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final plansProvider = FutureProvider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.getPlans();
});

class PlansPage extends ConsumerWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(plansProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Plan'),
      ),
      body: plans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (response) {
          final List<dynamic> planList = response.data['data'];
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8,
            ),
            itemCount: planList.length,
            itemBuilder: (context, index) {
              final plan = planList[index];
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      plan['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Price: ¥${plan['price']}'),
                    const SizedBox(height: 8),
                    Text('Traffic: ${plan['transfer_enable']} GB'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final apiClient = ref.read(apiClientProvider);
                          await apiClient.createOrder(plan['id']);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Order Created'),
                              content: const Text(
                                  'Your order has been created. Please complete the payment on our website.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to create order: $e')),
                          );
                        }
                      },
                      child: const Text('Purchase'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
} 