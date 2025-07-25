import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_provider.dart';

class JobsScreen extends StatefulWidget {
  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    try {
      await jobProvider.fetchJobs();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load jobs')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);
    final jobs = jobProvider.jobs;

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Jobs'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : jobs.isEmpty
              ? Center(child: Text('No jobs available.'))
              : RefreshIndicator(
                  onRefresh: _fetchJobs,
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          title: Text(
                            job['title'] ?? 'Untitled Job',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                job['category'] ?? 'No category',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                job['description'] ?? 'No description provided',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Budget: KES ${job['budget'] ?? 'N/A'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 18),
                          onTap: () {
                            // TODO: Navigate to job details screen
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
