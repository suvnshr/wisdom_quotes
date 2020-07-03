import 'package:http/http.dart' as http;
import 'dart:convert';

List<String> allTags = ["wisdom", "life", "technology"];

Future<Map<String, String>> getRandomQuote({String tag = "wisdom"}) async {
  String url = "http://api.quotable.io/random?tags=$tag";

  http.Response res = await http.get(url);

  Map jsonResponse = jsonDecode(res.body);

  return {
    "quoteKey": jsonResponse['_id'],
    "quote": jsonResponse['content'],
    "author": jsonResponse['author'],
  };
}
