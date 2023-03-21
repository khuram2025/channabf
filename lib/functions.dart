import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart'; // Import the collection package
import 'package:path_provider/path_provider.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

Future<String> getCsrfToken() async {
  final response = await http.get(Uri.parse('http://192.168.8.179:8000/account/set_csrf_token/'));

  if (response.statusCode != 200) {
    throw Exception('Failed to get CSRF token');
  }

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  var cookieJar = PersistCookieJar(storage: FileStorage(appDocPath));
  String? rawCookies = response.headers['set-cookie'];
  print('Raw cookies: $rawCookies'); // Add print statement for raw cookies
  if (rawCookies != null) {
    cookieJar.saveFromResponse(Uri.parse('http://192.168.8.179:8000/'), [Cookie.fromSetCookieValue(rawCookies)]);
    List<Cookie> cookies = await cookieJar.loadForRequest(Uri.parse('http://192.168.8.179:8000/'));
    print('Loaded cookies: $cookies'); // Add print statement for loaded cookies
    var csrfCookie = cookies.firstWhereOrNull((cookie) => cookie.name == 'csrftoken');
    if (csrfCookie != null) {
      return csrfCookie.value;
    }
  }
  throw Exception('Failed to find CSRF token in cookies');
}

