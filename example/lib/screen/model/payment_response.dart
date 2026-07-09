/// Represents the payment details received from the PayPhi payment gateway.
class PaymentDetails {
  final String invoiceNo;
  final String respDescription;
  final String paymentMode;
  final String amount;
  final String transmissionDateTime;
  final String acqName;
  final String merchantId;
  final String customerEmailID;
  final String paymentID;
  final String txnID;
  final String paymentDateTime;
  final String paymentInstId;
  final String resultType;
  final String authCode;
  final String responseCode;
  final String paymentSubInstType;
  final String secureHash;
  final String merchantTxnNo;

  /// Creates a new [PaymentDetails] instance.
  const PaymentDetails({
    required this.invoiceNo,
    required this.respDescription,
    required this.paymentMode,
    required this.amount,
    required this.transmissionDateTime,
    required this.acqName,
    required this.merchantId,
    required this.customerEmailID,
    required this.paymentID,
    required this.txnID,
    required this.paymentDateTime,
    required this.paymentInstId,
    required this.resultType,
    required this.authCode,
    required this.responseCode,
    required this.paymentSubInstType,
    required this.secureHash,
    required this.merchantTxnNo,
  });

  /// Creates a [PaymentDetails] instance from a JSON map.
  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      invoiceNo: json['invoiceNo'] ?? '',
      respDescription: json['respDescription'] ?? '',
      paymentMode: json['paymentMode'] ?? '',
      amount: json['amount'] ?? '',
      transmissionDateTime: json['TransmissionDateTime'] ?? json['transmissionDateTime'] ?? '',
      acqName: json['acqName'] ?? '',
      merchantId: json['merchantId'] ?? '',
      customerEmailID: json['customerEmailID'] ?? '',
      paymentID: json['paymentID'] ?? '',
      txnID: json['txnID'] ?? '',
      paymentDateTime: json['paymentDateTime'] ?? '',
      paymentInstId: json['paymentInstId'] ?? '',
      resultType: json['ResultType'] ?? json['resultType'] ?? '',
      authCode: json['authCode'] ?? '',
      responseCode: json['responseCode'] ?? '',
      paymentSubInstType: json['paymentSubInstType'] ?? '',
      secureHash: json['secureHash'] ?? '',
      merchantTxnNo: json['merchantTxnNo'] ?? '',
    );
  }

  /// Converts this [PaymentDetails] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'invoiceNo': invoiceNo,
      'respDescription': respDescription,
      'paymentMode': paymentMode,
      'amount': amount,
      'TransmissionDateTime': transmissionDateTime,
      'acqName': acqName,
      'merchantId': merchantId,
      'customerEmailID': customerEmailID,
      'paymentID': paymentID,
      'txnID': txnID,
      'paymentDateTime': paymentDateTime,
      'paymentInstId': paymentInstId,
      'ResultType': resultType,
      'authCode': authCode,
      'responseCode': responseCode,
      'paymentSubInstType': paymentSubInstType,
      'secureHash': secureHash,
      'merchantTxnNo': merchantTxnNo,
    };
  }
}
