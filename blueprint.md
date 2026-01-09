# BibleScroll App Blueprint

## Overview

BibleScroll is a mobile application designed to provide users with a modern and engaging way to read and interact with the Bible. The app features a vertical, scrollable feed of biblical content, daily reading plans, and a personal library for saving content.

## Style and Design

- **Theme:** Modern, clean, and visually appealing with a focus on readability.
- **Color Palette:** A deep purple as the primary color, with a light and dark theme for user preference.
- **Typography:** `Work Sans` for a clean and modern feel.
- **Iconography:** Material Design icons for consistency.
- **Layout:** Card-based layout for a structured and organized presentation of content.
- **Navigation:** Bottom navigation bar for easy access to the main sections of the app.

## Features

### Core

- **Authentication:** Firebase authentication with Google Sign-In.
- **Theme Toggle:** Light and dark mode support.
- **Bottom Navigation:** Easy navigation between Home, Discover, Plan, Library, and Profile.

### Screens

- **Splash Screen:** A new, more engaging splash screen with the app's logo.
- **Onboarding Screen:** Introduction to the app and its features.
- **Home (Feed) Screen:** Main screen with a vertical feed of biblical content.
- **Discover Screen:** A screen to discover new content and topics, including a list of books of the Bible.
- **Daily Reading Plan Screen:** A screen to track and follow a daily reading plan.
- **Library Screen:** A personal library with saved videos and bookmarked chapters.
- **Profile Screen:** User profile with options to edit profile, view reading plan, and access the library.
- **Settings Screen:** App settings, including a theme toggle.
- **Edit Profile Screen:** A screen to edit user profile information.
- **Reading Detail Screen:** A screen to read a specific chapter of the Bible and add reflections.
- **Video Player Screen:** A screen to play videos.
- **Book List Screen:** A screen that displays a list of all the books in the Bible.
- **Chapter List Screen:** A screen that displays a list of chapters for a selected book.

## Current Plan

- **Objective:** Create a new, more engaging splash screen.
- **Steps:**
  1. Create a new `SplashScreen` widget.
  2. Add a logo to the assets and declare it in `pubspec.yaml`.
  3. Set the `SplashScreen` as the initial route of the app.
  4. Update the `blueprint.md` file.
  5. Verify the app by running `flutter pub get` and `flutter analyze`.
