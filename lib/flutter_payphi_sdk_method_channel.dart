import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_payphi_sdk/flutter_payphi_sdk_platform_interface.dart';

/// An implementation of [PayPhiSdkPlatform] that uses method channels.
class MethodChannelPayPhiSdk extends PayPhiSdkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('customersdk');

  /// The event channel for payment responses.
  static const EventChannel _paymentResponseChannel = EventChannel(
    "payment_response",
  );

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<String?> setAppInfo(
    String environment,
    String merchantId,
    String appId,
    String merchantName,
  ) async {
    final result = await methodChannel.invokeMethod<String>('setAppInfo', {
      "environment": environment,
      "merchantId": merchantId,
      "appId": appId,
      "merchantName": merchantName,
    });
    return result;
  }

  @override
  Future<String?> makePayment({
    required String amount,
    required String merchantId,
    required String merchantTxnNo,
    required String currencyCode,
    required String customerEmailID,
    required String secretKey,
    String addlParam1 = '',
    String addlParam2 = '',
    String aggregatorID = '',
    String apiVersion = '1.0',
  }) async {
    final result = await methodChannel.invokeMethod<String>('makePayment', {
      'amount': amount,
      'merchantId': merchantId,
      'merchantTxnNo': merchantTxnNo,
      'currencyCode': currencyCode,
      'customerEmailID': customerEmailID,
      'secretKey': secretKey,
      'addlParam1': addlParam1,
      'addlParam2': addlParam2,
      'aggregatorID': aggregatorID,
      'apiVersion': apiVersion,
    });
    return result;
  }

  @override
  Stream<dynamic> get paymentResponseStream {
    return _paymentResponseChannel.receiveBroadcastStream().cast<dynamic>();
  }
}
