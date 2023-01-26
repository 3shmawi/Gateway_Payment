import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geteway_payment/model/payment.dart';
import 'package:http/http.dart' as http;

class CheckoutPayment {
  static const _tokenUrl = 'https://api.sandbox.checkout.com/tokens';
  static const _paymentUrl = 'https://api.sandbox.checkout.com/payments';

  static const _publicKey = 'pk_sbox_h2inkx4pxqw77xraobp44fjotmj';
  static const _secretKey = 'sk_sbox_37ofhrdlmhqt3crdp5ozwxhi2uo';

  static const Map<String, String> _tokenHeaders = {
    'Content-Type': 'application/json',
    'Authorization': _publicKey
  };
  static const _paymentHeaders = {
    'Content-Type': 'application/json',
    'Authorization': _secretKey
  };

  Future<dynamic> _getToken(PaymentCard card) async {
    Map<String, String> body = {
      'type': 'card',
      'number': card.number,
      'expiry_month': card.expiryMonth,
      'expiry_year': card.expiryYear,
    };

    var response = await http.post(
      Uri.parse(_tokenUrl),
      headers: _tokenHeaders,
      body: jsonEncode(body),
    );
    switch (response.statusCode) {
      case 201:
        var data = jsonDecode(response.body);
        return data['token'];
      default:
        return 'Un handling error';
    }
  }

  Future<dynamic> getPayment(PaymentCard card) async {
    var token = await _getToken(card);
    if (kDebugMode) {
      print(token);
    }
  }
}
