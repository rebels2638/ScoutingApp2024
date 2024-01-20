/// make the first letter of [input] uppercase, the rest lowercase
@pragma("vm:prefer-inline")
String formalizeWord(String input) => input.isNotEmpty
    ? input[0].toUpperCase() + input.substring(1).toLowerCase()
    : input;
