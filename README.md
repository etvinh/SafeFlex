# SafeFlex

Wearable rep tracker for physical therapy.

## About

SafeFlex is an iOS app that helps physical therapy patients track their exercise repetitions using wearable device data. Built with SwiftUI and SwiftData.

## Requirements

- Xcode 16+
- iOS 17+
- Swift 5.9+

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/etvinh/Safe_Flex.git
   ```
2. Open `SafeFlex/SafeFlex.xcodeproj` in Xcode.
3. Select a simulator or connected device.
4. Build and run (Cmd + R).

## Tech Stack

- **UI**: SwiftUI
- **Data Persistence**: SwiftData
- **Architecture**: MVVM

## Project Structure

```
SafeFlex/
├── SafeFlex/
│   ├── SafeFlexApp.swift    # App entry point
│   ├── ContentView.swift    # Main view
│   ├── Item.swift           # Data model
│   └── Assets.xcassets/     # App assets
├── SafeFlexTests/           # Unit tests
└── SafeFlexUITests/         # UI tests
```

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
