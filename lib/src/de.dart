import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

class SerdeBuffer {
  SerdeBuffer(this.buffer);

  SerdeBuffer.fromString(String str) : buffer = Uint8List.fromList(utf8.encode(str));

  final Uint8List buffer;

  int pointer = 0;

  int get length => buffer.length - pointer;

  ByteData yield(int length) {
    final b = ByteData(length);
    b.buffer.asUint8List().setAll(0, buffer.skip(pointer).take(length));
    pointer += length;
    return b;
  }

}

sealed class Deserializable<T> {
  const Deserializable(this.value);
  final T value;
}

class DeserializedByte extends Deserializable<int> {
  DeserializedByte(SerdeBuffer buffer) : super(buffer.yield(1).getInt8(0));
}

class DeserializedInt extends Deserializable<int> {
  DeserializedInt(SerdeBuffer buffer) : super(buffer.yield(8).getInt64(0));
}

class DeserializedDouble extends Deserializable<double> {
  DeserializedDouble(SerdeBuffer buffer) : super(buffer.yield(8).getFloat64(0));
}

class DeserializedString extends Deserializable<String> {
  DeserializedString(SerdeBuffer buffer) : super(_parser(buffer));

  static String _parser(SerdeBuffer buffer) {
    final length = DeserializedInt(buffer).value;
    return utf8.decode(buffer.yield(length).buffer.asUint8List());
  }
}

class DeserializedBool extends Deserializable<bool> {
  DeserializedBool(SerdeBuffer buffer) : super(buffer.yield(1).buffer.asUint8List().first == 1);
}

class DeserializedObject<T> extends Deserializable<T> {
  DeserializedObject(T Function(Uint8List) deserializer, Uint8List buffer)
      : super(deserializer(buffer));
}

class DeserializedHashMap<K extends Deserializable, V extends Deserializable>
    extends Deserializable<HashMap<K, V>> {
  DeserializedHashMap(SerdeBuffer buffer, K Function(SerdeBuffer) kDeserializer,
      V Function(SerdeBuffer) vDeserializer)
      : super(_deserializer(buffer, kDeserializer, vDeserializer));

  static HashMap<K, V> _deserializer<K extends Deserializable, V extends Deserializable>(
      SerdeBuffer buffer,
      K Function(SerdeBuffer) kDeserializer,
      V Function(SerdeBuffer) vDeserializer) {
    final length = DeserializedInt(buffer).value;
    final map = HashMap<K, V>();
    for (var i = 0; i < length; i++) {
      final key = kDeserializer(buffer);
      final value = vDeserializer(buffer);
      map[key] = value;
    }
    return map;
  }
}

class DeserializedBytes extends Deserializable<Uint8List> {
  DeserializedBytes(SerdeBuffer buffer) : super(_deserializer(buffer));

  static Uint8List _deserializer(SerdeBuffer buffer) {
    final length = DeserializedInt(buffer).value;
    return buffer.yield(length).buffer.asUint8List();
  }
}

