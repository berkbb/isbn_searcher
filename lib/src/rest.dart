import 'dart:convert';

import 'package:http/http.dart' as http;

import 'isbn_element.dart';
import 'isbn_element_extensions.dart';
import 'isbn_search_response.dart';

class Rest {
  static final http.Client _httpClient = http.Client();

  static Future<ISBNElement> getGoogleBookInfoAsync(String isbn) async {
    if (isbn.trim().isEmpty) {
      return ISBNElement.notFound('*');
    }

    final normalizedIsbn = isbn.trim();
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=isbn:$normalizedIsbn',
    );

    try {
      final response = await _httpClient.get(url);
      if (response.statusCode != 200) {
        return ISBNElement.notFound(normalizedIsbn);
      }

      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      final items = payload['items'] as List<dynamic>?;
      if (items == null || items.isEmpty) {
        return ISBNElement.notFound(normalizedIsbn);
      }

      final firstItem = items.first as Map<String, dynamic>;
      final volumeInfo = firstItem['volumeInfo'] as Map<String, dynamic>?;
      if (volumeInfo == null) {
        return ISBNElement.notFound(normalizedIsbn);
      }

      final identifiers =
          volumeInfo['industryIdentifiers'] as List<dynamic>? ?? const [];
      String findIdentifier(String type, String fallback) {
        for (final identifier in identifiers) {
          if (identifier is Map<String, dynamic>) {
            final idType = (identifier['type'] as String?)?.toLowerCase();
            if (idType == type.toLowerCase()) {
              final value = (identifier['identifier'] as String?)?.trim();
              if (value != null && value.isNotEmpty) {
                return value;
              }
            }
          }
        }
        return fallback;
      }

      final title = (volumeInfo['title'] as String?) ?? 'Unknown';
      final authors = (volumeInfo['authors'] as List<dynamic>?)
          ?.whereType<String>()
          .toList();
      final publishedDate =
          (volumeInfo['publishedDate'] as String?) ?? 'Unknown';

      return ISBNElement(
        title,
        authors.compileArrayInString(),
        publishedDate,
        findIdentifier('ISBN_10', '*'),
        findIdentifier('ISBN_13', normalizedIsbn),
      );
    } catch (_) {
      return ISBNElement.notFound(normalizedIsbn);
    }
  }

  static Future<ISBNElement> getISBNSearchHtmlAsync(String isbn) async {
    if (isbn.trim().isEmpty) {
      return ISBNElement.notFound('*');
    }

    final normalizedIsbn = isbn.trim();
    try {
      final html = await ISBNSearchResponse.getHtmlFromIsbnSearch(
        normalizedIsbn,
      );
      return ISBNSearchResponse.parseBookInfo(
        html,
        fallbackIsbn: normalizedIsbn,
      );
    } catch (_) {
      return ISBNElement.notFound(normalizedIsbn);
    }
  }
}
