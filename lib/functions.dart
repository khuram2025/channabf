import 'package:cookie_jar/cookie_jar.dart';
import 'package:http/http.dart' as http;



Future<String> getCsrfToken() async {
  final response = await http.get(Uri.parse('http://10.30.0.76:8000/account/set_csrf_token/'));

  if (response.statusCode != 200) {
    throw Exception('Failed to get CSRF token');
  }

  var cookieJar = CookieJar();
  cookieJar.loadForRequest(response.headers['set-cookie']);
  var csrfCookie = cookieJar['csrftoken'];
  return csrfCookie.value;
}
