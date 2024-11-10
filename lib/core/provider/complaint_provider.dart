import 'package:ctree/core/models/complaint_model.dart';
import 'package:ctree/core/models/image_file.dart';
import 'package:ctree/core/service/complaint_service.dart';
import 'package:flutter/foundation.dart';

class ComplaintProvider extends ChangeNotifier {
  final ComplaintService _complaintService = ComplaintService();
  List<Map<String, dynamic>> _organizations = [];
  List<ComplaintModel> _complaints = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get organizations => _organizations;
  List<ComplaintModel> get complaints => _complaints;
  bool get isLoading => _isLoading;

  ComplaintProvider() {
    _loadOrganizations();
    _listenToComplaints();
  }

  Future<void> _loadOrganizations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _organizations = await _complaintService.getOrganizations();
    } catch (e) {
      print('Error loading organizations: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void _listenToComplaints() {
    _complaintService.getComplaints().listen(
      (complaints) {
        _complaints = complaints;
        notifyListeners();
      },
      onError: (error) {
        print('Error listening to complaints: $error');
      },
    );
  }

  Future<bool> createComplaint(
      ComplaintModel complaint, ImageFile? image) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _complaintService.createComplaint(complaint, image);
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
