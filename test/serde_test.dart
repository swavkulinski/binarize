import 'dart:typed_data';

import 'package:binarize/binarize.dart';
import 'package:test/test.dart';

void main() {
  group('int serializer', () {
    test('serialize 0', () {
      final result = SerializedInt(0).serialized;
      expect(result[0], 0);
      expect(result[1], 0);
      expect(result[2], 0);
      expect(result[3], 0);
      expect(result[4], 0);
      expect(result[5], 0);
      expect(result[6], 0);
      expect(result[7], 0);
    });
    test('serialize 1', () {
      final result = SerializedInt(1).serialized;
      expect(result[0], 0);
      expect(result[1], 0);
      expect(result[2], 0);
      expect(result[3], 0);
      expect(result[4], 0);
      expect(result[5], 0);
      expect(result[5], 0);
      expect(result[6], 0);
      expect(result[7], 1);
    });

    test('serialize 256', () {
      final result = SerializedInt(256).serialized;
      expect(result[0], 0);
      expect(result[1], 0);
      expect(result[6], 1);
      expect(result[7], 0);
    });

    test('serialize 72057594037927936', () {
      final result = DeserializedInt(
          SerdeBuffer(Uint8List.fromList([1, 0, 0, 0, 0, 0, 0, 0]))).value;
      expect(result, 72057594037927936);
    });
  });

  group('int deserializer', () {
    test('deserialize 1', () {
      final result = DeserializedInt(
          SerdeBuffer(Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 1]))).value;
      expect(result, 1);
    });
    test('deserialize 256', () {
      final result = DeserializedInt(
          SerdeBuffer(Uint8List.fromList([0, 0, 0, 0, 0, 0, 1, 0]))).value;
      expect(result, 256);
    });
    test('deserialize 9223372036854775807', () {
      final result = DeserializedInt(SerdeBuffer(
          Uint8List.fromList([127, 255, 255, 255, 255, 255, 255, 255]))).value;
      expect(result, 9223372036854775807);
    });

    test('deserialize -9223372036854775808', () {
      final result = DeserializedInt(
          SerdeBuffer(Uint8List.fromList([128, 0, 0, 0, 0, 0, 0, 0]))).value;
      expect(result, -9223372036854775808);
    });

    test('deserialize -1', () {
      final result = DeserializedInt(SerdeBuffer(
          Uint8List.fromList([255, 255, 255, 255, 255, 255, 255, 255]))).value;
      expect(result, -1);
    });
    test('deserialize -2', () {
      final result = DeserializedInt(SerdeBuffer(
          Uint8List.fromList([255, 255, 255, 255, 255, 255, 255, 254]))).value;
      expect(result, -2);
    });
  });

  group('serialize string', () {
    test('serialize empty string', () {
      final result = SerializedString('').serialized;
      expect(result[0], 0);
      expect(result[1], 0);
      expect(result[2], 0);
      expect(result[3], 0);
      expect(result[4], 0);
      expect(result[5], 0);
      expect(result[6], 0);
      expect(result[7], 0);
    });

    test('serialize "a"', () {
      final result = SerializedString('a').serialized;
      expect(result[0], 0);
      expect(result[1], 0);
      expect(result[2], 0);
      expect(result[3], 0);
      expect(result[4], 0);
      expect(result[5], 0);
      expect(result[6], 0);
      expect(result[7], 1);
      expect(result[8], 97);
    });

    test('serialize "abc"', () {
      final result = SerializedString('abc').serialized;
      expect(result[0], 0);
      expect(result[1], 0);
      expect(result[2], 0);
      expect(result[3], 0);
      expect(result[4], 0);
      expect(result[5], 0);
      expect(result[6], 0);
      expect(result[7], 3);
      expect(result[8], 97);
      expect(result[9], 98);
      expect(result[10], 99);
    });
  });

  group('deserialize string', () {
    test('deserialize empty string', () {
      final result = DeserializedString(
          SerdeBuffer(Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]))).value;
      expect(result, '');
    });

    test('deserialize "a"', () {
      final result = DeserializedString(
          SerdeBuffer(Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 1, 97]))).value;
      expect(result, 'a');
    });

    test('deserialize "abc"', () {
      final result = DeserializedString(SerdeBuffer(
          Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 3, 97, 98, 99]))).value;
      expect(result, 'abc');
    });
  });

  group('serialize bool', () {
    test('serialize true', () {
      final result = SerializedBool(true).serialized;
      expect(result[0], 1);
    });

    test('serialize false', () {
      final result = SerializedBool(false).serialized;
      expect(result[0], 0);
    });
  });

  group('deserialize bool', () {
    test('deserialize true', () {
      final result =
          DeserializedBool(SerdeBuffer(Uint8List.fromList([1]))).value;
      expect(result, true);
    });

    test('deserialize false', () {
      final result =
          DeserializedBool(SerdeBuffer(Uint8List.fromList([0]))).value;
      expect(result, false);
    });
  });

  group('serialize double', () {
    test('serialize 0.0', () {
      final result = SerializedDouble(0.0).serialized;
      expect(result[0], 0);
      expect(result[1], 0);
      expect(result[2], 0);
      expect(result[3], 0);
      expect(result[4], 0);
      expect(result[5], 0);
      expect(result[6], 0);
      expect(result[7], 0);
    });

    test('serialize 1.0', () {
      final result = SerializedDouble(1.0).serialized;
      expect(result[0], 63);
      expect(result[1], 240);
      expect(result[2], 0);
      expect(result[3], 0);
      expect(result[4], 0);
      expect(result[5], 0);
      expect(result[6], 0);
      expect(result[7], 0);
    });

    test('serialize 1.5', () {
      final result = SerializedDouble(1.5).serialized;
      expect(result[0], 63);
      expect(result[1], 248);
      expect(result[2], 0);
      expect(result[3], 0);
      expect(result[4], 0);
      expect(result[5], 0);
      expect(result[6], 0);
      expect(result[7], 0);
    });

    test('serialize -1.5', () {
      final result = SerializedDouble(-1.5).serialized;
      expect(result[0], 191);
      expect(result[1], 248);
      expect(result[2], 0);
      expect(result[3], 0);
      expect(result[4], 0);
      expect(result[5], 0);
      expect(result[6], 0);
      expect(result[7], 0);
    });
  });

  group('deserialize double', () {
    test('deserialize 0.0', () {
      final result = DeserializedDouble(
          SerdeBuffer(Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]))).value;
      expect(result, 0.0);
    });

    test('deserialize 1.0', () {
      final result = DeserializedDouble(
          SerdeBuffer(Uint8List.fromList([63, 240, 0, 0, 0, 0, 0, 0]))).value;
      expect(result, 1.0);
    });

    test('deserialize 1.5', () {
      final result = DeserializedDouble(
          SerdeBuffer(Uint8List.fromList([63, 248, 0, 0, 0, 0, 0, 0]))).value;
      expect(result, 1.5);
    });

    test('deserialize -1.5', () {
      final result = DeserializedDouble(
          SerdeBuffer(Uint8List.fromList([191, 248, 0, 0, 0, 0, 0, 0]))).value;
      expect(result, -1.5);
    });
  });

  group('serialize bytes', () {
    test('serialize empty bytes', () {
      final result = SerializedBytes(Uint8List(0)).serialized;
      expect(result[0], 0);
      expect(result[1], 0);
      expect(result[2], 0);
      expect(result[3], 0);
      expect(result[4], 0);
      expect(result[5], 0);
      expect(result[6], 0);
      expect(result[7], 0);
      expect(result.length, 8);

    });

    test('serialize bytes', () {
      final result = SerializedBytes(Uint8List.fromList([1, 2, 3])).serialized;
      expect(result[0], 0);
      expect(result[1], 0);
      expect(result[2], 0);
      expect(result[3], 0);
      expect(result[4], 0);
      expect(result[5], 0);
      expect(result[6], 0);
      expect(result[7], 3);
      expect(result[8], 1);
      expect(result[9], 2);
      expect(result[10], 3);
      expect(result.length, 11);
    });
  });

  group('deserialize bytes', () {
    test('deserialize empty bytes', () {
      final result = DeserializedBytes(
          SerdeBuffer(Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]))).value;
      expect(result, Uint8List(0));
    });

    test('deserialize bytes', () {
      final result = DeserializedBytes(SerdeBuffer(
          Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 3, 1, 2, 3]))).value;
      expect(result, Uint8List.fromList([1, 2, 3]));
    });
  });
}
