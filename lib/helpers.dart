import 'package:http/http.dart' as http;
import 'dart:convert';


List<String> TAGS = ["wisdom", "life", "technology"];

Future<Map<String, String>> getRandomQuote({String tag = "wisdom"}) async {

  String url = "http://api.quotable.io/random?tags=$tag";

  http.Response res = await http.get(url);

  Map jsonReponse = jsonDecode(res.body);

  return {"quote": jsonReponse['content'], "author": jsonReponse['author']};
}
