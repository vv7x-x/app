import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();
  
  FirebaseService._();

  // Firebase instances
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseMessaging get messaging => FirebaseMessaging.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  // Collections
  static const String studentsCollection = 'students';
  static const String studentsPendingCollection = 'students_pending';
  static const String lessonsCollection = 'lessons';
  static const String attendanceCollection = 'attendance';
  static const String announcementsCollection = 'announcements';

  // Initialize Firebase
  Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // Firestore batch operations
  WriteBatch get batch => firestore.batch();

  // Collection references
  CollectionReference get studentsRef => firestore.collection(studentsCollection);
  CollectionReference get studentsPendingRef => firestore.collection(studentsPendingCollection);
  CollectionReference get lessonsRef => firestore.collection(lessonsCollection);
  CollectionReference get attendanceRef => firestore.collection(attendanceCollection);
  CollectionReference get announcementsRef => firestore.collection(announcementsCollection);

  // Document references
  DocumentReference studentDoc(String id) => studentsRef.doc(id);
  DocumentReference studentPendingDoc(String id) => studentsPendingRef.doc(id);
  DocumentReference lessonDoc(String id) => lessonsRef.doc(id);
  DocumentReference attendanceDoc(String id) => attendanceRef.doc(id);
  DocumentReference announcementDoc(String id) => announcementsRef.doc(id);

  // Query helpers
  Query studentsQuery() => studentsRef.orderBy('createdAt', descending: true);
  Query studentsPendingQuery() => studentsPendingRef.orderBy('createdAt', descending: true);
  Query lessonsQuery() => lessonsRef.orderBy('date', descending: false);
  Query attendanceQuery() => attendanceRef.orderBy('date', descending: true);
  Query announcementsQuery() => announcementsRef.orderBy('timestamp', descending: true);

  // Filtered queries
  Query lessonsByCenter(String center) => 
      lessonsRef.where('center', isEqualTo: center).orderBy('date', descending: false);
  
  Query lessonsByDateRange(DateTime start, DateTime end) => 
      lessonsRef.where('date', isGreaterThanOrEqualTo: start)
                .where('date', isLessThanOrEqualTo: end)
                .orderBy('date', descending: false);
  
  Query announcementsByType(String type) => 
      announcementsRef.where('type', isEqualTo: type)
                      .orderBy('timestamp', descending: true);
  
  Query attendanceByStudent(String studentId) => 
      attendanceRef.where('studentId', isEqualTo: studentId)
                   .orderBy('date', descending: true);

  // Real-time listeners
  Stream<QuerySnapshot> watchStudents() => studentsQuery().snapshots();
  Stream<QuerySnapshot> watchStudentsPending() => studentsPendingQuery().snapshots();
  Stream<QuerySnapshot> watchLessons() => lessonsQuery().snapshots();
  Stream<QuerySnapshot> watchAttendance() => attendanceQuery().snapshots();
  Stream<QuerySnapshot> watchAnnouncements() => announcementsQuery().snapshots();

  // Document streams
  Stream<DocumentSnapshot> watchStudent(String id) => studentDoc(id).snapshots();
  Stream<DocumentSnapshot> watchLesson(String id) => lessonDoc(id).snapshots();
  Stream<DocumentSnapshot> watchAnnouncement(String id) => announcementDoc(id).snapshots();

  // CRUD operations
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    await firestore.collection(collection).add(data);
  }

  Future<void> setDocument(String collection, String id, Map<String, dynamic> data) async {
    await firestore.collection(collection).doc(id).set(data);
  }

  Future<void> updateDocument(String collection, String id, Map<String, dynamic> data) async {
    await firestore.collection(collection).doc(id).update(data);
  }

  Future<void> deleteDocument(String collection, String id) async {
    await firestore.collection(collection).doc(id).delete();
  }

  Future<DocumentSnapshot> getDocument(String collection, String id) async {
    return await firestore.collection(collection).doc(id).get();
  }

  Future<QuerySnapshot> getCollection(String collection) async {
    return await firestore.collection(collection).get();
  }

  // Batch operations
  Future<void> commitBatch(WriteBatch batch) async {
    await batch.commit();
  }

  // Error handling
  String getErrorMessage(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'ليس لديك صلاحية للوصول إلى هذه البيانات';
        case 'not-found':
          return 'البيانات غير موجودة';
        case 'already-exists':
          return 'البيانات موجودة بالفعل';
        case 'invalid-argument':
          return 'البيانات المدخلة غير صحيحة';
        case 'unavailable':
          return 'الخدمة غير متاحة حالياً';
        case 'unauthenticated':
          return 'يجب تسجيل الدخول أولاً';
        default:
          return 'حدث خطأ: ${error.message}';
      }
    }
    return 'حدث خطأ غير متوقع';
  }
}

