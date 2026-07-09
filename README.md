# Flutter PayPhi SDK Plugin

A Flutter plugin for integrating the PayPhi Payment Gateway into your Flutter applications.

## Features

- Initialize the PayPhi SDK with merchant credentials
- Process payments through the PayPhi payment gateway
- Receive payment responses via streams
- Handle payment callbacks and errors

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_payphi_sdk: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Android Setup

### 1. Add the following permissions to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 2. Add the PayPhi SDK dependency

Make sure to include the PayPhi SDK AAR file in your project.

## Usage

### Import the package

```dart
import 'package:flutter_payphi_sdk/flutter_payphi_sdk.dart';
```

### Initialize the SDK

```dart
final payPhiSdk = PayPhiSdk();

// Initialize the SDK with your credentials
await payPhiSdk.setAppInfo(
  environment: 'TEST', // or 'PRODUCTION'
  merchantId: 'YOUR_MERCHANT_ID',
  appId: 'YOUR_APP_ID',
  merchantName: 'Your Merchant Name',
);
```

### Process a Payment

```dart
try {
  final result = await payPhiSdk.makePayment(
    amount: '100.00',
    merchantId: 'YOUR_MERCHANT_ID',
    merchantTxnNo: 'TXN_${DateTime.now().millisecondsSinceEpoch}',
    currencyCode: 'INR',
    customerEmailID: 'customer@example.com',
    secretKey: 'YOUR_SECRET_KEY',
    addlParam1: 'Additional Param 1',
    addlParam2: 'Additional Param 2',
    aggregatorID: 'YOUR_AGGREGATOR_ID',
    apiVersion: '1.0',
  );
  
  print('Payment initiated: $result');
} catch (e) {
  print('Error processing payment: $e');
}
```

### Listen to Payment Responses

```dart
final subscription = payPhiSdk.paymentResponseStream.listen((response) {
  print('Payment response: $response');
  // Handle payment response
});

// Don't forget to cancel the subscription when done
// subscription.cancel();
```

## Example

Check the `example` directory for a complete example app demonstrating the plugin's usage.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
