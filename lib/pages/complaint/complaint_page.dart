import 'package:cached_network_image/cached_network_image.dart';
import 'package:ctree/core/models/complaint_degree.dart';
import 'package:ctree/core/styles/app_colors.dart';
import 'package:ctree/pages/auth/data/auth_repository.dart';
import 'package:ctree/pages/feed/components/filters/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ctree/core/provider/complaint_provider.dart';
import 'package:ctree/core/models/complaint_model.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({Key? key}) : super(key: key);

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  String _authorId = '';
  String _authorName = '';
  String? _selectedDegree;

  Future<void> _getCurrentUser() async {
    final currentUser = AuthRepository.currentUserModel;
    if (currentUser != null) {
      setState(() {
        _authorId = currentUser.uuid;
        _authorName = currentUser.displayName;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  List<ComplaintModel> getFilteredComplaints(List<ComplaintModel> complaints) {
    if (_selectedDegree == null) return complaints;
    return complaints
        .where((complaint) => complaint.degree == _selectedDegree)
        .toList();
  }

  void _onDegreeSelected(String? degree) {
    setState(() {
      _selectedDegree = degree;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ComplaintProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final userComplaints = provider.complaints
              .where((complaint) => complaint.orgId == _authorId)
              .toList();
          final filteredComplaints = getFilteredComplaints(userComplaints);

          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: filteredComplaints.isEmpty
                      ? const Center(child: Text('No complaints found'))
                      : ListView.builder(
                          itemCount: filteredComplaints.length,
                          itemBuilder: (context, index) {
                            final complaint = filteredComplaints[index];
                            return ComplaintComponent(complaint: complaint);
                          },
                        ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter by Degree',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilterButton(
                      label: 'All',
                      isSelected: _selectedDegree == null,
                      onTap: () => _onDegreeSelected(null),
                    ),
                    const SizedBox(height: 8),
                    FilterButton(
                      label: 'Low',
                      isSelected: _selectedDegree == ComplaintDegree.low.label,
                      onTap: () => _onDegreeSelected(ComplaintDegree.low.label),
                    ),
                    const SizedBox(height: 8),
                    FilterButton(
                      label: 'Medium',
                      isSelected:
                          _selectedDegree == ComplaintDegree.medium.label,
                      onTap: () =>
                          _onDegreeSelected(ComplaintDegree.medium.label),
                    ),
                    const SizedBox(height: 8),
                    FilterButton(
                      label: 'High',
                      isSelected: _selectedDegree == ComplaintDegree.high.label,
                      onTap: () =>
                          _onDegreeSelected(ComplaintDegree.high.label),
                    ),
                    const SizedBox(height: 8),
                    FilterButton(
                      label: 'Urgent',
                      isSelected:
                          _selectedDegree == ComplaintDegree.urgent.label,
                      onTap: () =>
                          _onDegreeSelected(ComplaintDegree.urgent.label),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ComplaintComponent extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintComponent({Key? key, required this.complaint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Complaint image
          if (complaint.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: CachedNetworkImage(
                imageUrl: complaint.imageUrl,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/teste.jpg',
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Complaint title
                Text(
                  complaint.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Complaint description
                Text(
                  complaint.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                // Complaint location
                if (complaint.location.isNotEmpty)
                  Text(
                    'Location: ${complaint.location}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 8),
                // Complaint degree
                Text(
                  'Degree: ${complaint.degree}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                // Complaint creation date
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Date: ${_formatDate(complaint.createdAt)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year.toString()} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
