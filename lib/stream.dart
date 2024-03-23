 import 'dart:convert';
import 'package:http/http.dart' as http;

Stream<int> streamFunAsync() async* {
    while (true) {
      var rand = await http.get(
          Uri.parse('https://www.randomnumberapi.com/api/v1.0/randomnumber'));
      var asnwer = jsonDecode(rand.body);
      yield asnwer[0];
      await Future.delayed(const Duration(minutes: 5));
    }
  }