import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/data_repository.dart';
import 'package:projects/models/university_config.dart';


class UniversityConfigScreen extends StatefulWidget {
  final int? editIndex;

  const UniversityConfigScreen({Key? key, this.editIndex}) : super(key: key);

  @override
  _UniversityConfigScreenState createState() => _UniversityConfigScreenState();
}

class _UniversityConfigScreenState extends State<UniversityConfigScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _courseUrlController = TextEditingController();
  final _eventsUrlController = TextEditingController();

  // Course selectors
  final _courseSelectorController = TextEditingController();
  final _courseCodeSelectorController = TextEditingController();
  final _courseNameSelectorController = TextEditingController();
  final _instructorSelectorController = TextEditingController();
  final _scheduleSelectorController = TextEditingController();
  final _locationSelectorController = TextEditingController();

  // Event selectors
  final _eventSelectorController = TextEditingController();
  final _eventTitleSelectorController = TextEditingController();
  final _eventDateSelectorController = TextEditingController();
  final _eventLocationSelectorController = TextEditingController();
  final _eventDescriptionSelectorController = TextEditingController();
  final _eventOrganizerSelectorController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.editIndex != null;

    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadExistingConfig();
      });
    }
  }

  void _loadExistingConfig() {
    final repository = Provider.of<DataRepository>(context, listen: false);
    final configs = repository.getUniversityConfigs();

    if (widget.editIndex! < configs.length) {
      final config = configs[widget.editIndex!];

      _nameController.text = config.name;
      _courseUrlController.text = config.courseUrl;
      _eventsUrlController.text = config.eventsUrl;

      _courseSelectorController.text = config.courseSelector;
      _courseCodeSelectorController.text = config.courseCodeSelector;
      _courseNameSelectorController.text = config.courseNameSelector;
      _instructorSelectorController.text = config.instructorSelector;
      _scheduleSelectorController.text = config.scheduleSelector;
      _locationSelectorController.text = config.locationSelector;

      _eventSelectorController.text = config.eventSelector;
      _eventTitleSelectorController.text = config.eventTitleSelector;
      _eventDateSelectorController.text = config.eventDateSelector;
      _eventLocationSelectorController.text = config.eventLocationSelector;
      _eventDescriptionSelectorController.text = config.eventDescriptionSelector;
      _eventOrganizerSelectorController.text = config.eventOrganizerSelector;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _courseUrlController.dispose();
    _eventsUrlController.dispose();

    _courseSelectorController.dispose();
    _courseCodeSelectorController.dispose();
    _courseNameSelectorController.dispose();
    _instructorSelectorController.dispose();
    _scheduleSelectorController.dispose();
    _locationSelectorController.dispose();

    _eventSelectorController.dispose();
    _eventTitleSelectorController.dispose();
    _eventDateSelectorController.dispose();
    _eventLocationSelectorController.dispose();
    _eventDescriptionSelectorController.dispose();
    _eventOrganizerSelectorController.dispose();

    super.dispose();
  }

  void _saveUniversity() async {
    if (_formKey.currentState!.validate()) {
      final config = UniversityConfig(
        name: _nameController.text,
        courseUrl: _courseUrlController.text,
        eventsUrl: _eventsUrlController.text,

        courseSelector: _courseSelectorController.text,
        courseCodeSelector: _courseCodeSelectorController.text,
        courseNameSelector: _courseNameSelectorController.text,
        instructorSelector: _instructorSelectorController.text,
        scheduleSelector: _scheduleSelectorController.text,
        locationSelector: _locationSelectorController.text,

        eventSelector: _eventSelectorController.text,
        eventTitleSelector: _eventTitleSelectorController.text,
        eventDateSelector: _eventDateSelectorController.text,
        eventLocationSelector: _eventLocationSelectorController.text,
        eventDescriptionSelector: _eventDescriptionSelectorController.text,
        eventOrganizerSelector: _eventOrganizerSelectorController.text,
      );

      final repository = Provider.of<DataRepository>(context, listen: false);

      if (_isEditing && widget.editIndex != null) {
        await repository.updateUniversityConfig(widget.editIndex!, config);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('University configuration updated')),
        );
      } else {
        await repository.addUniversityConfig(config);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('University configuration added')),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit University' : 'Add University'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic Information
            const Text(
              'Basic Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'University Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _courseUrlController,
              decoration: const InputDecoration(
                labelText: 'Courses URL',
                border: OutlineInputBorder(),
                hintText: 'https://example-university.edu/courses',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a courses URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _eventsUrlController,
              decoration: const InputDecoration(
                labelText: 'Events URL',
                border: OutlineInputBorder(),
                hintText: 'https://example-university.edu/events',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an events URL';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Course Configuration
            const Text(
              'Course Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _courseSelectorController,
              decoration: const InputDecoration(
                labelText: 'Course Item Selector',
                border: OutlineInputBorder(),
                hintText: '.course-item',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a selector';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _courseCodeSelectorController,
                    decoration: const InputDecoration(
                      labelText: 'Course Code Selector',
                      border: OutlineInputBorder(),
                      hintText: '.course-code',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _courseNameSelectorController,
                    decoration: const InputDecoration(
                      labelText: 'Course Name Selector',
                      border: OutlineInputBorder(),
                      hintText: '.course-name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _instructorSelectorController,
                    decoration: const InputDecoration(
                      labelText: 'Instructor Selector',
                      border: OutlineInputBorder(),
                      hintText: '.instructor',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _scheduleSelectorController,
                    decoration: const InputDecoration(
                      labelText: 'Schedule Selector',
                      border: OutlineInputBorder(),
                      hintText: '.schedule',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationSelectorController,
              decoration: const InputDecoration(
                labelText: 'Location Selector',
                border: OutlineInputBorder(),
                hintText: '.location',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Events Configuration
            const Text(
              'Events Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _eventSelectorController,
              decoration: const InputDecoration(
                labelText: 'Event Item Selector',
                border: OutlineInputBorder(),
                hintText: '.event-item',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a selector';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _eventTitleSelectorController,
                    decoration: const InputDecoration(
                      labelText: 'Event Title Selector',
                      border: OutlineInputBorder(),
                      hintText: '.event-title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _eventDateSelectorController,
                    decoration: const InputDecoration(
                      labelText: 'Event Date Selector',
                      border: OutlineInputBorder(),
                      hintText: '.event-date',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _eventLocationSelectorController,
                    decoration: const InputDecoration(
                      labelText: 'Event Location Selector',
                      border: OutlineInputBorder(),
                      hintText: '.event-location',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _eventDescriptionSelectorController,
                    decoration: const InputDecoration(
                      labelText: 'Event Description Selector',
                      border: OutlineInputBorder(),
                      hintText: '.event-description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _eventOrganizerSelectorController,
              decoration: const InputDecoration(
                labelText: 'Event Organizer Selector',
                border: OutlineInputBorder(),
                hintText: '.event-organizer',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _saveUniversity,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(_isEditing ? 'Update University Configuration' : 'Save University Configuration'),
            ),
          ],
        ),
      ),
    );
  }
}
