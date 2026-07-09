import 'package:meta/meta.dart';

/// Represents a payment response from the PayPhi SDK
class PaymentResponse {
  /// The status code of the response
  final String? statusCode;
  
  /// The status message
  final String? statusMessage;
  
  /// The transaction ID
  final String? transactionId;
  
  /// The payment ID
  final String? paymentId;
  
  /// The amount that was processed
  final String? amount;
  
  /// The currency code
  final String? currencyCode;
  
  /// Any additional parameters
  final Map<String, dynamic>? additionalParams;

  /// Creates a [PaymentResponse] from a JSON map
  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse._(
      statusCode: json['statusCode']?.toString(),
      statusMessage: json['statusMessage']?.toString(),
      transactionId: json['transactionId']?.toString(),
      paymentId: json['paymentId']?.toString(),
      amount: json['amount']?.toString(),
      currencyCode: json['currencyCode']?.toString(),
      additionalParams: Map<String, dynamic>.from(
        json..removeWhere((key, _) => _isStandardField(key)),
      ),
    );
  }

  const PaymentResponse._({
    this.statusCode,
    this.statusMessage,
    this.transactionId,
    this.paymentId,
    this.amount,
    this.currencyCode,
    this.additionalParams,
  });

  /// Converts the response to a JSON map
  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'statusMessage': statusMessage,
        'transactionId': transactionId,
        'paymentId': paymentId,
        'amount': amount,
        'currencyCode': currencyCode,
        ...?additionalParams,
      };

  @override
  String toString() => 'PaymentResponse(${toJson()})';

  /// Checks if the response indicates a successful payment
  bool get isSuccess => statusCode == '0' || statusCode?.toLowerCase() == 'success';

  /// Gets the status code as an integer
  int? get statusCodeAsInt => int.tryParse(statusCode ?? '');

  // Helper method to check if a key is a standard field
  static bool _isStandardField(String key) {
    return const {
      'statusCode',
      'statusMessage',
      'transactionId',
      'paymentId',
      'amount',
      'currencyCode',
    }.contains(key);
  }
}
