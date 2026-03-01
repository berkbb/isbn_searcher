import 'package:logbox_color/logbox_color.dart';
import 'package:logbox_color/extensions.dart';

import 'isbn_element.dart';

/// Extensions for an [Iterable] of [ISBNElement].
extension ISBNElementIterableExtensions on Iterable<ISBNElement> {
  /// Prints the elements either as a plain string or with a formatted color box.
  void printElements({bool useColorBox = true}) {
    for (final element in this) {
      if (useColorBox) {
        printLog(element.toString(), LogLevel.info);
      } else {
        // ignore: avoid_print
        print(element);
      }
    }
  }

  /// Generates a simple HTML table string displaying the elements.
  String makeHtmlTable() {
    final buffer = StringBuffer()
      ..write('<!DOCTYPE html><html><head><meta charset="utf-8"/>')
      ..write('<style>')
      ..write(
        'body{font-family:Segoe UI,Tahoma,sans-serif;background:#f8fafc;color:#0f172a;padding:24px;} ',
      )
      ..write(
        'table{border-collapse:collapse;width:100%;background:#fff;box-shadow:0 8px 24px rgba(15,23,42,.08);} ',
      )
      ..write(
        'th,td{border:1px solid #e2e8f0;padding:10px;text-align:left;} th{background:#0f172a;color:#fff;}',
      )
      ..write('</style></head><body>')
      ..write(
        '<table><tr><th>ISBN-13</th><th>Book Title</th><th>Author</th></tr>',
      );

    for (final element in this) {
      buffer.write(element.toTableRow());
    }

    buffer.write('</table></body></html>');
    return buffer.toString();
  }

  /// Legacy method alias for [makeHtmlTable].
  String makeHTMLTable() => makeHtmlTable();
}

/// Extensions for a [List] of [String].
extension StringListExtensions on List<String>? {
  /// Compiles the array of strings into a single comma-separated string.
  String compileArrayInString() {
    final values = this;
    if (values == null) {
      return '';
    }

    return values
        .where((value) => value.trim().isNotEmpty)
        .map((value) => value.trim())
        .join(', ');
  }
}
