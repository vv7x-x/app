import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/announcement_model.dart';
import '../../../../core/services/firebase_service.dart';

// Announcement Provider
final announcementProvider = AsyncNotifierProvider<AnnouncementNotifier, List<Announcement>>(() {
  return AnnouncementNotifier();
});

class AnnouncementNotifier extends AsyncNotifier<List<Announcement>> {
  @override
  Future<List<Announcement>> build() async {
    return [];
  }

  // Load announcements
  Future<void> loadAnnouncements() async {
    state = const AsyncValue.loading();
    
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      final querySnapshot = await firebaseService.announcementsQuery().get();
      
      final announcements = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Announcement.fromJson(data);
      }).toList();
      
      state = AsyncValue.data(announcements);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Load announcements by type
  Future<void> loadAnnouncementsByType(AnnouncementType type) async {
    state = const AsyncValue.loading();
    
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      final querySnapshot = await firebaseService.announcementsByType(type.value).get();
      
      final announcements = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Announcement.fromJson(data);
      }).toList();
      
      state = AsyncValue.data(announcements);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Mark announcement as read
  Future<void> markAsRead(String announcementId) async {
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.updateDocument(
        FirebaseService.announcementsCollection,
        announcementId,
        {'isRead': true},
      );
      
      // Update local state
      final currentAnnouncements = state.value ?? [];
      final updatedAnnouncements = currentAnnouncements.map((announcement) {
        if (announcement.id == announcementId) {
          return announcement.copyWith(isRead: true);
        }
        return announcement;
      }).toList();
      
      state = AsyncValue.data(updatedAnnouncements);
    } catch (e) {
      // Handle error silently
    }
  }

  // Get important announcements
  List<Announcement> getImportantAnnouncements() {
    return state.value?.where((announcement) {
      return announcement.isImportant;
    }).toList() ?? [];
  }

  // Get unread announcements
  List<Announcement> getUnreadAnnouncements() {
    return state.value?.where((announcement) {
      return !announcement.isRead;
    }).toList() ?? [];
  }

  // Get announcements by type
  List<Announcement> getAnnouncementsByType(AnnouncementType type) {
    return state.value?.where((announcement) {
      return announcement.type == type;
    }).toList() ?? [];
  }

  // Search announcements
  List<Announcement> searchAnnouncements(String query) {
    if (query.isEmpty) return state.value ?? [];
    
    return state.value?.where((announcement) {
      return announcement.title.toLowerCase().contains(query.toLowerCase()) ||
             announcement.body.toLowerCase().contains(query.toLowerCase()) ||
             announcement.teacherName?.toLowerCase().contains(query.toLowerCase()) == true;
    }).toList() ?? [];
  }

  // Get recent announcements (last 7 days)
  List<Announcement> getRecentAnnouncements() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    return state.value?.where((announcement) {
      return announcement.timestamp.isAfter(weekAgo);
    }).toList() ?? [];
  }
}

// Important Announcements Provider
final importantAnnouncementsProvider = Provider<List<Announcement>>((ref) {
  final announcementNotifier = ref.watch(announcementProvider.notifier);
  return announcementNotifier.getImportantAnnouncements();
});

// Unread Announcements Provider
final unreadAnnouncementsProvider = Provider<List<Announcement>>((ref) {
  final announcementNotifier = ref.watch(announcementProvider.notifier);
  return announcementNotifier.getUnreadAnnouncements();
});

// Recent Announcements Provider
final recentAnnouncementsProvider = Provider<List<Announcement>>((ref) {
  final announcementNotifier = ref.watch(announcementProvider.notifier);
  return announcementNotifier.getRecentAnnouncements();
});

// Announcement Search Provider
final announcementSearchProvider = StateProvider<String>((ref) => '');

final filteredAnnouncementsProvider = Provider<List<Announcement>>((ref) {
  final announcements = ref.watch(announcementProvider);
  final searchQuery = ref.watch(announcementSearchProvider);
  
  return announcements.when(
    data: (announcements) {
      if (searchQuery.isEmpty) return announcements;
      
      return announcements.where((announcement) {
        return announcement.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
               announcement.body.toLowerCase().contains(searchQuery.toLowerCase()) ||
               announcement.teacherName?.toLowerCase().contains(searchQuery.toLowerCase()) == true;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Announcement Type Filter Provider
final announcementTypeFilterProvider = StateProvider<AnnouncementType?>((ref) => null);

final announcementsByTypeProvider = Provider<List<Announcement>>((ref) {
  final announcements = ref.watch(announcementProvider);
  final typeFilter = ref.watch(announcementTypeFilterProvider);
  
  return announcements.when(
    data: (announcements) {
      if (typeFilter == null) return announcements;
      
      return announcements.where((announcement) {
        return announcement.type == typeFilter;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Unread Count Provider
final unreadCountProvider = Provider<int>((ref) {
  final unreadAnnouncements = ref.watch(unreadAnnouncementsProvider);
  return unreadAnnouncements.length;
});

