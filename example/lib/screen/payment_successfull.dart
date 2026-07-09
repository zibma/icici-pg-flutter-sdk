import 'package:flutter/material.dart';

import 'model/payment_response.dart';

/// A screen that displays the payment details after a successful transaction.
///
/// This widget shows a detailed view of the payment transaction including
/// transaction ID, amount, status, and other relevant details in a clean,
/// user-friendly interface.
class PaymentDetailsScreen extends StatelessWidget {
  final PaymentDetails paymentDetails;

  const PaymentDetailsScreen({Key? key, required this.paymentDetails})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24.0),
                _buildPaymentDetails(),
                const SizedBox(height: 24.0),
                _buildBackButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 80.0),
        const SizedBox(height: 16.0),
        const Text(
          'Payment Successful!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Transaction ID: ${paymentDetails.txnID}',
          style: const TextStyle(color: Colors.grey, fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    final details = [
      _DetailItem('Invoice No', paymentDetails.invoiceNo),
      _DetailItem('Amount', '₹${paymentDetails.amount}'),
      _DetailItem('Status', paymentDetails.respDescription),
      _DetailItem('Payment Mode', paymentDetails.paymentMode),
      _DetailItem(
        'Date & Time',
        _formatDateTime(paymentDetails.paymentDateTime),
      ),
      _DetailItem('Auth Code', paymentDetails.authCode),
      _DetailItem('Merchant ID', paymentDetails.merchantId),
    ];

    return Column(
      children: [
        for (var i = 0; i < details.length; i++) ...[
          _buildDetailRow(details[i].label, details[i].value),
          if (i < details.length - 1) const Divider(),
        ],
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: const Text(
        'Back to Home',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTime) {
    try {
      final date = DateTime.tryParse(dateTime);
      if (date != null) {
        return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
      }
    } catch (e) {
      // If parsing fails, return the original string
    }
    return dateTime;
  }
}

class _DetailItem {
  final String label;
  final String value;

  _DetailItem(this.label, this.value);
}
