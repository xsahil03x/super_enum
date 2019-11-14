String getCamelCase(String text, {String separator = ''}) {
  List<String> words =
      _groupIntoWords(text).map(_upperCaseFirstLetter).toList();
  words[0] = words[0].toLowerCase();

  return words.join(separator);
}

String _upperCaseFirstLetter(String word) {
  return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
}

final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');
final RegExp _symbolRegex = RegExp(r'[ ./_\-]');

List<String> _groupIntoWords(String text) {
  StringBuffer sb = StringBuffer();
  List<String> words = [];
  bool isAllCaps = !text.contains(RegExp('[a-z]'));

  for (int i = 0; i < text.length; i++) {
    String char = String.fromCharCode(text.codeUnitAt(i));
    String nextChar = (i + 1 == text.length
        ? null
        : String.fromCharCode(text.codeUnitAt(i + 1)));

    if (_symbolRegex.hasMatch(char)) {
      continue;
    }

    sb.write(char);

    bool isEndOfWord = nextChar == null ||
        (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
        _symbolRegex.hasMatch(nextChar);

    if (isEndOfWord) {
      words.add(sb.toString());
      sb.clear();
    }
  }

  return words;
}
