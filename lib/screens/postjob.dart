import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_provider.dart';
import '../providers/auth_provider.dart';
import './jobs.dart';

class PostJobScreen extends StatefulWidget {
  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _jobData = {};
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final jobProvider = Provider.of<JobProvider>(context, listen: false);
      final token = Provider.of<AuthProvider>(context, listen: false).token;

if (token == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Session expired. Please log in again.')),
  );
  return;
}

await jobProvider.postJob(_jobData, token);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job posted successfully!')),
      );

      Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => JobsScreen()),
);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post job. Please try again.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required String label,
    required String fieldKey,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
      validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter $label' : null,
      onSaved: (val) {
        if (fieldKey == 'budget') {
          _jobData[fieldKey] = int.tryParse(val ?? '0') ?? 0;
        } else {
          _jobData[fieldKey] = val;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post a Job'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(label: 'Title', fieldKey: 'title'),
                  SizedBox(height: 16),
                  _buildTextField(label: 'Description', fieldKey: 'description'),
                  SizedBox(height: 16),
                  _buildTextField(label: 'Category', fieldKey: 'category'),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: 'Budget',
                    fieldKey: 'budget',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: _isLoading
                          ? SizedBox(
                              height: 30,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(Icons.send),
                      label: Text(_isLoading ? 'Posting...' : 'Post Job'),
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
