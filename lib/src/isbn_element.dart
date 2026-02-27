import 'dart:convert';

class ISBNElement {
  ISBNElement(
    String title,
    String author,
    String publishDate,
    String isbnTen,
    String isbnThirteen,
  )   : title = _normalizeField(title, fallback: 'Unknown'),
        author = _normalizeField(author, fallback: 'Unknown'),
        publishDate = _normalizeField(publishDate, fallback: 'Unknown'),
        isbn10 = _normalizeField(isbnTen, fallback: 'N/A'),
        isbn13 = _normalizeField(isbnThirteen, fallback: 'N/A');

  final String title;
  final String author;
  final String publishDate;
  final String isbn10;
  final String isbn13;

  // Legacy aliases for API parity with .NET version naming.
  // ignore: non_constant_identifier_names
  String get Title => title;
  // ignore: non_constant_identifier_names
  String get Author => author;
  // ignore: non_constant_identifier_names
  String get PublishDate => publishDate;
  // ignore: non_constant_identifier_names
  String get ISBN_10 => isbn10;
  // ignore: non_constant_identifier_names
  String get ISBN_13 => isbn13;

  static ISBNElement notFound(String isbn) {
    return ISBNElement('Cannot find ISBN!', '*', '*', '*', isbn);
  }

  String toTableRow() {
    return '<tr><td>${htmlEscape.convert(isbn13)}</td><td>${htmlEscape.convert(title)}</td><td>${htmlEscape.convert(author)}</td></tr>';
  }

  @override
  String toString() {
    String row(String label, String value) {
      return '║ ${label.padRight(9)} : ${value.padRight(22)}║';
    }

    return [
      '╔════════════════════════════════════╗',
      '║           Book Details            ║',
      '╠════════════════════════════════════╣',
      row('Title', title),
      row('Author', author),
      row('ISBN-13', isbn13),
      row('ISBN-10', isbn10),
      row('Published', publishDate),
      '╚════════════════════════════════════╝',
    ].join('\n');
  }

  static String _normalizeField(String input, {required String fallback}) {
    final normalized = input.trim();
    return normalized.isEmpty ? fallback : normalized;
  }
}
