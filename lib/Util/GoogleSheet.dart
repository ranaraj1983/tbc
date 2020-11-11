import 'package:gsheets/gsheets.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:tbc/Util/ProductForm.dart';
import 'package:tbc/Util/FormController.dart';

class Google_Sheet{


  void submitForm() {
    // Validate returns true if the form is valid, or false
    // otherwise.

      // If the form is valid, proceed.
      /*ProductForm feedbackForm = ProductForm(
          "nameController.text",
          "test2",
          "test3",
          "test4");*/

      FormController formController = FormController();



      // Submit 'feedbackForm' and save it in Google Sheets.
      formController.submitForm(null, (String response) {
        print("Response: $response");
        if (response == FormController.STATUS_SUCCESS) {
          //print(response);
          // Feedback is saved succesfully in Google Sheets.
         // _showSnackbar("Feedback Submitted");
        } else {
          print("error");
          // Error Occurred while saving data in Google Sheets.
          //_showSnackbar("Error Occurred!");
        }
      });

  }

}