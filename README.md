# Flutter Bloc Clean Architecture Boilerplate

A production-ready Flutter boilerplate built for enterprise-scale applications. Implements Clean Architecture with BLoC pattern, comprehensive testing strategies, and robust dependency management. Designed for maintainable, scalable codebases that handle complex business logic and large development teams. Features offline-first architecture, type-safe routing, and functional programming patterns for predictable, testable code.

---

## 🚀 Getting Started

### 1. Clone the Repo

```sh
git clone https://github.com/mylzdev/flutter-bloc-boilerplate.git
cd boilerplate
```

### 2. Upgrade All Packages

```sh
flutter pub upgrade --major-versions
flutter pub get
```
- Fix any version issues as needed (see `pubspec.yaml`).

### 3. Rename the Project

- Change the app name, description, and package/bundle ID.
- Change the `lib/src/app/app_boilerplate`

#### a. Edit `pubspec.yaml`

```yaml
name: your_project_name
description: "Your project description."
```

#### b. Use [rename](https://pub.dev/packages/rename) package

```sh
dart pub global activate rename
rename setBundleId --value com.yourdomain.appname
rename setAppName --value "Your App Name"
```

### 4. Activate and Use index_generator

- [index_generator](https://pub.dev/packages/index_generator) auto-generates barrel files for easier imports.

```sh
dart pub global activate index_generator
dart run index_generator
```
- Configured in `index_generator.yaml` (already set up for all major folders).

---

## 🛠️ Customization

### Theming

- Edit `lib/src/config/theme/app_theme.dart` and `widget/text_theme.dart` for color schemes and text styles.
- Colors: `lib/src/config/constant/colors.dart`
- Sizes: `lib/src/config/constant/sizes.dart`

---

## Dependencies

**logger**: Structured logging with configurable levels and formatting

**equatable**: Value equality comparison, reduces boilerplate for object comparisons

**json_annotation**: Code generation annotations for JSON serialization

**get_it**: Service locator for dependency injection and singleton management

**dartz**: Functional programming utilities (Either, Option) for clean error handling

**flutter_bloc**: State management implementing BLoC pattern with predictable transitions

**go_router**: Declarative routing with deep linking and type-safe navigation

## Dev Dependencies

**flutter_test**: Flutter testing framework for widgets and integration tests

**flutter_lints**: Static analysis rules for code quality

**bloc_test**: Testing utilities for BLoC state management

**mocktail**: Mocking library for unit testing

**build_runner**: Code generation tool for annotations

**go_router_builder**: Auto-generates route definitions

**json_serializable**: Code generator for JSON serialization

### Clean Architecture Pattern

This project follows Clean Architecture principles with three main layers:

#### 1. Data Layer
The outermost layer handling data operations and external dependencies.

```
data/
├── data.dart (exports)
├── datasources/
│   ├── remote_data_source.dart
│   └── local_data_source.dart
├── models/
│   └── feature_model.dart
└── repositories/
    └── feature_repository_impl.dart
```

Key components:
- `data.dart`: Exports all data layer components
- `datasources/`: Handles data fetching from APIs and local storage
- `models/`: Data transfer objects (DTOs) that map JSON to Dart objects
- `repositories/`: Implements repository interfaces from domain layer

#### 2. Domain Layer
The core business logic layer, independent of any framework or external concerns.

```
domain/
├── domain.dart (exports)
├── entities/
│   └── feature_entity.dart
├── repositories/
│   └── feature_repository.dart
└── usecases/
    └── get_feature_usecase.dart
```

Key components:
- `domain.dart`: Exports all domain layer components
- `entities/`: Core business objects
- `repositories/`: Abstract repository interfaces
- `usecases/`: Business logic encapsulated in single-responsibility classes

#### 3. Presentation Layer
Handles UI and state management using BLoC pattern.

```
presentation/
├── presentation.dart (exports)
├── pages/
│   └── feature_page.dart
├── widgets/
│   └── feature_widget.dart
└── blocs/
    ├── feature_bloc.dart
    ├── feature_event.dart
    └── feature_state.dart
```

Key components:
- `presentation.dart`: Exports all presentation layer components
- `pages/`: Full screens/pages
- `widgets/`: Reusable UI components
- `blocs/`: State management using BLoC pattern
  - `bloc.dart`: Business Logic Component
  - `event.dart`: User actions/events
  - `state.dart`: UI states

#### Layer Dependencies
```
Presentation → Domain ← Data
```

- Presentation depends on Domain
- Data depends on Domain
- Domain has no dependencies on other layers
- Data and Presentation never interact directly

#### Key Principles:
1. **Dependency Rule**: Dependencies point inward
2. **Separation of Concerns**: Each layer has specific responsibilities
3. **Testability**: Each layer can be tested independently
4. **Maintainability**: Changes in one layer don't affect others
5. **Scalability**: Easy to add new features without modifying existing code

#### Example Flow:
1. User action → Event in BLoC
2. BLoC calls UseCase
3. UseCase calls Repository
4. Repository Implementation fetches data
5. Data flows back up through the layers
6. BLoC emits new State
7. UI updates based on State

### Test-Driven Development (TDD)

This project follows Test-Driven Development principles with a "Red-Green-Refactor" cycle:

1. **Red**: Write a failing test first
2. **Green**: Write minimal code to make the test pass
3. **Refactor**: Clean up the code while keeping tests green

#### Test Coverage Requirements:
- Unit Tests: 100% coverage for domain layer
- Integration Tests: Critical business flows
- Widget Tests: All reusable widgets
- BLoC Tests: All state management logic

#### Running Tests:
```bash
# Run all tests
flutter test
```

## Feature Generator

This project includes a feature generator CLI tool that helps you quickly scaffold new features following clean architecture principles.

### Usage

To generate a new feature, run:

```bash
dart run bin/generate_feature.dart feature_name
```
