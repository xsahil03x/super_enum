# 0.5.0

- Added support for optional data fields
  (https://github.com/xsahil03x/super_enum/issues/51)
  ```dart
  DataField<String>("errorMessage", required: false),
  ```
- Updated equatable to ^1.2.5

- Updated meta to ^1.2.3

# 0.4.2

- Fix for "Same @UseClass() generates the wrapper twice"
  (https://github.com/xsahil03x/super_enum/issues/42)

- Updated equatable to ^1.1.0

# 0.4.1

- Hotfix for "DataFields with a name including 'T' break code generation"
  (https://github.com/xsahil03x/super_enum/issues/39)

- Updated equatable to ^1.0.3

# 0.4.0

- Added support for generic data types `DataField<List<foo>>('foos')`
  eg : List, Map, BuiltList etc

- Added support for union types. `@UseClass()`

- Made the generated code more cohesive with generics.

- Bug fixes and improvements.

# 0.3.0

- Added two new 'whenX' methods.
  - whenOrElse
  - whenPartial

- Bug fixes and improvements.

# 0.2.0

- Make object classes singleton.

- Make Data classes Equatable
    * '=='
    * 'hashCode'
    * 'toString'

# 0.1.0

- Added a proper example.

# 0.0.1+1

- Fix homepage link.

# 0.0.1

- Initial Release.
