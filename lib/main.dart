import 'package:flutter/material.dart';
import 'package:myapp/app.dart';
import 'package:myapp/features/common/viewmodels/theme_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const BibleScrollApp(),
    ),
  );
}
