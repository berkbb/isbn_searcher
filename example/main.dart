import 'package:isbn_searcher/isbn_searcher.dart';

Future<void> main() async {
  final book = await Rest.getGoogleBookInfoAsync('9789750845987');

  final bookFromHtml = await Rest.getISBNSearchHtmlAsync('9789750845987');
  [book, bookFromHtml].printElements();

  final htmlTable = [book, bookFromHtml].makeHtmlTable();
  print(htmlTable);
}
