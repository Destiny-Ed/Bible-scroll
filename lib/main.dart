import 'package:flutter/material.dart';
import 'package:myapp/app.dart';
import 'package:myapp/features/common/viewmodels/theme_view_model.dart';
import 'package:myapp/features/home/viewmodels/feed_view_model.dart';
import 'package:myapp/features/plan/view_model/reading_plan_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FeedViewModel()),
        ChangeNotifierProvider(create: (context) => ReadingPlanViewModel()),
      ],
      child: const BibleScrollApp(),
    ),
  );
}
