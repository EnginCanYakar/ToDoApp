import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Task ekleme işlemi
  static Future<void> addTask(
      String title, String description, DateTime dueDate, String dueTime) {
    return FirebaseFirestore.instance.collection('tasks').add({
      'title': title,
      'description': description,
      'createdAt': Timestamp.now(),
      'dueDate': Timestamp.fromDate(dueDate), // Dönüşüm yapıldı
      'dueTime': dueTime,
    });
  }

  static Future<void> updateTask(String taskId, String title,
      String description, DateTime dueDate, String dueTime) {
    return FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate), // Dönüşüm yapıldı
      'dueTime': dueTime,
    });
  }
}
