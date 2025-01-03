import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> sendTextToAPI(String text) async {
  final url = Uri.parse("http://192.168.1.102:5000/predict");
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"text": text}),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    return result['prediction'].toString().toLowerCase();
  }
  return "error";
}
