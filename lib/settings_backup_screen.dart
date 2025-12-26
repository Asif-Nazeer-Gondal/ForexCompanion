import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettingsBackupScreen extends StatefulWidget {
  const SettingsBackupScreen({super.key});

  @override
  State<SettingsBackupScreen> createState() => _SettingsBackupScreenState();
}

class _SettingsBackupScreenState extends State<SettingsBackupScreen> {
  bool _isProcessing = false;
  String? _lastBackupDate;

  Future<void> _createBackup() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate backup process (e.g., serializing data, writing to file/cloud)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _lastBackupDate = DateFormat.yMMMd().add_jm().format(DateTime.now());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup created successfully')),
      );
    }
  }

  Future<void> _restoreBackup() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate restore process
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings restored successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.cloud_upload,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 12),
                            Text(
                              'Create Backup',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Save your current settings, trade history, and preferences to a local file or cloud storage.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        if (_lastBackupDate != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    size: 16, color: Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  'Last Backup: $_lastBackupDate',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _createBackup,
                            child: const Text('Create New Backup'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.cloud_download,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 12),
                            Text(
                              'Restore Data',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Restore your settings from a previously saved backup file. This will overwrite current settings.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _restoreBackup,
                            child: const Text('Restore from Backup'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}