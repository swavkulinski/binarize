import 'dart:collection';
import 'dart:typed_data';

import 'package:binarize/binarize.dart';

void main() {
  final e = ExampleClass(
    name: 'Iglo',
    isSafe: false,
    capacity: 56,
    magic: 1.23456,
    innerMember: InnerExampleClass(innerClassName: 'Mojo!'),
    someMap: HashMap.from({
      1:'a',
      2:'abc',
      5:'ha ha'
    })
  );
  print("Input object: $e\n");
  final resultBuffer = e.serialized();

  print("Binarized: $resultBuffer\n");

  final deser = ExampleClass.deserialize(SerdeBuffer(resultBuffer));

  print("Deserialized object: $deser");
}

class ExampleClass {
  ExampleClass({
    required this.name,
    required this.isSafe,
    required this.capacity,
    required this.magic,
    required this.innerMember,
    required this.someMap,
  });
  final String name;

  final bool isSafe;

  final int capacity;

  final double magic;

  final InnerExampleClass innerMember;

  final HashMap<int, String> someMap;

  static const _identifier = 100;

  factory ExampleClass.deserialize(SerdeBuffer buffer) {
    final identifier = DeserializedInt(buffer).value;
    if (identifier != _identifier) {
      throw Exception('Wrong buffer: Expected $_identifier, was $identifier');
    }

    final name = DeserializedString(buffer).value;
    final isSafe = DeserializedBool(buffer).value;
    final capacity = DeserializedInt(buffer).value;
    final magic = DeserializedDouble(buffer).value;
    final innerMember = InnerExampleClass.deserialize(buffer);
    final someMap = DeserializedHashMap<DeserializedInt, DeserializedString>(
      buffer,
      (buffer) => DeserializedInt(buffer),
      (buffer) => DeserializedString(buffer),
    ).value;

    return ExampleClass(
        name: name,
        isSafe: isSafe,
        capacity: capacity,
        magic: magic,
        innerMember: innerMember,
        someMap: HashMap.from(someMap.map((k, v) => MapEntry(k.value, v.value))));
  }

  Uint8List serialized() {
    final nameBuffer = SerializedString(name).serialized;
    final isSafeBuffer = SerializedBool(isSafe).serialized;
    final capacityBuffer = SerializedInt(capacity).serialized;
    final magicBuffer = SerializedDouble(magic).serialized;
    final innerMemberBuffer = innerMember.serialized();
    final someMapBuffer = SerialisedHashMap<SerializedInt, SerializedString>(
      HashMap.from(someMap.map((k, v) => MapEntry(SerializedInt(k), SerializedString(v))),
    )).serialized;

    return Uint8List.fromList([
      ...SerializedInt(_identifier).serialized,
      ...nameBuffer,
      ...isSafeBuffer,
      ...capacityBuffer,
      ...magicBuffer,
      ...innerMemberBuffer,
      ...someMapBuffer,
    ]);
  }

  @override
  String toString() =>
      'ExampleClass{name:\'$name\', isSafe: $isSafe, capacity: $capacity, magic: $magic, innerMember: $innerMember, someMap: $someMap}';
}

class InnerExampleClass {
  InnerExampleClass({required this.innerClassName});
  final String innerClassName;

  static const _identifier = 101;

  factory InnerExampleClass.deserialize(SerdeBuffer buffer) {
    final identifier = DeserializedByte(buffer).value;
    if (identifier != _identifier) {
      throw Exception('Wrong buffer: Expected $_identifier, was $identifier');
    }

    final innerClassName = DeserializedString(buffer).value;

    return InnerExampleClass(innerClassName: innerClassName);
  }

  Uint8List serialized() {
    final innerClassNameBuffer = SerializedString(innerClassName).serialized;

    return Uint8List.fromList([
      _identifier,
      ...innerClassNameBuffer,
    ]);
  }

  @override
  String toString() => 'InnerExampleClass{innerClassName:\'$innerClassName\'}';
}
