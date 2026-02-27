import 'package:isbn_searcher/isbn_searcher.dart';
import 'package:isbn_searcher/src/isbn_search_response.dart';
import 'package:test/test.dart';

void main() {
  group('ISBNElement', () {
    test('normalizes empty fields with defaults', () {
      final element = ISBNElement(' ', ' ', ' ', ' ', ' ');

      expect(element.title, 'Unknown');
      expect(element.author, 'Unknown');
      expect(element.publishDate, 'Unknown');
      expect(element.isbn10, 'N/A');
      expect(element.isbn13, 'N/A');
    });

    test('creates notFound model', () {
      final element = ISBNElement.notFound('9780000000000');

      expect(element.title, 'Cannot find ISBN!');
      expect(element.isbn13, '9780000000000');
      expect(element.isbn10, '*');
    });

    test('escapes html in table row', () {
      final element = ISBNElement('A <Book>', 'Me & You', '2026', '123', '456');

      final row = element.toTableRow();
      expect(row, contains('&lt;Book&gt;'));
      expect(row, contains('Me &amp; You'));
    });
  });

  group('Extensions', () {
    test('compileArrayInString joins non-empty values', () {
      final authors = <String>['John', ' ', 'Jane'];
      expect(authors.compileArrayInString(), 'John, Jane');
      expect((null as List<String>?).compileArrayInString(), '');
    });

    test('makeHtmlTable builds valid table wrapper', () {
      final html = [
        ISBNElement('Book', 'Author', '2026', '123', '456'),
      ].makeHtmlTable();

      expect(html, contains('<table>'));
      expect(html, contains('<th>ISBN-13</th>'));
      expect(html, contains('<td>456</td>'));
    });
  });

  group('ISBNSearchResponse parser', () {
    test('parses book info from html', () async {
      const sampleHtml = '''
<!DOCTYPE html>
<html>
  <body>
    <div class="bookinfo">
      <h1>Example Book</h1>
      <p><strong>Author:</strong> Jane Doe</p>
      <p><strong>ISBN-13:</strong> <a>9781234567890</a></p>
      <p><strong>ISBN-10:</strong> <a>1234567890</a></p>
      <p><strong>Published:</strong> 2024</p>
    </div>
  </body>
</html>
''';

      final element = await ISBNSearchResponse.parseBookInfo(
        sampleHtml,
        fallbackIsbn: 'fallback',
      );

      expect(element.title, 'Example Book');
      expect(element.author, 'Jane Doe');
      expect(element.isbn13, '9781234567890');
      expect(element.isbn10, '1234567890');
      expect(element.publishDate, '2024');
    });

    test('returns notFound for empty html', () async {
      final element = await ISBNSearchResponse.parseBookInfo(
        '   ',
        fallbackIsbn: '9789999999999',
      );

      expect(element.title, 'Cannot find ISBN!');
      expect(element.isbn13, '9789999999999');
    });
  });
}
