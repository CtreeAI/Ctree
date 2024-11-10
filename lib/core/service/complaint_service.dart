import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctree/core/models/complaint_model.dart';
import 'package:ctree/core/models/image_file.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ComplaintService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> getOrganizations() async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'Org')
        .get();

    return querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              'name': doc.data()['displayName'] ??
                  '', // Alterado de 'name' para 'displayName'
            })
        .toList();
  }

  Future<bool> createComplaint(
      ComplaintModel complaint, ImageFile? image) async {
    try {
      String? imageUrl;

      if (image != null) {
        final storageRef = _storage
            .ref()
            .child('complaints/${DateTime.now().millisecondsSinceEpoch}');

        if (image.isWeb) {
          await storageRef.putData(image.file);
        } else {
          await storageRef.putFile(image.file);
        }

        imageUrl = await storageRef.getDownloadURL();
      }

      final complaintData = complaint.toMap();
      if (imageUrl != null) {
        complaintData['imageUrl'] = imageUrl;
      }

      await _firestore.collection('complaints').add(complaintData);
      return true;
    } catch (e) {
      print('Error creating complaint: $e');
      return false;
    }
  }

  Stream<List<ComplaintModel>> getComplaints() {
    return _firestore
        .collection('complaints')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ComplaintModel.fromMap({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList());
  }
}
