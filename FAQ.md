# Flutter PayPhi SDK - Comprehensive Guide & FAQ

## Table of Contents
- [General](#general)
- [Installation](#installation)
- [Initialization](#initialization)
- [Making Payments](#making-payments)
- [Advanced Features](#advanced-features)
- [Error Handling](#error-handling)
- [Security](#security)
- [Testing & Debugging](#testing--debugging)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)
- [Version History](#version-history)
- [Support](#support)

## General

### What is the Flutter PayPhi SDK?
The Flutter PayPhi SDK is a robust plugin that enables seamless integration of PayPhi's payment processing capabilities into Flutter applications. It provides a secure and efficient way to handle payments, subscriptions, and other financial transactions with minimal setup.

### What platforms are supported?
- **Android**: API level 21 (Android 5.0) and above
- **iOS**: 11.0 and above
- **Web**: Coming soon
- **Desktop**: Experimental support for Windows, macOS, and Linux

### What are the minimum requirements?
- **Flutter SDK**: 3.0.0 or higher
- **Dart**: 2.17.0 or higher
- **Android**:
  - minSdkVersion: 21
  - compileSdkVersion: 33+
  - Kotlin: 1.7.0+
- **iOS**:
  - Xcode 13.0+
  - Swift 5.5+
  - Deployment target: 11.0+

### What payment methods are supported?
- Credit/Debit Cards (Visa, Mastercard, Amex, etc.)
- Net Banking
- UPI (Unified Payments Interface)
- EMI (Equated Monthly Installments)

### Is there a sandbox/test environment?
Yes, the SDK provides a test environment that simulates payment processing without charging real money. Use `environment: 'TEST'` during initialization for testing purposes.

## Installation

### How do I add the SDK to my Flutter project?
Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_payphi_sdk: ^1.0.0  # Use the latest version
  # Recommended additional packages
  http: ^0.13.5
  provider: ^6.0.5
  flutter_secure_storage: ^8.0.0
```

Then run:
```bash
flutter pub get
```

### Android Configuration
1. Add the following permissions to your `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

2. Enable multidex in `app/build.gradle`:
```gradle
defaultConfig {
    multiDexEnabled true
}
```

### iOS Configuration
1. Add these permissions to your `Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

2. Add the following to your Podfile:
```ruby
target 'YourApp' do
  use_frameworks!
  # ... other configurations
end
```

## Initialization

### How do I initialize the SDK?
```dart
final payPhiSdk = PayPhiSdk();

// Initialize with your credentials
await payPhiSdk.initialize(
  environment: 'TEST',  // or 'PRODUCTION'
  merchantId: 'YOUR_MERCHANT_ID',
  appId: 'YOUR_APP_ID',
  merchantName: 'YOUR_MERCHANT_NAME',
);
```

### What environments are supported?
- `TEST`: For testing payments
- `PRODUCTION`: For live payments

## Making Payments

### Basic Payment Flow
```dart
// 1. Initialize the SDK (should be done at app startup)
final payPhiSdk = PayPhiSdk();
await payPhiSdk.initialize(
  environment: 'TEST',
  merchantId: 'YOUR_MERCHANT_ID',
  appId: 'YOUR_APP_ID',
  merchantName: 'Your Business Name',
);

// 2. Set up payment response listener
void setupPaymentListener() {
  payPhiSdk.paymentResponseStream.listen((response) {
    if (response['status'] == 'SUCCESS') {
      // Handle successful payment
      final transactionId = response['transactionId'];
      final amount = response['amount'];
      // Update UI and process order
    } else {
      // Handle error
      final errorCode = response['errorCode'];
      final errorMessage = response['errorMessage'];
      // Show error to user
    }
  }, onError: (error) {
    // Handle stream error
    debugPrint('Payment stream error: $error');
  });
}

// 3. Initiate payment
Future<void> initiatePayment() async {
  try {
    final response = await payPhiSdk.makePayment(
      amount: '100.00',
      merchantId: 'YOUR_MERCHANT_ID',
      merchantTxnNo: 'TXN_${DateTime.now().millisecondsSinceEpoch}',
      currencyCode: 'INR',
      customerEmailID: 'customer@example.com',
      customerPhone: '+919876543210',  // Optional
      customerName: 'John Doe',        // Optional
      secretKey: 'YOUR_SECRET_KEY',
      addlParam1: 'Additional Data 1', // Optional
      addlParam2: 'Additional Data 2', // Optional
      aggregatorID: 'YOUR_AGGREGATOR_ID', // If applicable
      apiVersion: '1.0',
    );
    
    // The response here is just an acknowledgment that payment was initiated
    debugPrint('Payment initiated: $response');
  } on PlatformException catch (e) {
    debugPrint('Payment failed: ${e.message}');
    // Show error to user
  } catch (e) {
    debugPrint('Unexpected error: $e');
    // Handle other errors
  }
}
```

### Advanced Payment Scenarios

#### 1. Recurring Payments
```dart
// Set up a subscription with recurring billing
final response = await payPhiSdk.makePayment(
  amount: '500.00',
  merchantId: 'YOUR_MERCHANT_ID',
  merchantTxnNo: 'SUB_${DateTime.now().millisecondsSinceEpoch}',
  currencyCode: 'INR',
  customerEmailID: 'customer@example.com',
  secretKey: 'YOUR_SECRET_KEY',
  addlParam1: 'RECURRING',
  addlParam2: 'MONTHLY', // or 'WEEKLY', 'YEARLY'
);
### Handling Payment Responses

#### Successful Response
```json
{
  "status": "SUCCESS",
  "transactionId": "TXN123456789",
  "amount": "100.00",
  "currency": "INR",
  "timestamp": "2025-07-08T15:30:00Z",
  "paymentMethod": "Credit Card",
  "cardLast4": "4242",
  "customerEmail": "customer@example.com"
}
```

#### Error Response
```json
{
  "status": "FAILED",
  "errorCode": "PAYMENT_DECLINED",
  "errorMessage": "Insufficient funds",
  "transactionId": "TXN123456789",
  "timestamp": "2025-07-08T15:30:00Z"
}
## Error Handling

### What are common error codes?
- `0000`: Success
- `201`: Invalid credentials
- `205`: Payments not enabled
- `504`: Connection error
- `101`: Internal error

### How do I handle errors?
Always wrap payment calls in try-catch blocks:

```dart
try {
  // Payment code here
} on PlatformException catch (e) {
  print('Error: ${e.message}');
  // Show error to user
}
```

## Security

### How is sensitive data handled?
- All sensitive data is encrypted
- The SDK uses secure channels for communication
- No sensitive data is stored on the device
## Troubleshooting
### Payment fails with "Invalid credentials"
1. Verify your `merchantId` and `appId`
2. Ensure you're using the correct environment (TEST/PRODUCTION)
3. Check that your secret key is correct

### No response from payment gateway
1. Check internet connectivity
2. Verify the device has proper network permissions
3. Check if the PayPhi service is operational

### How do I get support?
For technical support, contact:
- Email: support@payphi.com
- Phone: [Your support number]
- Documentation: [Link to documentation]

## Best Practices

1. Always initialize the SDK when your app starts
2. Handle all possible error cases
3. Test thoroughly in the TEST environment before going to PRODUCTION
4. Keep your SDK version up to date
5. Never hardcode sensitive information in your app

## Version History

### v1.0.0
- Initial release with basic payment functionality
- Support for Android and iOS
- Test and Production environments
