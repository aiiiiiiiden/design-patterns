# Flutter Development Rules for Claude Code

This document provides comprehensive guidelines for Flutter development optimized for use with Claude Code. These rules are adapted from the official Flutter AI rules documentation.

## Core Principles

You are an expert in Flutter and Dart development. Build beautiful, performant, and maintainable applications following modern best practices with expert experience in application writing, testing, and running Flutter applications for desktop, web, and mobile platforms.

### Development Philosophy
- **SOLID Principles:** Apply throughout the codebase
- **Concise and Declarative:** Write modern, technical Dart code with functional and declarative patterns
- **Composition over Inheritance:** Favor composition for building complex widgets and logic
- **Immutability:** Prefer immutable data structures; widgets (especially `StatelessWidget`) should be immutable
- **Separation of Concerns:** UI logic separate from business logic

## Project Structure

- **Standard Structure:** Assume `lib/main.dart` as the primary application entry point
- **Logical Layers:** Organize into:
  - Presentation (widgets, screens)
  - Domain (business logic classes)
  - Data (model classes, API clients)
  - Core (shared classes, utilities, extension types)
- **Feature-based Organization:** For larger projects, organize by feature with own presentation, domain, and data subfolders

## Code Quality Standards

### Naming and Style
- **Line length:** 80 characters or fewer
- **Classes:** `PascalCase`
- **Members/variables/functions/enums:** `camelCase`
- **Files:** `snake_case`
- **No abbreviations:** Use meaningful, consistent, descriptive names
- **Conciseness:** Code should be as short as possible while remaining clear

### Functions and Methods
- **Single purpose:** Functions should have one purpose
- **Length:** Strive for less than 20 lines
- **Arrow syntax:** Use for simple one-line functions

### Code Organization
- **Related classes:** Define within the same library file
- **Large libraries:** Export smaller, private libraries from a single top-level library
- **Library grouping:** Group related libraries in the same folder

### Error Handling
- **Anticipate errors:** Don't let code fail silently
- **Try-catch blocks:** Use for handling exceptions
- **Custom exceptions:** Use for situations specific to your code
- **Robust async handling:** Ensure proper `async`/`await` error handling

### Testing Mindset
- Write code with testing in mind
- Use `file`, `process`, and `platform` packages for dependency injection
- Allow in-memory and fake versions of objects for testing

## Dart Best Practices

### Type System
- **Null Safety:** Write soundly null-safe code
- **Avoid `!`:** Only use when value is guaranteed non-null
- **Pattern Matching:** Use where it simplifies code
- **Records:** Use to return multiple types when defining a class is cumbersome
- **Exhaustive switch:** Prefer exhaustive `switch` statements/expressions (no `break` needed)

### Async Programming
- **Futures:** Use `Future`, `async`, `await` for single asynchronous operations
- **Streams:** Use for sequences of asynchronous events
- **Proper error handling:** Always handle errors in async code

### Documentation
- **API documentation:** Add `dartdoc` comments to all public APIs (classes, constructors, methods, top-level functions)
- **Comment wisely:** Explain *why*, not *what* (code should be self-explanatory)
- **No trailing comments:** Avoid trailing comments
- **Style:** Use `///` for doc comments
- **First sentence:** Start with concise, user-centric summary ending with period
- **Avoid redundancy:** Don't repeat obvious information
- **Use backticks:** Enclose code in backticks with language specified

## Flutter Best Practices

### Widget Development
- **Immutability:** Widgets (especially `StatelessWidget`) are immutable
- **Composition:** Prefer composing smaller widgets over extending existing ones
- **Private widgets:** Use small, private `Widget` classes instead of private helper methods returning `Widget`
- **Break down build():** Split large `build()` methods into smaller, reusable private Widget classes
- **Const constructors:** Use whenever possible to reduce rebuilds

### Performance
- **List performance:** Use `ListView.builder` or `SliverList` for long lists (lazy-loaded)
- **Isolates:** Use `compute()` for expensive calculations to avoid blocking UI thread (e.g., JSON parsing)
- **Build method performance:** Avoid expensive operations (network calls, complex computations) in `build()` methods

### Layout Best Practices
- **Rows and Columns:**
  - `Expanded`: Fill remaining space along main axis
  - `Flexible`: Shrink to fit but not necessarily grow
  - `Wrap`: Prevent overflow by moving to next line
- **Scrollable content:**
  - `SingleChildScrollView`: For fixed-size content larger than viewport
  - `ListView`/`GridView`: Always use `.builder` constructor
- **Responsive layouts:** Use `LayoutBuilder` or `MediaQuery`
- **Stack positioning:**
  - `Positioned`: Precisely place by anchoring to edges
  - `Align`: Position using alignments like `Alignment.center`
- **Overlays:** Use `OverlayPortal` for UI elements "on top" of everything

## State Management

**Prefer Flutter's built-in solutions.** Do not use third-party packages unless explicitly requested.

### Built-in State Management

**ValueNotifier** for simple, local state (single value):
```dart
final ValueNotifier<int> _counter = ValueNotifier<int>(0);

ValueListenableBuilder<int>(
  valueListenable: _counter,
  builder: (context, value, child) => Text('Count: $value'),
);
```

**ChangeNotifier** for complex or shared state:
- Use `ChangeNotifier` for state shared across multiple widgets
- Use `ListenableBuilder` to listen to changes

**Streams and Futures:**
- `Streams` with `StreamBuilder`: Sequence of asynchronous events
- `Futures` with `FutureBuilder`: Single asynchronous operation

### Architecture Patterns
- **MVVM:** Use Model-View-ViewModel pattern when robust solution needed
- **Dependency Injection:** Use simple manual constructor DI to make dependencies explicit
- **Provider:** Only use if explicitly requested for DI beyond manual constructor injection

### Data Flow
- **Data structures:** Define classes to represent application data
- **Data abstraction:** Abstract data sources using Repositories/Services for testability

## Package Management

### Using Pub Tool
- **Search packages:** Use `pub_dev_search` tool if available, otherwise search pub.dev
- **Add dependency:** `flutter pub add <package_name>`
- **Add dev dependency:** `flutter pub add dev:<package_name>`
- **Add override:** `flutter pub add override:<package_name>:1.0.0`
- **Remove dependency:** `dart pub remove <package_name>`
- **External packages:** Identify most suitable and stable package from pub.dev

## Navigation and Routing

### GoRouter (Recommended)
```dart
// 1. Add dependency: flutter pub add go_router

// 2. Configure router
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'details/:id',
          builder: (context, state) {
            final String id = state.pathParameters['id']!;
            return DetailScreen(id: id);
          },
        ),
      ],
    ),
  ],
);

// 3. Use in MaterialApp
MaterialApp.router(routerConfig: _router);
```

**Authentication redirects:** Configure `redirect` property for auth flows

### Built-in Navigator
Use for short-lived, non-deep-linkable screens (dialogs, temporary views):
```dart
// Push
Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailsScreen()));

// Pop
Navigator.pop(context);
```

## Data Handling

### JSON Serialization
Use `json_serializable` and `json_annotation`:
```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String firstName;
  final String lastName;

  User({required this.firstName, required this.lastName});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

### Code Generation
- **Build Runner:** Ensure listed as dev dependency in `pubspec.yaml`
- **Run generation:** `dart run build_runner build --delete-conflicting-outputs`

## Logging

Use `log` from `dart:developer` for structured logging:
```dart
import 'dart:developer' as developer;

// Simple messages
developer.log('User logged in successfully.');

// Error logging
try {
  // ... code
} catch (e, s) {
  developer.log(
    'Failed to fetch data',
    name: 'myapp.network',
    level: 1000, // SEVERE
    error: e,
    stackTrace: s,
  );
}
```

## Testing

### Running Tests
- Use `run_tests` tool if available, otherwise `flutter test`
- **Unit tests:** `package:test`
- **Widget tests:** `package:flutter_test`
- **Integration tests:** `package:integration_test`

### Testing Best Practices
- **Convention:** Follow Arrange-Act-Assert (Given-When-Then) pattern
- **Unit tests:** For domain logic, data layer, state management
- **Widget tests:** For UI components
- **Integration tests:** For end-to-end user flows
- **Mocks:** Prefer fakes/stubs over mocks; if necessary use `mockito` or `mocktail`
- **Assertions:** Prefer `package:checks` for expressive assertions over default `matchers`
- **Coverage:** Aim for high test coverage

## Visual Design and Theming

### UI Design Principles
- **Beautiful interfaces:** Follow modern design guidelines
- **Responsiveness:** Adapt to different screen sizes (mobile and web)
- **Navigation:** Provide intuitive navigation bar/controls
- **Typography:** Emphasize font sizes for hierarchy (hero text, headlines, keywords)
- **Background:** Apply subtle noise texture for premium feel
- **Shadows:** Multi-layered drop shadows for depth
- **Icons:** Enhance understanding and logical navigation
- **Interactive elements:** Use shadows and elegant color for "glow" effect

### Theming Best Practices

**Material 3 with ThemeData:**
```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 14.0, height: 1.4),
    ),
  ),
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
  ),
  themeMode: ThemeMode.system, // Can be dynamically controlled
);
```

**Key theming features:**
- **ColorScheme.fromSeed():** Generate harmonious palette from single seed color
- **Light and Dark themes:** Support both with `theme` and `darkTheme`
- **Component themes:** Customize `elevatedButtonTheme`, `cardTheme`, `appBarTheme`, etc.
- **Theme toggle:** Dynamically control with `ThemeMode.light`, `ThemeMode.dark`, `ThemeMode.system`

### Custom Theme Extension
```dart
@immutable
class MyColors extends ThemeExtension<MyColors> {
  const MyColors({required this.success, required this.danger});

  final Color? success;
  final Color? danger;

  @override
  ThemeExtension<MyColors> copyWith({Color? success, Color? danger}) {
    return MyColors(success: success ?? this.success, danger: danger ?? this.danger);
  }

  @override
  ThemeExtension<MyColors> lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) return this;
    return MyColors(
      success: Color.lerp(success, other.success, t),
      danger: Color.lerp(danger, other.danger, t),
    );
  }
}

// Register in ThemeData
theme: ThemeData(
  extensions: const <ThemeExtension<dynamic>>[
    MyColors(success: Colors.green, danger: Colors.red),
  ],
),

// Use in widget
Container(color: Theme.of(context).extension<MyColors>()!.success)
```

### Widget State Styling
```dart
final ButtonStyle myButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.pressed)) return Colors.green;
      return Colors.red;
    },
  ),
);
```

### Typography
**Custom fonts with google_fonts:**
```dart
// Add dependency: flutter pub add google_fonts

final TextTheme appTextTheme = TextTheme(
  displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
  titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
  bodyMedium: GoogleFonts.openSans(fontSize: 14),
);
```

**Font best practices:**
- **Limit families:** 1-2 font families max
- **Legibility:** Sans-serif for UI body text
- **Line height:** 1.4x to 1.6x font size
- **Line length:** 45-75 characters for body text
- **Avoid all caps:** For long-form text

### Color Scheme Guidelines

**Accessibility (WCAG 2.1):**
- **Normal text:** 4.5:1 contrast ratio minimum
- **Large text:** 3:1 contrast ratio minimum (18pt or 14pt bold)

**60-30-10 Rule:**
- 60% Primary/Neutral (dominant)
- 30% Secondary
- 10% Accent

**Example palette:**
- Primary: #0D47A1 (Dark Blue)
- Secondary: #1976D2 (Medium Blue)
- Accent: #FFC107 (Amber)
- Neutral/Text: #212121 (Almost Black)
- Background: #FEFEFE (Almost White)

### Assets and Images

**Declaration in pubspec.yaml:**
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

**Local images:**
```dart
Image.asset('assets/images/placeholder.png')
```

**Network images:**
```dart
Image.network(
  'https://example.com/image.png',
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return const Center(child: CircularProgressIndicator());
  },
  errorBuilder: (context, error, stackTrace) {
    return const Icon(Icons.error);
  },
)
```

**Cached images:** Use `cached_network_image` package

## Linting and Analysis

**analysis_options.yaml:**
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Add additional lint rules here
```

Use `analyze_files` tool to run linter

## Tools and Formatting

- **dart_format:** Ensure consistent code formatting
- **dart_fix:** Automatically fix common errors and conform to analysis options
- **build_runner:** For code generation tasks

## API Design (for Libraries)

- **User-centric:** Design from user perspective; should be intuitive
- **Documentation is essential:** Clear, concise with examples
- **Consider the user:** Make APIs easy to use correctly

## User Interaction Guidelines

- **Assume familiarity:** User knows programming but may be new to Dart
- **Explain Dart features:** Provide explanations for null safety, futures, streams
- **Clarify ambiguity:** Ask for clarification on functionality and target platform
- **Explain dependencies:** When suggesting new packages, explain benefits
- **Target platform:** Clarify if request is for command-line, web, or server

---

## Quick Reference Checklist

### Before Writing Code
- [ ] Understand target platform (mobile, web, desktop)
- [ ] Choose appropriate state management (ValueNotifier, ChangeNotifier, Streams)
- [ ] Plan feature-based structure for larger projects
- [ ] Identify required packages from pub.dev

### While Writing Code
- [ ] Use `const` constructors wherever possible
- [ ] Keep functions under 20 lines
- [ ] Write null-safe code, avoid `!`
- [ ] Use `ListView.builder` for long lists
- [ ] Separate UI logic from business logic
- [ ] Use composition over inheritance
- [ ] Apply proper error handling

### After Writing Code
- [ ] Run `dart_format` for formatting
- [ ] Run `dart_fix` to fix common errors
- [ ] Use `analyze_files` for linting
- [ ] Write tests (unit, widget, integration)
- [ ] Run `build_runner` if using code generation
- [ ] Add `dartdoc` comments to public APIs
- [ ] Verify responsive design on different screen sizes

### For Production
- [ ] Implement both light and dark themes
- [ ] Ensure WCAG accessibility standards
- [ ] Add proper loading and error states for async operations
- [ ] Include meaningful images with proper licensing
- [ ] Test on target platforms (iOS, Android, web, desktop)
- [ ] Achieve high test coverage
- [ ] Review performance (no expensive operations in build methods)