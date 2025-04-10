import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/data_repository.dart';
import '../services/web_scraper_service.dart';
import 'university_config_screen.dart';

class UniversityListScreen extends StatefulWidget {
  const UniversityListScreen({Key? key}) : super(key: key);

  @override
  _UniversityListScreenState createState() => _UniversityListScreenState();
}

class _UniversityListScreenState extends State<UniversityListScreen> {
  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<DataRepository>(context);
    final universities = repository.getUniversityConfigs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('University Websites'),
      ),
      body: universities.isEmpty
          ? const Center(
        child: Text('No university websites configured'),
      )
          : ListView.builder(
        itemCount: universities.length,
        itemBuilder: (context, index) {
          final university = universities[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(university.name),
              subtitle: Text(university.courseUrl),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UniversityConfigScreen(editIndex: index),
                        ),
                      ).then((_) => setState(() {}));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmation(context, index);
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UniversityConfigScreen(editIndex: index),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UniversityConfigScreen(),
            ),
          ).then((_) => setState(() {}));
        },
        child: const Icon(Icons.add),
        tooltip: 'Add University',
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete University'),
        content: const Text('Are you sure you want to delete this university configuration?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final repository = Provider.of<DataRepository>(context, listen: false);
              await repository.deleteUniversityConfig(index);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
