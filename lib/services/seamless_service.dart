
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../objects/seamless_check_api.dart';
import '../objects/seamless_validate_api.dart';

class SeamlessService {

  static const BASE_URL_PROD = "https://api.safeme.id";
  static const BASE_URL_STAGING = "https://api.stg.safeme.id";

  static var deviceId = '';

  const SeamlessService();

  String get BASE_URL => BASE_URL_STAGING;

  Future<SeamlessCheckAPI?> check(
      String phoneNumber,
      String meta,
      ) async {
    final url = "$BASE_URL/d-seamless/check";
    final body = <String, dynamic>{
      "phone_number": phoneNumber,
      "meta": meta
    };

    final response = await _fetch(url, body);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final check = SeamlessCheckAPI.fromJson(json.decode(response.body));
      deviceId = check.device_id;
      return check;
    }

    return null;
  }

  Future<bool> enroll(
      String phoneNumber,
      String meta,
      String challenge,
      ) async {
    final url = "$BASE_URL/d-seamless/enroll";
    final body = {
      "phone_number": phoneNumber,
      "meta": meta,
      "challenge": challenge
    };

    final response = await _fetch(url, body);
    return response.statusCode >= 200 && response.statusCode <= 299;
  }

  Future<SeamlessValidateAPI?> validate(
      String phoneNumber,
      String meta,
      String challenge,
      String fazpassId,
      ) async {
    final url = "$BASE_URL/d-seamless/validate";
    final body = {
      "phone_number": phoneNumber,
      "meta": meta,
      "fazpass_id": fazpassId,
      "challenge": challenge
    };

    final response = await _fetch(url, body);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final validate = SeamlessValidateAPI.fromJson(json.decode(response.body));
      validate.device_id.id = deviceId;
      return validate;
    }

    return null;
  }

  Future<http.Response> _fetch(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json'
      },
      body: json.encode(body),
    );
    print("API Request: url=$url\nbody=$body\nresponse_code=${response.statusCode}\nresponse=${response.body}");
    return response;
  }
}