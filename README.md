# MemberwiseInitializer

Generates a public memberwise initializer for stored, non-static properties.

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
