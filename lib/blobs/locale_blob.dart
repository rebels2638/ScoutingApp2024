/// make the first letter of [input] uppercase, the rest lowercase
@pragma("vm:prefer-inline")
String formalizeWord(String input) => input.isNotEmpty
    ? input[0].toUpperCase() + input.substring(1).toLowerCase()
    : input;

@pragma("vm:prefer-inline")
String stringClampFromRight(String input, int limit) =>
    input.length > limit ? input.substring(0, limit) : input;

@pragma("vm:prefer-inline")
String collateListString(List<String> str, [String separate = "\n"]) {
  StringBuffer buff = StringBuffer();
  for (String r in str) {
    buff.write(r);
    buff.write(separate);
  }
  return buff.toString();
}
