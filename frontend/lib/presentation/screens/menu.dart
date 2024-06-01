import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/Domain/models/menu_opportunity_model.dart';
import 'package:one/Application/riverpod/menu_opportunity_riverpod.dart';

class Menu extends ConsumerWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuOpportunitiesState = ref.watch(menuOpportunityNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Opportunities For You'),
      ),
      body: menuOpportunitiesState.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (menuOpportunities) {
          if (menuOpportunities.isEmpty) {
            return Center(child: Text('No opportunities available'));
          } else {
            return ListView.builder(
              itemCount: menuOpportunities.length,
              itemBuilder: (context, index) {
                return buildMenuItemWidget(context, ref, menuOpportunities[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildMenuItemWidget(BuildContext context, WidgetRef ref, MenuOpportunity menuOpportunity) {
    return GestureDetector(
      onTap: () {
        _showOpportunityDetails(context, ref, menuOpportunity);
      },
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: menuOpportunity.image != null
                  ? Image.memory(
                      menuOpportunity.image!,
                      fit: BoxFit.cover,
                      height: 100.0,
                      width: 100.0,
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey,
                      child: Icon(Icons.image, color: Colors.white),
                    ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    menuOpportunity.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    menuOpportunity.description.isNotEmpty
                        ? menuOpportunity.description
                        : 'No Description',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _registerOpportunity(ref, menuOpportunity);
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void _showOpportunityDetails(BuildContext context, WidgetRef ref, MenuOpportunity menuOpportunity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                menuOpportunity.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${menuOpportunity.description}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Location: ${menuOpportunity.location}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Date: ${menuOpportunity.date1}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _registerOpportunity(ref, menuOpportunity);
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Register'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _registerOpportunity(WidgetRef ref, MenuOpportunity menuOpportunity) {
    ref.read(menuOpportunityNotifierProvider.notifier).registerOpportunity(menuOpportunity);
  }
}
