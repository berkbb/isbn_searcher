import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

import 'isbn_element.dart';

class ISBNSearchResponse {
  static final http.Client _httpClient = http.Client();

  static Future<String> getHtmlFromIsbnSearch(String isbn) async {
    final url = Uri.parse('https://isbnsearch.org/isbn/$isbn');
    final response = await _httpClient.get(url);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw http.ClientException(
        'isbnsearch.org request failed: ${response.statusCode}',
        url,
      );
    }

    return response.body;
  }

  static Future<ISBNElement> parseBookInfo(
    String html, {
    String fallbackIsbn = '*',
  }) async {
    if (html.trim().isEmpty) {
      return ISBNElement.notFound(fallbackIsbn);
    }

    try {
      final doc = html_parser.parse(html);
      final bookInfo = doc.querySelector('div.bookinfo');
      final title = bookInfo?.querySelector('h1')?.text.trim() ?? '';
      if (title.isEmpty) {
        return ISBNElement.notFound(fallbackIsbn);
      }

      String readLabeledValue(String label) {
        final paragraphs = bookInfo?.querySelectorAll('p') ?? const [];
        for (final paragraph in paragraphs) {
          final text = paragraph.text.trim();
          if (text.toLowerCase().startsWith(label.toLowerCase())) {
            return text.substring(label.length).trim();
          }
        }
        return '';
      }

      final isbn13Link = bookInfo
          ?.querySelectorAll('p')
          .where((p) => p.text.toLowerCase().contains('isbn-13:'))
          .firstOrNull
          ?.querySelector('a')
          ?.text
          .trim();

      final isbn10Link = bookInfo
          ?.querySelectorAll('p')
          .where((p) => p.text.toLowerCase().contains('isbn-10:'))
          .firstOrNull
          ?.querySelector('a')
          ?.text
          .trim();

      final author = readLabeledValue('Author:');
      final published = readLabeledValue('Published:');

      return ISBNElement(
        title,
        author.isEmpty ? 'Unknown' : author,
        published.isEmpty ? 'Unknown' : published,
        isbn10Link == null || isbn10Link.isEmpty ? '*' : isbn10Link,
        isbn13Link == null || isbn13Link.isEmpty ? fallbackIsbn : isbn13Link,
      );
    } catch (_) {
      return ISBNElement.notFound(fallbackIsbn);
    }
  }
}
