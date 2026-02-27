# isbn_searcher_dart

`isbn_searcher_dart`, .NET `ISBNLibrary` paketinin Dart/Flutter uyarlamasıdır.

## Features

- Google Books API ile ISBN arama
- `isbnsearch.org` uzerinden ISBN arama
- Sonuclari `ISBNElement` modeli ile donme
- Listeyi HTML tabloya donusturme yardimcilari

## Install

```yaml
dependencies:
  isbn_searcher_dart: ^0.1.0
```

## Usage

```dart
import 'package:isbn_searcher_dart/isbn_searcher_dart.dart';

Future<void> main() async {
  final googleBook = await Rest.getGoogleBookInfoAsync('9789750845987');
  print(googleBook);

  final isbnSearchBook = await Rest.getISBNSearchHtmlAsync('9789750845987');
  print(isbnSearchBook);
}
```

## Notes

- Bu kutuphane harici servisler kullandigi icin internet baglantisi gerektirir.
- `isbnsearch.org` HTML yapisi degisirse parser guncellenmelidir.

## License

MIT
