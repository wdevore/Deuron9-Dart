# proto1

A new Flutter project.

# Project creation
```sh
flutter create --platforms linux proto1
```

# JSON via serializable
```dart
dart run build_runner build --delete-conflicting-outputs
```

# Launch config
```json
        {
            "name": "Deuron9",
            "cwd": "Deuron9-Dart/proto1",
            "request": "launch",
            "type": "dart"
        },
```
Make sure you add */proto1* to the "cwd" key or it won't start and asks for a device.

# GUI
```
--------------------------------------------------
|---- graph ------------------|/  Tab  \/  Tab  \|
|                             |________|_________|
|                             |      Panel       |
|                             |                  |
|---- graph ------------------|__________________|
|                             |                  |
|                             |      Panel       |
|                             |                  |
|---- graph ------------------|__________________|
|...                          |                  |
--------------------------------------------------

```

Window size hack:

NOTE: This is just a hack because the *window_manager* package doesn't work on linux.

Modify the code in *linux/my_application.cc* and add ```*1.5```
```c
gtk_window_set_default_size(window, 1280*1.5, 720*1.5);
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Flutter
- https://api.flutter.dev/flutter/widgets/Stack-class.html
- https://api.flutter.dev/flutter/material/MenuBar-class.html
