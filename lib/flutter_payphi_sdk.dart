import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_payphi_sdk/flutter_payphi_sdk_platform_interface.dart';

typedef EventCallback = void Function(dynamic event);

/// The main class for interacting with the PayPhi SDK.
///
/// This class provides methods to initialize the SDK, make payments,
/// and listen to payment responses.
class PayPhiSdk {
  final PayPhiSdkPlatform _platform = PayPhiSdkPlatform.instance;
  final EventChannel _paymentResponseChannel = const EventChannel(
    'payment_response',
  );
  StreamSubscription<dynamic>? _paymentResponseSubscription;
  EventCallback? _paymentResponseCallback;

  /// Initialize the PayPhi SDK with required parameters.
  ///
  /// [environment] - The environment to use ('TEST' or 'PRODUCTION')
  /// [merchantId] - Your PayPhi merchant ID
  /// [appId] - Your PayPhi application ID
  /// [merchantName] - Your merchant name
  Future<String?> initialize({
    required String environment,
    required String merchantId,
    required String appId,
    required String merchantName,
  }) async {
    try {
      return await _platform.setAppInfo(
        environment,
        merchantId,
        appId,
        merchantName,
      );
    } on PlatformException catch (e) {
      throw Exception('Failed to initialize PayPhi SDK: ${e.message}');
    }
  }

  /// Set up a listener for payment responses.
  ///
  /// [onResponse] - Callback function that will be called with payment response data
  void setPaymentResponseListener(EventCallback onResponse) {
    _paymentResponseCallback = onResponse;
    _paymentResponseSubscription?.cancel();
    _paymentResponseSubscription = _paymentResponseChannel
        .receiveBroadcastStream()
        .listen((event) => _paymentResponseCallback?.call(event));
  }

  /// Make a payment using the PayPhi SDK.
  ///
  /// [amount] - The payment amount
  /// [merchantId] - Your PayPhi merchant ID
  /// [merchantTxnNo] - A unique transaction reference number
  /// [currencyCode] - The currency code (e.g., 'INR')
  /// [customerEmailID] - Customer's email address
  /// [secretKey] - Your PayPhi secret key for generating secure hash
  /// [addlParam1] - Additional parameter 1 (optional)
  /// [addlParam2] - Additional parameter 2 (optional)
  /// [aggregatorID] - Aggregator ID (if applicable)
  /// [apiVersion] - API version to use
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
    try {
      return await _platform.makePayment(
        amount: amount,
        merchantId: merchantId,
        merchantTxnNo: merchantTxnNo,
        currencyCode: currencyCode,
        customerEmailID: customerEmailID,
        secretKey: secretKey,
        addlParam1: addlParam1,
        addlParam2: addlParam2,
        aggregatorID: aggregatorID,
        apiVersion: apiVersion,
      );
    } on PlatformException catch (e) {
      throw Exception('Failed to make payment: ${e.message}');
    }
  }

  /// Listen to payment response events from the native side.
  Stream<dynamic> get paymentResponseStream =>
      _paymentResponseChannel.receiveBroadcastStream();

  /// Dispose of resources used by the PayPhi SDK.
  /// Call this method when you're done using the SDK to free up resources.
  void dispose() {
    _paymentResponseSubscription?.cancel();
    _paymentResponseSubscription = null;
    _paymentResponseCallback = null;
  }
}
