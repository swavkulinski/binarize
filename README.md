

Binarize is a library for serialisation and deserialisation immutable Dart object. 

This library is in its initial iteration. It is highly discouraged to use it in production.

## Justification

Simple serialization into a bytestream is beneficial in following scenario where:

1) All serialization and deserialization happens in Dart
2) There is no need for keeping version negotiation of objects (like in Protobuf). For example frontend and backend is using same models and are deployed together.
3) It is essential to not send key - value pairs but just values. e.g. we want to save some bandwith or we want to make it harder to read.

In other cases I suggest you look for json (3rd point is not true), protobuf or similar ( 1st or/and 2nd points are not true).

## Features

It provides extensions to common types like `bool`, `byte`, `int`, `String`, `Uint8List`, `HashMap<K,V>` to convert them into encoded `Uint8List` and back.

## Usage

Examine and run example


```dart
dart run example/binarize_example.dart
```

Expected output should look like this:

```sh
ExampleClass{name:'Iglo', isSafe: false, capacity: 56, magic: 1.23456, innerMember: InnerExampleClass{innerClassName:'Mojo!'}, someMap: {1: a, 2: abc, 5: ha ha}}
[100, 0, 0, 0, 0, 0, 0, 0, 4, 73, 103, 108, 111, 0, 0, 0, 0, 0, 0, 0, 0, 56, 63, 243, 192, 193, 252, 143, 50, 56, 101, 0, 0, 0, 0, 0, 0, 0, 5, 77, 111, 106, 111, 33, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 104, 97, 32, 104, 97, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 3, 97, 98, 99, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 97]
ExampleClass{name:'Iglo', isSafe: false, capacity: 56, magic: 1.23456, innerMember: InnerExampleClass{innerClassName:'Mojo!'}, someMap: {1: a, 2: abc, 5: ha ha}}
```



## Serialisation

When serialising just one primitive there is no need to validate the type as long as you know what to expect in the deserializer. To create type check serialize the identifier as a first member. Identifier can be any type as long as deserialization will expect the same type. 

It is encouraged to use one selected type e.g. `int` for all identifiers in the project. This way we can avoid unlikely scenario where identifier was shorter or longer (e.g. byte vs int) and matched the check by accident.

### bool

Resulting list is 1 byte long. 1 indicates true, 0 indicates false

### int

Resulting list is always 9 bytes long. 0 takes type indicator equal 2, followed by 9 bytes of int

### String

Resulting list depends on the length of the string itself. Byte 0 takes type indicator equal 3, followed by int (9 bytes) indicating length of the string, then utf8 codes of the string itself.

### byte array

`Uint8List` is encoded to itself prepended with array length represented as `int`

### Hash map

`Hashmap<K,V>` allows only encoding static types for keys and values. First we encode the total length of all keys and values represented as a byte stream which is followed by pairs of encoded keys and values.

### Class

Serialization of objects starts with encoding class identifier. Identifier can be represented as in `int` or `byte` or any other primitive or class as long as `serialize()` and factory constructor `factory MyClass.deserialize(Uint8List data)` uses the same type.



