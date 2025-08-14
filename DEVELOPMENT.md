# 🛠️ Development Guide

This guide provides detailed information for developers who want to contribute to or understand the Aflam project.

## 📋 Table of Contents
- [Project Structure](#-project-structure)
- [Development Setup](#-development-setup)
- [Architecture Overview](#-architecture-overview)
- [State Management](#-state-management)
- [API Integration](#-api-integration)
- [Database & Storage](#-database--storage)
- [UI Components](#-ui-components)
- [Testing Strategy](#-testing-strategy)
- [Performance Optimization](#-performance-optimization)
- [Code Standards](#-code-standards)

## 🏗️ Project Structure

```
aflam/
├── 📁 lib/
│   ├── 📁 core/                    # Core functionality
│   │   ├── 📁 models/              # Data models
│   │   │   ├── movie_model.dart    # Movie data structure
│   │   │   └── movie_model.g.dart  # Generated Hive adapters
│   │   ├── 📁 router/              # Navigation
│   │   │   └── app_router.dart     # GoRouter configuration
│   │   ├── 📁 secrets/             # Configuration
│   │   │   └── secrets.dart        # API keys and URLs
│   │   ├── 📁 services/            # External services
│   │   │   └── api.dart            # TMDB API client
│   │   └── 📁 theme/               # App theming
│   │       └── app_theme.dart      # Material Design theme
│   ├── 📁 features/                # Feature modules
│   │   ├── 📁 bottom_nav/          # Navigation component
│   │   ├── 📁 home/                # Home screen feature
│   │   │   ├── 📁 view/            # UI components
│   │   │   │   ├── 📁 screens/     # Screen widgets
│   │   │   │   └── 📁 widgets/     # Reusable widgets
│   │   │   └── 📁 view_model/      # Business logic
│   │   │       └── 📁 cubit/       # BLoC state management
│   │   ├── 📁 details/             # Movie details feature
│   │   └── 📁 marked/              # Favorites feature
│   └── main.dart                   # App entry point
├── 📁 assets/                      # Static assets
├── 📁 screenshots/                 # App screenshots
├── 📁 test/                        # Unit tests
├── pubspec.yaml                    # Dependencies
├── README.md                       # Project documentation
├── CHANGELOG.md                    # Version history
├── LICENSE                         # MIT License
└── DEVELOPMENT.md                  # This file
```

## 🚀 Development Setup

### Prerequisites
```bash
# Required versions
Flutter >= 3.8.1
Dart >= 3.0.0
Android Studio / VS Code
```

### Initial Setup
```bash
# 1. Clone the repository
git clone https://github.com/HossamAhmed954074/Aflam.git
cd aflam

# 2. Install dependencies
flutter pub get

# 3. Generate code (Hive adapters)
flutter packages pub run build_runner build

# 4. Configure API key in lib/core/secrets/secrets.dart
```

### Development Commands
```bash
# Run the app
flutter run

# Build for production
flutter build apk --release
flutter build ios --release

# Run tests
flutter test

# Analyze code
flutter analyze

# Generate code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Clean build
flutter clean && flutter pub get
```

## 🏛️ Architecture Overview

### Design Patterns
- **Feature-Based Architecture**: Organized by features rather than layers
- **BLoC Pattern**: Predictable state management with clear separation
- **Repository Pattern**: Abstract data layer for API and local storage
- **Dependency Injection**: Using Provider for dependency management

### Core Principles
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Dependency Inversion**: Depend on abstractions, not concretions
- **Clean Code**: Readable, maintainable, and testable code

## 🔄 State Management

### BLoC Implementation
```dart
// Cubit for simplified state management
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> fetchTopRatedMovies() async {
    emit(HomeLoading());
    try {
      final movieModel = await Api().getTopRatedMovies();
      emit(HomeLoaded(movieModel));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}

// State classes
abstract class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final MovieModel movieModel;
  HomeLoaded(this.movieModel);
}
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
```

### State Usage in UI
```dart
BlocConsumer<HomeCubit, HomeState>(
  listener: (context, state) {
    if (state is HomeError) {
      // Handle errors
    }
  },
  builder: (context, state) {
    if (state is HomeLoading) {
      return CircularProgressIndicator();
    }
    // Build UI based on state
  },
)
```

## 🌐 API Integration

### TMDB API Service
```dart
class Api {
  static const String baseUrl = "https://api.themoviedb.org/3";
  
  Future<MovieModel> getTopRatedMovies() async {
    final response = await http.get(
      Uri.parse("$baseUrl/trending/all/day?api_key=$apiKey"),
    );
    return MovieModel.fromJson(json.decode(response.body));
  }
}
```

### Error Handling
- Network timeouts
- API rate limiting
- Malformed responses
- Connection failures

## 💾 Database & Storage

### Hive Database Setup
```dart
// Model annotations
@HiveType(typeId: 0)
class MovieModel {
  @HiveField(0)
  List<Results>? results;
}

// Registration in main.dart
await Hive.initFlutter();
Hive.registerAdapter(MovieModelAdapter());
await Hive.openBox('favorites');
```

### Real-time Updates
```dart
ValueListenableBuilder(
  valueListenable: Hive.box('favorites').listenable(),
  builder: (context, Box<dynamic> box, _) {
    // UI updates automatically when box changes
    return ListView(
      children: box.values.map((item) => ListTile()).toList(),
    );
  },
)
```

## 🎨 UI Components

### Design System
- **Material Design 3**: Latest design guidelines
- **Consistent Spacing**: 8dp grid system
- **Typography**: Plus Jakarta Sans font family
- **Color Scheme**: Dark theme with accent colors

### Performance Optimizations
```dart
// Optimized image caching
CachedNetworkImage(
  imageUrl: imageUrl,
  memCacheWidth: 300,
  memCacheHeight: 450,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)

// Hero animations with unique tags
Hero(
  tag: 'movie_${movie.id}_${uniquePrefix}',
  child: Image.network(movie.posterUrl),
)
```

## 🧪 Testing Strategy

### Test Structure
```
test/
├── unit/           # Unit tests for business logic
├── widget/         # Widget tests for UI components
├── integration/    # Integration tests for features
└── mocks/          # Mock objects for testing
```

### Testing Guidelines
- **Unit Tests**: Test business logic in isolation
- **Widget Tests**: Verify UI components render correctly
- **Integration Tests**: Test complete user flows
- **Mocking**: Mock external dependencies (API, database)

## ⚡ Performance Optimization

### Image Optimization
- **Caching Strategy**: Memory and disk caching
- **Size Optimization**: Appropriate resolution selection
- **Lazy Loading**: Load images only when needed
- **Error Handling**: Graceful fallbacks for failed loads

### Memory Management
- **Widget Recycling**: Efficient ListView implementations
- **State Disposal**: Proper cleanup in dispose methods
- **Cache Limits**: Reasonable cache size limits
- **Memory Leaks**: Regular profiling and monitoring

### Network Optimization
- **Request Batching**: Combine related API calls
- **Caching Headers**: Respect HTTP cache headers
- **Timeout Handling**: Appropriate timeout values
- **Retry Logic**: Exponential backoff for failures

## 📝 Code Standards

### Naming Conventions
```dart
// Classes: PascalCase
class MovieDetailsScreen extends StatelessWidget {}

// Variables/Functions: camelCase
final movieList = <Movie>[];
void fetchMovies() {}

// Constants: camelCase with const
const apiBaseUrl = 'https://api.example.com';

// Private members: underscore prefix
String _privateVariable;
void _privateMethod() {}
```

### Code Organization
- **File Naming**: snake_case for file names
- **Import Order**: dart:core, dart:async, package:flutter, package:others, relative imports
- **Method Length**: Keep methods under 20 lines when possible
- **Class Size**: Single responsibility, reasonable size

### Documentation
```dart
/// Fetches trending movies from TMDB API
/// 
/// Returns a [MovieModel] containing the list of trending movies.
/// Throws an [Exception] if the API request fails.
Future<MovieModel> getTopRatedMovies() async {
  // Implementation
}
```

## 🔧 Build Configuration

### Development Build
```bash
flutter run --debug
```

### Production Build
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Environment Variables
- API keys should never be committed to version control
- Use environment-specific configuration files
- Implement proper secret management

## 🚀 Deployment

### Release Checklist
- [ ] Update version in pubspec.yaml
- [ ] Update CHANGELOG.md
- [ ] Run all tests
- [ ] Perform code analysis
- [ ] Test on different devices
- [ ] Generate release builds
- [ ] Update documentation

### Version Management
Follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Incompatible API changes
- **MINOR**: Backward-compatible functionality additions
- **PATCH**: Backward-compatible bug fixes

## 🤝 Contributing Guidelines

### Pull Request Process
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Update documentation
7. Submit a pull request

### Commit Message Format
```
type(scope): description

feat(home): add movie search functionality
fix(details): resolve hero animation conflicts
docs(readme): update installation instructions
```

---

**Happy Coding! 🚀**

For questions or support, please open an issue on GitHub.
