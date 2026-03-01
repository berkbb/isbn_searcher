import 'dart:convert';

/// Represents a book item with its core information (title, author, etc).
class ISBNElement {
  /// Creates a new [ISBNElement] using the provided strings.
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

  /// The book's title.
  final String title;

  /// The author(s) of the book.
  final String author;

  /// The publication date of the book.
  final String publishDate;

  /// The 10-digit ISBN of the book.
  final String isbn10;

  /// The 13-digit ISBN of the book.
  final String isbn13;

  // Legacy aliases for API parity with .NET version naming.

  /// Deprecated. Use [title] instead.
  // ignore: non_constant_identifier_names
  String get Title => title;

  /// Deprecated. Use [author] instead.
  // ignore: non_constant_identifier_names
  String get Author => author;

  /// Deprecated. Use [publishDate] instead.
  // ignore: non_constant_identifier_names
  String get PublishDate => publishDate;

  /// Deprecated. Use [isbn10] instead.
  // ignore: non_constant_identifier_names
  String get ISBN_10 => isbn10;

  /// Deprecated. Use [isbn13] instead.
  // ignore: non_constant_identifier_names
  String get ISBN_13 => isbn13;

  /// Creates a fallback [ISBNElement] denoting that the given [isbn] was not found.
  static ISBNElement notFound(String isbn) {
    return ISBNElement('Cannot find ISBN!', '*', '*', '*', isbn);
  }

  /// Converts this element into an HTML table row (`<tr>`).
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
