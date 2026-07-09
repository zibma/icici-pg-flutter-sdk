/// Constants used throughout the PayPhi SDK
class PaymentConstants {
  /// Channel name for method calls
  static const String methodChannel = 'customersdk';
  
  /// Channel name for event streams
  static const String eventChannel = 'payment_response';
  
  /// Method names
  static const String methodGetPlatformVersion = 'getPlatformVersion';
  static const String methodSetAppInfo = 'setAppInfo';
  static const String methodMakePayment = 'makePayment';
  
  /// Parameter keys
  static const String paramEnvironment = 'environment';
  static const String paramMerchantId = 'merchantId';
  static const String paramAppId = 'appId';
  static const String paramMerchantName = 'merchantName';
  static const String paramAmount = 'amount';
  static const String paramMerchantTxnNo = 'merchantTxnNo';
  static const String paramCurrencyCode = 'currencyCode';
  static const String paramCustomerEmailID = 'customerEmailID';
  static const String paramSecretKey = 'secretKey';
  static const String paramAddlParam1 = 'addlParam1';
  static const String paramAddlParam2 = 'addlParam2';
  static const String paramApiVersion = 'apiVersion';
  static const String paramAggregatorId = 'aggregatorID';
  
  /// Environment types
  static const String envTest = 'TEST';
  static const String envProduction = 'PRODUCTION';
  
  /// Default values
  static const String defaultCurrency = 'INR';
  
  /// Error codes
  static const String errorInvalidCredentials = '201';
  static const String errorConnection = '504';
  static const String errorPaymentsNotEnabled = '205';
  static const String errorInternal = '101';
  
  /// Private constructor to prevent instantiation
  PaymentConstants._();
}
