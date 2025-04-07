# nexus

Nexus is your all-in-one personal assistant app designed to simplify and streamline your daily life. Whether you need reminders, a secure place to store passwords, a hub for saving links, notes, and documents, or just an organized way to manage tasks, Nexus has you covered.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Nexus App Timetable Module

## Overview

The Timetable Module in Nexus provides a comprehensive system for viewing, managing, and creating timetables.

### Key Components:

1. **TimeTableView Widget**:

   - Displays the current time slot in a card format
   - Supports batch/group switching for practical and tutorial sessions
   - Shows time, faculty, location, and subject information

2. **TimeTableViewerScreen**:

   - Full timetable view separated by weekdays
   - Swipeable interface to navigate between days
   - Week day selector for quick navigation

3. **TimeTableManagerScreen**:
   - Create new timetables with department, year, and division information
   - Select from existing timetables stored locally
   - Edit or delete existing timetables
   - Toggle between local and cloud timetables

## Technical Implementation

### Data Storage:

- Uses Hive for local storage of timetables
- SharedPreferences for storing current timetable selection
- Data models designed with Hive adapters for efficient serialization

### State Management:

- BLoC/Cubit pattern for managing state across the application
- TimeTableManagerCubit: Manages the list of timetables and current selection
- TimeTableViewCubit: Handles the display of time slots and navigation
- TimeTableEditorCubit: Manages timetable creation and editing

### Clean Architecture:

- Domain layer: Entities and repository interfaces
- Data layer: Repository implementations and data sources
- Presentation layer: UI components and state management

## Getting Started

1. Initialize the dependency injection:

```dart
await DependencyInjection.init();
```

2. Access timetable views using:

```dart
Navigator.pushNamed(context, '/time-table-viewer');
```

3. Manage timetables using:

```dart
Navigator.pushNamed(context, '/time-table-manager');
```

4. Create or edit timetables using:

```dart
Navigator.pushNamed(context, '/time-table-editor');
```
