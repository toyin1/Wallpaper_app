import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<File> convertUrlToFile(String url) async{
  //to make network request by using http
  final response = await http.get(Uri.parse(url));

  final documentDirectory = await getApplicationDocumentsDirectory();

  //create temporal path for us
  final file = File(join(documentDirectory.path, url.split('/').last));

  file.writeAsBytesSync(response.bodyBytes);

  return file;

}