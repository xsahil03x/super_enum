import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:super_enum/super_enum.dart';


TypeChecker _typeChecker(Type t) => TypeChecker.fromRuntime(t);

String dataFieldType(obj) {
  String type;
  if( ConstantReader(obj).instanceOf(_typeChecker(DataField))){
    type = ConstantReader(obj).read('type').typeValue.toString();
  }
  else if( ConstantReader(obj).instanceOf(_typeChecker(DataList))){
   type = "List<${ConstantReader(obj).read('intrinsicType').typeValue.toString()}>";
  }
  else if( ConstantReader(obj).instanceOf(_typeChecker(DataMap))){
    final keyType = ConstantReader(obj).read('keyType').typeValue.toString();
    final valueType = ConstantReader(obj).read('valueType').typeValue.toString();
    type = "Map<$keyType,$valueType>";
  }

  return type;
}

String dataFieldName(obj) => ConstantReader(obj).read('name').stringValue;

ConstantReader annotationOf<T>(obj) =>
    ConstantReader(_typeChecker(T).firstAnnotationOfExact(obj));

ConstantReader fieldOf<T>(obj, String fieldName) =>
    annotationOf<T>(obj)?.read(fieldName);

Iterable listTypeFieldOf<T>(obj, String fieldName) =>
    fieldOf<T>(obj, fieldName)?.listValue ?? [];

bool hasAnnotation<T>(obj) => _typeChecker(T).hasAnnotationOfExact(obj);

bool isGeneric(Element element) =>
    _typeChecker(Generic).hasAnnotationOfExact(element);
