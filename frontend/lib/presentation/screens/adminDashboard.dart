import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../domain/models/opportunities.dart';
import '../../Application/riverpod/adminDashboard_riverpod.dart';
import '../../presentation/widgets/HamburgerMenu.dart';
import '../widgets/logout_dialog.dart';
import 'profile.dart';
import '../../presentation/screens/userList.dart';
import '../screens/loginPage.dart';

class Dashboard extends ConsumerStatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  DateTime? _date1;
  DateTime? _date2;
  Uint8List? _selectedImage;

  @override
  void initState() {
    super.initState();
    ref.read(adminDashboardNotifierProvider.notifier).fetchOpportunities();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _addOpportunity() {
    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: AlertDialog(
            title: Text('Add Opportunity'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title *'),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration:
                        InputDecoration(labelText: 'Description (Optional)'),
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Location *'),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _selectDate().then((pickedDate) {
                              if (pickedDate != null) {
                                setState(() {
                                  _date1 = pickedDate;
                                });
                              }
                            });
                          },
                          child: Text('Select Date 1 *'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _selectDate().then((pickedDate) {
                              if (pickedDate != null) {
                                setState(() {
                                  _date2 = pickedDate;
                                });
                              }
                            });
                          },
                          child: Text('Select Date 2 (Optional)'),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedImage != null) SizedBox(height: 16),
                  if (_selectedImage != null)
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Image.memory(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Photo'),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty ||
                      _locationController.text.isEmpty ||
                      _date1 == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Please fill in all mandatory fields!')),
                    );
                    return;
                  }
                  if (_date2 != null && _date2!.isBefore(_date1!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Date 2 must be after Date 1!')),
                    );
                    return;
                  }
                  final newOpportunity = Opportunity(
                    id: "",
                    title: _titleController.text,
                    description: _descriptionController.text,
                    location: _locationController.text,
                    date1: _date1!,
                    date2: _date2,
                    image: _selectedImage,
                  );
                  ref
                      .read(adminDashboardNotifierProvider.notifier)
                      .addOpportunity(newOpportunity);
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<DateTime?> _selectDate() async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final imageBytes = await pickedImage.readAsBytes();
        setState(() {
          _selectedImage = imageBytes;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image!')),
      );
    }
  }

  void _editOpportunity(Opportunity selectedOpportunity) {
    _titleController.text = selectedOpportunity.title;
    _descriptionController.text = selectedOpportunity.description;
    _locationController.text = selectedOpportunity.location;
    _date1 = selectedOpportunity.date1;
    _date2 = selectedOpportunity.date2;
    _selectedImage = Uint8List.fromList(selectedOpportunity.image!);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Opportunity'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title *'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                      InputDecoration(labelText: 'Description (Optional)'),
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location *'),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _selectDate().then((pickedDate) {
                          if (pickedDate != null) {
                            setState(() {
                              _date1 = pickedDate;
                            });
                          }
                        });
                      },
                      child: Text('Select Date 1 *'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        _selectDate().then((pickedDate) {
                          if (pickedDate != null) {
                            setState(() {
                              _date2 = pickedDate;
                            });
                          }
                        });
                      },
                      child: Text('Select Date 2 (Optional)'),
                    ),
                  ],
                ),
                if (_selectedImage != null) SizedBox(height: 16),
                if (_selectedImage != null)
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Image.memory(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Photo'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _locationController.text.isEmpty ||
                    _date1 == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please fill in all mandatory fields!')),
                  );
                  return;
                }
                if (_date2 != null && _date2!.isBefore(_date1!)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Date 2 must be after Date 1!')),
                  );
                  return;
                }
                final updatedOpportunity = Opportunity(
                  id: selectedOpportunity.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  location: _locationController.text,
                  date1: _date1!,
                  date2: _date2,
                  image: _selectedImage,
                );
                ref
                    .read(adminDashboardNotifierProvider.notifier)
                    .updateOpportunity(
                        selectedOpportunity.id, updatedOpportunity);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteOpportunity(Opportunity selectedOpportunity) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this opportunity?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(adminDashboardNotifierProvider.notifier)
                    .deleteOpportunity(selectedOpportunity.id);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final opportunitiesState = ref.watch(adminDashboardNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: HamburgerMenu(
        onUserListTap: () {
          // print("USERLIST ROUTING");
          context.go('/userList');
        },
        onDashboardTap: () {
          // print("DASHBOARD ROUTING");
          context.go('/dashboard');
        },
        onProfileTap: () {
          // print("PROFILE ROUTING");
          context.go('/profile');
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _addOpportunity,
              child: Text('Add Opportunity'),
            ),
          ),
          opportunitiesState.when(
            data: (opportunities) {
              return Expanded(
                child: ListView.builder(
                  itemCount: opportunities.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(opportunities[index].title),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteOpportunity(opportunities[index]);
                      },
                      child: GestureDetector(
                        onTap: () {
                          _editOpportunity(opportunities[index]);
                        },
                        child: OpportunityCard(
                          opportunity: opportunities[index],
                          onEdit: () {
                            _editOpportunity(opportunities[index]);
                          },
                          onDelete: () {
                            _deleteOpportunity(opportunities[index]);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text(
                'Failed to load data. Please try again.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const OpportunityCard(
      {Key? key, required this.opportunity, this.onEdit, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: opportunity.image != null
            ? Image.memory(
                Uint8List.fromList(opportunity.image!),
                width: 80,
                fit: BoxFit.cover,
              )
            : Container(
                width: 80,
                height: 80,
                color: Colors.grey,
                child: Icon(Icons.image, color: Colors.white),
              ),
        title: Text(opportunity.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(opportunity.description.isNotEmpty
                ? opportunity.description
                : 'No Description'),
            SizedBox(height: 8),
            Text('Location: ${opportunity.location}'),
            SizedBox(height: 8),
            Text(
              'Date 1: ${DateFormat('yyyy-MM-dd').format(opportunity.date1)}\n' +
                  (opportunity.date2 != null
                      ? 'Date 2: ${DateFormat('yyyy-MM-dd').format(opportunity.date2!)}'
                      : 'Date 2: -'),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
