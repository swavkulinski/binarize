import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';


sealed class Serializable<T> {
  const Serializable(this.value);
  final T value;
  Uint8List get serialized;
}

class SerializedInt extends Serializable<int> {
  const SerializedInt(super.value);

  @override
  Uint8List get serialized => Uint8List(8) //
    ..buffer.asByteData().setInt64(0, value);
}

class SerializedDouble extends Serializable<double> {
  const SerializedDouble(super.value);

  @override
  Uint8List get serialized => Uint8List(8) //
    ..buffer.asByteData().setFloat64(0, value);
}

class SerializedString extends Serializable<String> {
  const SerializedString(super.value);

  @override
  Uint8List get serialized {
    final bytes = utf8.encode(value);
    return Uint8List(8 + bytes.length) //
      ..buffer.asByteData().setInt64(0, bytes.length)
      ..setAll(8, bytes);
  }
}

class SerializedBool extends Serializable<bool> {
  const SerializedBool(super.value);

  @override
  Uint8List get serialized => Uint8List(1) //
    ..buffer.asByteData().setInt8(0, value ? 1 : 0);
}

class SerialisedHashMap<K extends Serializable, V extends Serializable>
    extends Serializable<HashMap<K, V>> {
  const SerialisedHashMap(super.value);

  @override
  Uint8List get serialized {
    final entries = value.entries;
    final length = entries.length;
    final keyValues = entries.expand((entry) => [entry.key.serialized, entry.value.serialized]);
    final keyValuesTotalBufferLength = keyValues.fold<int>(0, (total, element) => total + element.length);
    return Uint8List(8 + keyValuesTotalBufferLength) //
      ..buffer.asByteData().setInt64(0, length)
      ..setAll(8, keyValues.expand((e) => e));
  }

  @override
  String toString() => 'SerialisedHashMap{value: $value}';
}

class SerializedBytes extends Serializable<Uint8List> {
  const SerializedBytes(super.value);

  @override
  Uint8List get serialized {
    final length = value.length;
    final lengthUint8List = Uint8List(8);
    lengthUint8List.buffer.asByteData().setInt64(0, length); //
    return Uint8List.fromList([...lengthUint8List, ...value]);
  }
}

