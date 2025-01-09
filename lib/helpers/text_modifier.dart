
class TextModifier {

  static String not(bool isNot, String Function(String not) statementBuilder) {
    return statementBuilder(isNot ? 'not' : '').replaceAll('  ', ' ');
  }
}