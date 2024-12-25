

Tom-Dick-Harry is a library for serialisation and deserialisation


## Features

It provides extensions to common types like `int`, `bool`, `String` to convert them into `Uint8List` and back.

## Usage

Here are some examples


```dart
const serialised1 = 1.serialize;
const serializedTrue = true.serialize;
const serializedAbc = 'abc'.serialize;

const deserialised1 = Uint8List.fromList([0,1,0,0,0,0,0,0,0]).desInt;
const deserializedAbc Uint8List.fromList([1,]).desString;
```



## Serialisation

Byte at index 0 indicates type. 0 for `int`, 1 for `String` with the exception of bool where 255 indicates bool true, and 254 indicates bool false

### bool

Resulting list is 1 byte long. 1 indicates true, 0 indicates false

### int

Resulting list is always 9 bytes long. 0 takes type indicator equal 2, followed by 9 bytes of int

### String

Resulting list depends on the length of the string itself. Byte 0 takes type indicator equal 3, followed by int (9 bytes) indicating length of the string, then utf8 codes of the string itself.

