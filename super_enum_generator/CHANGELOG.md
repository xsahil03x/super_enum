0.4.3

    1. Fix for "whenXXX methods return FutureOr"
       (https://github.com/xsahil03x/super_enum/issues/27)

0.4.2

    1. Fix for "Same @UseClass() generates the wrapper twice"
       (https://github.com/xsahil03x/super_enum/issues/42)

    2. Updated equatable to ^1.1.0

0.4.1

    1. Hotfix for "DataFields with a name including 'T' break code generation"
       (https://github.com/xsahil03x/super_enum/issues/39)

    2. Updated equatable to ^1.0.3

0.4.0

    1. Added support for generic data types `DataField<List<foo>>('foos')`
       eg : List, Map, BuiltList etc

    2. Added support for union types. `@UseClass()`

    3. Made the generated code more cohesive with generics.

    4. Bug fixes and improvements.

0.3.0
    
    1. Added two new 'whenX' methods.
        - whenOrElse
        - whenPartial
    
    2. Bug fixes and improvements.

0.2.0+1
    
    Set version range for 'analyzer' and 'build' 
    for removing version compatibility issues.

0.2.0

    1. Make object classes singleton.
    
    2. Make Data classes Equatable 
        * '=='
        * 'hashCode'
        * 'toString'

0.1.0
       
    * Updated super_enum to v0.1.0.
    * Added example.
    
0.0.1+1

    Fix homepage link.

0.0.1

    Initial Release.
