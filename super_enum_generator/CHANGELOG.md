# 0.6.0
### BREAKING
- Part File naming has been changed to `filename.super.dart` from `filename.g.dart.

- Removed all `asyncWhenX` methods as they were redundant.

- Added support for analyzer > 0.40.0
  (https://github.com/xsahil03x/super_enum/issues/63)

- Added support for optional data fields
  (https://github.com/xsahil03x/super_enum/issues/51)

- Generate copyWith methods for Data Classes
  (https://github.com/xsahil03x/super_enum/issues/44)

- Removed method arguments for empty union types
  (https://github.com/xsahil03x/super_enum/issues/52)

- Fixed unhandled exception when using Generics
  (https://github.com/xsahil03x/super_enum/issues/22)

- Added support for docComments
  (https://github.com/xsahil03x/super_enum/issues/28)

# 0.5.0

- Generate separate async `whenX` methods for handling asynchronous calls.
   - asyncWhen
   - asyncWhenOrElse
  (https://github.com/xsahil03x/super_enum/issues/46)

- Fix for "use const constructor in object classes"
  (https://github.com/xsahil03x/super_enum/issues/41)

# 0.4.3

- Fix for "whenXXX methods return FutureOr"
       (https://github.com/xsahil03x/super_enum/issues/27)

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

# 0.2.0+1

- Set version range for 'analyzer' and 'build'
  for removing version compatibility issues.

# 0.2.0

- Make object classes singleton.

- Make Data classes Equatable
        * '=='
        * 'hashCode'
        * 'toString'

# 0.1.0

- Updated super_enum to v0.1.0.
- Added example.

# 0.0.1+1

- Fix homepage link.

# 0.0.1

- Initial Release.
