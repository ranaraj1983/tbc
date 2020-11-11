import 'package:gsheets/gsheets.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:tbc/Util/ProductForm.dart';

class FormController {

  // Google App Script Web URL.
  static const String URL = "https://script.google.com/macros/s/AKfycbzK8EgDb9tt9sZ3Z39fXq1IGvRTmuNGhdMymylRrKW5PHVjcg/exec";
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(
      ProductForm feedbackForm, void Function(String) callback) async {
    try {
      await http.post(URL, body: feedbackForm.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }
  Future<List<ProductForm>> getProductList() async {
    return await http.get(URL).then((response) {
      print(response.body);
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      print(jsonFeedback);
      return jsonFeedback.map((json) => ProductForm.fromJson(json)).toList();
    });
  }
}