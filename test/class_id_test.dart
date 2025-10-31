import 'dart:typed_data';

import 'package:binarize/binarize.dart';
import 'package:test/test.dart';

void main() {
  group('class identification', (){
    test('class id is 1 and it is read correctly and deserialization works aftewards', () {
      final t = TestClass1(1, 'a');
      final buffer = t.serialized();
      final serde = SerdeBuffer(buffer);
      final classId = serde.classId();
      expect(classId, 1);

      final deserialized = TestClass1.deserialize(serde);
      expect(deserialized.value, 1);
      expect(deserialized.text, 'a');
      expect(serde.pointer, buffer.length);
    });
    test('class id is 256 and it is read correctly and deserialization works aftewards', () {
      final t = TestClass2(1, 'a');
      final buffer = t.serialized();
      final serde = SerdeBuffer(buffer);
      final classId = serde.classId();
      expect(classId, 256);

      final deserialized = TestClass2.deserialize(serde);
      expect(deserialized.value, 1);
      expect(deserialized.text, 'a');
      expect(serde.pointer, buffer.length);
    });
  });
}


class TestClass1 {
  TestClass1(this.value, this.text);
  final int value;
  final String text;

  static const _identifier = 1;

  Uint8List serialized() {
    final valueBuffer = SerializedInt(value).serialized;
    final textBuffer = SerializedString(text).serialized;

    return Uint8List.fromList([
      ...SerializedInt(_identifier).serialized,
      ...valueBuffer,
      ...textBuffer,
    ]);
  }

  factory TestClass1.deserialize(SerdeBuffer buffer) {
    final identifier = DeserializedInt(buffer).value;
    if (identifier != _identifier) {
      throw Exception('Wrong buffer: Expected $_identifier, was $identifier');
    } 

    final value = DeserializedInt(buffer).value;
    final text = DeserializedString(buffer).value;

    return TestClass1(value, text);
  }
}

class TestClass2 {
  TestClass2(this.value, this.text);
  final int value;
  final String text;

  static const _identifier = 256;

  Uint8List serialized() {
    final valueBuffer = SerializedInt(value).serialized;
    final textBuffer = SerializedString(text).serialized;

    return Uint8List.fromList([
      ...SerializedInt(_identifier).serialized,
      ...valueBuffer,
      ...textBuffer,
    ]);
  }

  factory TestClass2.deserialize(SerdeBuffer buffer) {
    final identifier = DeserializedInt(buffer).value;
    if (identifier != _identifier) {
      throw Exception('Wrong buffer: Expected $_identifier, was $identifier');
    } 

    final value = DeserializedInt(buffer).value;
    final text = DeserializedString(buffer).value;

    return TestClass2(value, text);
  }
}
