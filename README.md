[![pub.dev Version](https://img.shields.io/pub/v/isbn_searcher)](https://pub.dev/packages/isbn_searcher)
[![License](https://img.shields.io/github/license/berkbb/isbn_searcher?color=important)](https://github.com/berkbb/isbn_searcher/blob/main/LICENSE)

# ISBN Searcher for Dart&Flutter

`isbn_searcher` is a Dart/Flutter library for searching book details by ISBN.

## Features

- Search books by ISBN via Google Books API
- Search books by ISBN via `isbnsearch.org`
- Return normalized data with the `ISBNElement` model
- Generate HTML table output from result lists
- Optional colored terminal logging with `logbox_color`

## Install

```yaml
dependencies:
  isbn_searcher: ^1.0.2
```

## Usage

```dart
import 'package:isbn_searcher/isbn_searcher.dart';

Future<void> main() async {
  final googleBook = await Rest.getGoogleBookInfoAsync('9789750845987');
  final isbnSearchBook = await Rest.getISBNSearchHtmlAsync('9789750845987');

  [googleBook, isbnSearchBook].printElements();
}
```

## Notes

- This package depends on external services and requires an internet connection.
- If `isbnsearch.org` changes its HTML structure, parsing logic may need updates.

## License

MIT
