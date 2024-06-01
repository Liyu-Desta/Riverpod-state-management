// user_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/Domain/models/userDashboard_model.dart';
import 'package:one/Application/riverpod/userDashboard_riverpod.dart';

class UserDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) { // Correct the parameter to WidgetRef
    final userOpportunitiesState = ref.watch(userDashboardNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
      ),
      body: userOpportunitiesState.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (userOpportunities) {
          return ListView.builder(
            itemCount: userOpportunities.length,
            itemBuilder: (context, index) {
              final opportunity = userOpportunities[index];
              return OpportunityCard(opportunity: opportunity);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen for adding new opportunities
          Navigator.of(context).pushNamed('/addOpportunity');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class OpportunityCard extends ConsumerWidget {
  final UserOpportunity opportunity;

  const OpportunityCard({required this.opportunity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              opportunity.opportunityId.title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(opportunity.opportunityId.description),
            SizedBox(height: 8.0),
            Text('Selected Date: ${opportunity.selectedDate.toString()}'),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle editing the opportunity
                    Navigator.of(context).pushNamed('/editOpportunity',
                        arguments: opportunity.id);
                  },
                  child: Text('Edit'),
                ),
                TextButton(
                  onPressed: () {
                    // Delete the opportunity using Riverpod
                    ref.read(userDashboardNotifierProvider.notifier)
                      .deleteUserOpportunity(opportunity.id)
                      .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opportunity deleted successfully'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to delete opportunity: $error'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
