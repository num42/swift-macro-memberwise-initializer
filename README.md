# MemberwiseInitializer

Generates a public memberwise initializer for stored, non-static properties.

## Requirements

- Swift 6.3 toolchain or later (tested with Xcode 27)
- Platforms: macOS 14, iOS 13, tvOS 13, watchOS 6, macCatalyst 13

## Usage

```swift
@MemberwiseInitializer
struct User {
  let id: UUID
  let name: String
}

// Generated:
// public init(id: UUID, name: String)
```

## Notes

Computed properties and static properties are ignored.
