import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/lesson_model.dart';
import '../../../../core/services/firebase_service.dart';

// Schedule Provider
final scheduleProvider = AsyncNotifierProvider<ScheduleNotifier, List<Lesson>>(() {
  return ScheduleNotifier();
});

class ScheduleNotifier extends AsyncNotifier<List<Lesson>> {
  @override
  Future<List<Lesson>> build() async {
    return [];
  }

  // Load schedules
  Future<void> loadSchedules() async {
    state = const AsyncValue.loading();
    
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      final querySnapshot = await firebaseService.lessonsQuery().get();
      
      final lessons = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Lesson.fromJson(data);
      }).toList();
      
      state = AsyncValue.data(lessons);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Load schedules by center
  Future<void> loadSchedulesByCenter(String center) async {
    state = const AsyncValue.loading();
    
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      final querySnapshot = await firebaseService.lessonsByCenter(center).get();
      
      final lessons = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Lesson.fromJson(data);
      }).toList();
      
      state = AsyncValue.data(lessons);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Load schedules by date range
  Future<void> loadSchedulesByDateRange(DateTime start, DateTime end) async {
    state = const AsyncValue.loading();
    
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      final querySnapshot = await firebaseService.lessonsByDateRange(start, end).get();
      
      final lessons = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Lesson.fromJson(data);
      }).toList();
      
      state = AsyncValue.data(lessons);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Get today's lessons
  List<Lesson> getTodayLessons() {
    final today = DateTime.now();
    final todayLessons = state.value?.where((lesson) {
      return lesson.date.day == today.day &&
             lesson.date.month == today.month &&
             lesson.date.year == today.year;
    }).toList() ?? [];
    
    return todayLessons;
  }

  // Get upcoming lessons
  List<Lesson> getUpcomingLessons() {
    final now = DateTime.now();
    final upcomingLessons = state.value?.where((lesson) {
      return lesson.date.isAfter(now);
    }).toList() ?? [];
    
    return upcomingLessons;
  }

  // Get lessons by subject
  List<Lesson> getLessonsBySubject(String subject) {
    return state.value?.where((lesson) {
      return lesson.subject.toLowerCase().contains(subject.toLowerCase());
    }).toList() ?? [];
  }

  // Search lessons
  List<Lesson> searchLessons(String query) {
    if (query.isEmpty) return state.value ?? [];
    
    return state.value?.where((lesson) {
      return lesson.subject.toLowerCase().contains(query.toLowerCase()) ||
             lesson.center.toLowerCase().contains(query.toLowerCase()) ||
             lesson.teacherName?.toLowerCase().contains(query.toLowerCase()) == true;
    }).toList() ?? [];
  }
}

// Today's Schedule Provider
final todayScheduleProvider = Provider<List<Lesson>>((ref) {
  final scheduleNotifier = ref.watch(scheduleProvider.notifier);
  return scheduleNotifier.getTodayLessons();
});

// Upcoming Schedule Provider
final upcomingScheduleProvider = Provider<List<Lesson>>((ref) {
  final scheduleNotifier = ref.watch(scheduleProvider.notifier);
  return scheduleNotifier.getUpcomingLessons();
});

// Schedule Search Provider
final scheduleSearchProvider = StateProvider<String>((ref) => '');

final filteredScheduleProvider = Provider<List<Lesson>>((ref) {
  final schedules = ref.watch(scheduleProvider);
  final searchQuery = ref.watch(scheduleSearchProvider);
  
  return schedules.when(
    data: (lessons) {
      if (searchQuery.isEmpty) return lessons;
      
      return lessons.where((lesson) {
        return lesson.subject.toLowerCase().contains(searchQuery.toLowerCase()) ||
               lesson.center.toLowerCase().contains(searchQuery.toLowerCase()) ||
               lesson.teacherName?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

