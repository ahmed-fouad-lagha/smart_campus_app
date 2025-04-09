// Create a new file: lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import '../models.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  String _filterCategory = 'All';
  final List<String> _categories = ['All', 'Academic', 'Events', 'Facilities', 'Research'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search campus resources...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category filter chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((category) =>
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(category),
                      selected: _filterCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _filterCategory = selected ? category : 'All';
                        });
                      },
                    ),
                  )
              ).toList(),
            ),
          ),

          // Search results
          Expanded(
            child: ValueListenableBuilder<Box<UpdateItem>>(
              valueListenable: Hive.box<UpdateItem>('updates').listenable(),
              builder: (context, box, _) {
                final updates = box.values.where((update) {
                  final matchesQuery = _searchQuery.isEmpty ||
                      update.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      update.description.toLowerCase().contains(_searchQuery.toLowerCase());

                  final matchesCategory = _filterCategory == 'All' ||
                      update.category == _filterCategory;

                  return matchesQuery && matchesCategory;
                }).toList();

                if (updates.isEmpty) {
                  return const Center(
                    child: Text('No results found'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: updates.length,
                  itemBuilder: (context, index) {
                    final update = updates[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(update.title),
                        subtitle: Text(
                          update.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(update.formattedDate),
                        onTap: () {
                          // Show detail view
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (context) => DraggableScrollableSheet(
                              initialChildSize: 0.6,
                              maxChildSize: 0.9,
                              minChildSize: 0.5,
                              expand: false,
                              builder: (context, scrollController) {
                                return SingleChildScrollView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 40,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(update.category, style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold)),
                                          Text(update.formattedDate, style: const TextStyle(color: Colors.grey)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(update.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 16),
                                      Text(update.description),
                                      const SizedBox(height: 32),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton.icon(
                                            icon: const Icon(Icons.share),
                                            label: const Text('Share'),
                                            onPressed: () {
                                              // Share functionality
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton.icon(
                                            icon: const Icon(Icons.bookmark_outline),
                                            label: const Text('Save'),
                                            onPressed: () {
                                              // Save functionality
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}