import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:myapp/app.dart';
import 'package:myapp/features/admin/viewmodels/admin_viewmodel.dart';
import 'package:myapp/features/authentication/viewmodels/auth_viewmodel.dart';
import 'package:myapp/features/bible_reading/services/bible_service.dart';
import 'package:myapp/features/bible_reading/viewmodels/reading_view_model.dart';
import 'package:myapp/features/common/viewmodels/theme_view_model.dart';
import 'package:myapp/features/discover/viewmodels/discover_viewmodel.dart';
import 'package:myapp/features/home/viewmodels/feed_view_model.dart';
import 'package:myapp/features/home/viewmodels/video_player_viewmodel.dart';
import 'package:myapp/features/library/viewmodels/library_viewmodel.dart';
import 'package:myapp/features/plan/view_model/daily_reading_plan_view.dart';
import 'package:myapp/features/plan/view_model/reading_plan_view_model.dart';
import 'package:myapp/features/user/models/user_model.dart';
import 'package:myapp/features/user/viewmodels/profile_viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive once
  await initHive();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FeedViewModel()),
        ChangeNotifierProvider(create: (context) => ReadingPlanViewModel()),
        ChangeNotifierProvider(create: (context) => VideoPlayerViewModel()),
        ChangeNotifierProvider(create: (context) => LibraryViewModel()),
        ChangeNotifierProvider(create: (context) => AdminViewModel()),
        ChangeNotifierProvider(create: (context) => DiscoverViewModel()),
        ChangeNotifierProvider(
          create: (context) => DailyReadingPlanViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BibleReadingViewModel(BibleService()),
        ),
      ],
      child: const BibleScrollApp(),
    ),
  );
}

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  // Register adapters if needed (for complex types)
  // Hive.registerAdapter(VideoAdapter()); // if Video becomes HiveObject

  // Open boxes
  await Hive.openBox<List<dynamic>>('feedVideos');
  await Hive.openBox<List<dynamic>>('likedVideos');
  await Hive.openBox<List<dynamic>>('bookmarkedVideos');
  await Hive.openBox<UserModel>('userProfile'); // optional
}
