import 'dart:convert';

import 'package:http/http.dart' as http;


class Createddata {



  Future datacreated(nametext, emailtext,) async {
    final responce =
        await http.post(Uri.parse('https://jsonplaceholder.typicode.com/users'),
            body: jsonEncode({
              "name":nametext,
              "username": emailtext,
            }),
            headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    print(responce.statusCode);
    if (responce.statusCode == 201) {
     
      print('Data Created Successfully');
    } else {
      print('erro');
    }
  }

}
