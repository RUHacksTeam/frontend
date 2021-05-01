import 'package:http/http.dart' as http;

Future GetData(url) async {
  print("Stuck here \n");
  http.Response response = await http.get(url);
  print("Did it pass? \n");
  return response.body.toString();
}
