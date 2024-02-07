// i feel like this is quite useless
mixin NamedEnum on Enum {
  @override
  String toString() => name;
}
