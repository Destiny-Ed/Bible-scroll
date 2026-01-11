import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/app.dart';
import 'package:myapp/features/authentication/viewmodels/auth_viewmodel.dart';
import 'package:myapp/features/bible_reading/services/bible_service.dart';
import 'package:myapp/features/bible_reading/viewmodels/reading_view_model.dart';
import 'package:myapp/features/common/viewmodels/theme_view_model.dart';
import 'package:myapp/features/home/viewmodels/feed_view_model.dart';
import 'package:myapp/features/home/viewmodels/video_player_viewmodel.dart';
import 'package:myapp/features/plan/view_model/reading_plan_view_model.dart';
import 'package:myapp/features/user/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive once
  await BibleService.initHive();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FeedViewModel()),
        ChangeNotifierProvider(create: (context) => ReadingPlanViewModel()),
        ChangeNotifierProvider(create: (context) => VideoPlayerViewModel()),
        ChangeNotifierProvider(
          create: (_) => BibleReadingViewModel(BibleService()),
        ),
      ],
      child: const BibleScrollApp(),
    ),
  );
}
