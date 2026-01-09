# Bible Scroll App Blueprint

## Overview

This document outlines the architecture, features, and design of the Bible Scroll application, a Flutter-based mobile app designed for an immersive and interactive Bible study experience.

## Core Features

*   **Interactive Feed:** A vertical scrolling feed of short, engaging video clips related to biblical themes, similar to TikTok or Instagram Reels.
*   **Daily Reading Plan:** A structured plan to guide users through daily scripture readings.
*   **User Profile:** A personal space for users to track their progress, manage their library, and edit their profile.
*   **Theming:** A modern, customizable theme with support for both light and dark modes.

## Project Structure

The project follows a feature-based architecture, with each feature encapsulated in its own directory. This promotes modularity and scalability.

```
lib/
├── app.dart
├── features/
│   ├── common/
│   │   ├── viewmodels/
│   │   │   └── theme_view_model.dart
│   │   └── widgets/
│   ├── discover/
│   │   ├── models/
│   │   │   └── video_model.dart
│   │   ├── views/
│   │   │   ├── chapter_detail_screen.dart
│   │   │   └── discover_screen.dart
│   │   └── widgets/
│   │       ├── comments_modal_sheet.dart
│   │       └── video_card.dart
│   ├── home/
│   │   ├── views/
│   │   │   └── feed_screen.dart
│   │   └── widgets/
│   │       └── video_card.dart
│   ├── plan/
│   │   └── views/
│   │       └── daily_reading_plan_screen.dart
│   └── user/
│       ├── views/
│       │   ├── edit_profile_screen.dart
│       │   ├── profile_screen.dart
│       │   └── settings_screen.dart
├── main.dart
└── shared/
    └── widgets/
        └── video_player_widget.dart
```

## UI and Design

The application employs a modern and visually appealing design, adhering to Material Design 3 principles. Key design elements include:

*   **Typography:** A clean and readable font scheme using Google Fonts.
*   **Color Palette:** A vibrant and engaging color palette with distinct light and dark themes.
*   **Iconography:** Intuitive icons to enhance user interaction and navigation.
*   **Video Cards:** Custom-designed video cards with interactive elements like play/pause, like, comment, and share buttons.

## State Management

The application utilizes the `provider` package for state management, with a `ChangeNotifier` to manage the application's theme.

