import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_payphi_sdk_method_channel.dart';

/// The interface that implementations of flutter_payphi_sdk must implement.
///
/// Platform implementations should extend this class rather than implement it.
/// `PayPhiSdkPlatform` is a [PlatformInterface] that provides a way to
/// communicate between the plugin and platform implementations.
abstract class PayPhiSdkPlatform extends PlatformInterface {
  /// Constructs a PayPhiSdkPlatform.
  PayPhiSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static PayPhiSdkPlatform _instance = MethodChannelPayPhiSdk();

  /// The default instance of [PayPhiSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelPayPhiSdk].
  static PayPhiSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PayPhiSdkPlatform] when they register themselves.
  static set instance(PayPhiSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion();

  Future<String?> setAppInfo(
    String environment,
    String merchantId,
    String appId,
    String merchantName,
  );

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
  });

  /// Stream of payment responses
  Stream<dynamic> get paymentResponseStream;
}
