import 'dart:convert';
import 'package:http/http.dart' as http;

class CatFact {
  final String id;
  final String text;
  final String type;

  CatFact({
    required this.id,
    required this.text,
    required this.type,
  });

  factory CatFact.fromJson(Map<String, dynamic> json) {
    return CatFact(
      id: json['_id'],
      text: json['text'],
      type: json['type'],
    );
  }
}

Future<List<CatFact>> fetchCatFacts() async {
  final response = await http
      .get(Uri.parse('https://cat-fact.herokuapp.com/facts?count=10'));
  print(response.body);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((fact) => CatFact.fromJson(fact)).toList();
  } else {
    throw Exception('Failed to load cat facts');
  }
}
