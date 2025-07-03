import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  Future<String> uploadImage(File image, String userId) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await storageRef.putFile(image);
    return await storageRef.getDownloadURL();
  }

  Future<void> savePrediction({
    required String userId,
    required String model,
    required String predictedClass,
    required double confidence,
    required String imageUrl,
  }) async {
    await FirebaseFirestore.instance.collection('predictions').add({
      'user_id': userId,
      'model': model,
      'predicted_class': predictedClass,
      'confidence': confidence,
      'image_url': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
