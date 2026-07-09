// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_payphi_sdk/flutter_payphi_sdk.dart';
// import 'package:flutter_payphi_sdk_example/screen/payment_successfull.dart';
//
// import 'model/payment_response.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   static const platform = MethodChannel(
//     'com.payphi.fluttersdkplugin/customersdk',
//   );
//   final PayPhiSdk _payPhiSdk = PayPhiSdk();
//   var randomNumber;
//   String _paymentResponse = "";
//   String _platformVersion = 'Unknown';
//   var isShow = false;
//
//   // Controllers
//   final _amountTEC = TextEditingController();
//   final _merchantId = TextEditingController();
//   final _appId = TextEditingController();
//   final _secreteKey = TextEditingController();
//   final _aggId = TextEditingController();
//   final _currencyCode = TextEditingController();
//   final _emailId = TextEditingController();
//   final _addParam = TextEditingController();
//
//   // UI State
//   String envValue = 'INT';
//   final envList = {'QA', 'INT', 'PREPROD', 'dev', 'PROD'};
//   var enableMakePayment = false;
//   String _appInfoResult = '';
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String _immediateResult = 'Unknown';
//   String _streamResult = '';
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   enableMakePayment = false;
//   //   randomNumber = Random();
//   //   initPlatformState();
//   //   // invokeSetAppInfo();
//   // }
//   @override
//   void initState() {
//     super.initState();
//     enableMakePayment = false;
//     randomNumber = Random().nextInt(1000000);
//     _initPlatformState();
//
//     // Set up payment response listener
//     _payPhiSdk.paymentResponseStream.listen((response) {
//       if (response != null && mounted) {
//         setState(() {
//           _paymentResponse = response.toString();
//         });
//
//         debugPrint('Payment Response: $_paymentResponse');
//
//         try {
//           final responseData = json.decode(_paymentResponse);
//           if (responseData['status']?.toString().toLowerCase() == 'success') {
//             showSnackBar('Payment successful!');
//             navigateToPaymentDetails(context, _paymentResponse);
//           } else {
//             showSnackBar(
//               'Payment failed: ${responseData['message'] ?? 'Unknown error'}',
//             );
//           }
//         } catch (e) {
//           showSnackBar('Payment response: $_paymentResponse');
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     // Clean up controllers and other resources
//     _amountTEC.dispose();
//     _merchantId.dispose();
//     _appId.dispose();
//     _secreteKey.dispose();
//     _aggId.dispose();
//     _currencyCode.dispose();
//     _emailId.dispose();
//     _addParam.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(title: const Text('Pay Phi Flutter SDK')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 10),
//               child: Center(child: Text('Running on: $_platformVersion\n')),
//             ),
//             const Text("Select Environment"),
//             Container(
//               margin: const EdgeInsets.only(left: 16),
//               child: DropdownButton(
//                 value: envValue,
//                 items: envList.map((String items) {
//                   return DropdownMenuItem(value: items, child: Text(items));
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     envValue = newValue!;
//                   });
//                 },
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.all(16),
//               child: TextField(
//                 controller: _amountTEC..text = "2",
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Amount',
//                   hintText: 'Enter Amount',
//                 ),
//                 keyboardType: TextInputType.number,
//                 // onChanged:(String value){
//                 //   setState(() {
//                 //     _amountTEC.text = value;
//                 //   });
//                 // },
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.all(16),
//               child: TextField(
//                 controller: _merchantId..text = "T_20259",
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Merchant Id',
//                   hintText: 'Enter Merchant Id',
//                 ),
//                 keyboardType: TextInputType.text,
//                 onChanged: (String merchantId) {
//                   setState(() {
//                     _merchantId.text = merchantId;
//                   });
//                 },
//               ),
//             ),
//             Visibility(
//               visible: false,
//               child: Container(
//                 margin: const EdgeInsets.all(16),
//                 child: TextField(
//                   controller: _appId..text = "80bc18249511f868",
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Enter App Id',
//                     hintText: 'Enter App Id',
//                   ),
//                   keyboardType: TextInputType.text,
//                 ),
//               ),
//             ),
//
//             // Container(
//             //   margin: const EdgeInsets.all(16),
//             //   child: TextField(
//             //     controller: _appId..text = "80bc18249511f868",
//             //     decoration: const InputDecoration(
//             //       border: OutlineInputBorder(),
//             //       labelText: 'Enter App Id',
//             //       hintText: 'Enter App Id',
//             //     ),
//             //     keyboardType: TextInputType.text,
//             //   ),
//             // ),
//             Visibility(
//               visible: false,
//               child: Container(
//                 margin: const EdgeInsets.all(16),
//                 child: TextField(
//                   controller: _secreteKey..text = "abc",
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Enter Secrete Key',
//                     hintText: 'Enter Secrete Key',
//                   ),
//                   keyboardType: TextInputType.text,
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.all(16),
//               child: TextField(
//                 controller: _aggId..text = "J_20259",
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Enter Aggregator Id',
//                   hintText: 'Enter  Aggregator Id',
//                 ),
//                 keyboardType: TextInputType.text,
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.all(16),
//               child: TextField(
//                 controller: _addParam..text = "",
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Enter Additional Parameters',
//                   hintText: 'Enter Additional Parameters',
//                 ),
//                 onChanged: (String addParam) {
//                   setState(() {
//                     _addParam.text = addParam;
//                   });
//                 },
//                 keyboardType: TextInputType.text,
//               ),
//             ),
//             Visibility(
//               visible: false,
//               child: Container(
//                 margin: const EdgeInsets.all(16),
//                 child: TextField(
//                   controller: _currencyCode..text = "356",
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Enter Currency Code',
//                     hintText: 'Enter Currency Code',
//                   ),
//                   onChanged: (String currencyCode) {
//                     setState(() {
//                       _currencyCode.text = currencyCode;
//                     });
//                   },
//                   keyboardType: TextInputType.text,
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.all(16),
//               child: TextField(
//                 controller: _emailId..text = "test@gmail.com",
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Enter Email id',
//                   hintText: 'Enter Email ID',
//                 ),
//                 onChanged: (String Email) {
//                   setState(() {
//                     _emailId.text = Email;
//                   });
//                 },
//                 keyboardType: TextInputType.text,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _setAppInfo();
//               },
//               child: const Text('Set App Info => (Login)'),
//             ),
//
//             ElevatedButton(
//               onPressed: !enableMakePayment
//                   ? null
//                   : () {
//                       if (_amountTEC.value.text == "" ||
//                           _amountTEC.value.text == "0") {
//                         showSnackBar("Please Enter valid amount");
//                         // Flushbar(
//                         //   duration: Duration(seconds: 1),
//                         //   backgroundColor: Colors.red,
//                         //   flushbarPosition: FlushbarPosition.TOP,
//                         //   title: 'Please Enter valid amount',
//                         //   message: 'amount should not be 0 or empty!',
//                         // ).show(context);
//                         closeKeypad();
//                         // showSnackBar("Please Enter valid amount ");
//                       } else {
//                         _invokeMakePayment(_amountTEC.text);
//                       }
//                     },
//               child: const Text('Make Payment'),
//             ),
//             // Visibility(
//             //   visible: isShow ?? false,
//             //   child: const OutlinedButton(
//             //       onPressed: null,
//             //       child: Text(
//             //         "Payment success",
//             //         style: TextStyle(fontSize: 18, color: Colors.green),
//             //       )),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
//
//   // This method calls the setAppInfo function on button click.
//   void _setAppInfo() async {
//     try {
//       String? result = await _payPhiSdk.initialize(
//         environment: envValue,
//         merchantId: _merchantId.text,
//         appId: _appId.text,
//         merchantName: "MyMerchant",
//       );
//
//       setState(() {
//         _appInfoResult = result ?? 'No response received';
//         enableMakePayment = (result == '0000');
//       });
//
//       debugPrint("Set App Info result: $_appInfoResult");
//
//       // Show appropriate message based on result
//       if (result == '0000') {
//         debugPrint("SDK initialized successfully");
//         showSnackBar("SDK initialized successfully", Colors.green);
//       } else {
//         showSnackBar("Initialization failed: $_appInfoResult");
//       }
//     } catch (e) {
//       debugPrint("Error initializing SDK: $e");
//       setState(() {
//         _appInfoResult = "Error: $e";
//         enableMakePayment = false;
//       });
//       showSnackBar("Error initializing SDK: $e");
//     }
//   }
//
//   // Method to invoke makePayment when the button is clicked.
//   void _invokeMakePayment(String amount) async {
//     debugPrint("_invokeMakePayment invoked");
//     try {
//       // Initialize the SDK first
//       // await _payPhiSdk.initialize(
//       //   environment: 'INT', // or 'PRODUCTION' for live environment
//       //   merchantId: _merchantId.text,
//       //   appId: _appId.text,
//       //   merchantName: 'Your Merchant Name', // Replace with actual merchant name
//       // );
//       //
//       // // Set up payment response listener
//       // _payPhiSdk.paymentResponseStream.listen((response) {
//       //   if (response != null && mounted) {
//       //     navigateToPaymentDetails(context, response);
//       //   }
//       // });
//
//       // Make the payment
//       await _payPhiSdk.makePayment(
//         amount: _amountTEC.text,
//         merchantId: _merchantId.text,
//         merchantTxnNo: 'TXN_${DateTime.now().millisecondsSinceEpoch}',
//         currencyCode: _currencyCode.text.isNotEmpty
//             ? _currencyCode.text
//             : 'INR',
//         customerEmailID: _emailId.text,
//         secretKey: _secreteKey.text,
//         addlParam1: 'param1',
//         addlParam2: 'param2',
//         aggregatorID: _aggId.text,
//         apiVersion: '4',
//       );
//
//       if (mounted) {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(content: Text('Payment initiated successfully')),
//         // );
//         showSnackBar('Payment initiated successfully', Colors.green);
//       }
//     } on PlatformException catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
//       }
//     }
//   }
//
//   // Initialize the PayPhi SDK with current configuration
//   Future<void> _initializeSdk() async {
//     try {
//       await _payPhiSdk.initialize(
//         environment: envValue,
//         merchantId: _merchantId.text,
//         appId: _appId.text,
//         merchantName: 'PayPhi Merchant',
//       );
//
//       if (mounted) {
//         setState(() {
//           enableMakePayment = true;
//         });
//       }
//     } catch (e) {
//       debugPrint("Error initializing SDK: $e");
//       if (mounted) {
//         setState(() {
//           enableMakePayment = false;
//         });
//         showSnackBar('Failed to initialize SDK: $e');
//       }
//     }
//   }
//
//   Future<void> _initPlatformState() async {
//     String platformVersion;
//
//     try {
//       // Get platform version
//       platformVersion =
//           await platform.invokeMethod('getPlatformVersion') ?? 'Unknown';
//
//       // Initialize default values
//       if (mounted) {
//         setState(() {
//           _platformVersion = platformVersion;
//           _amountTEC.text = '2';
//           _merchantId.text = 'T_20259';
//           _appId.text = 'T_20259';
//           _secreteKey.text = 'T_20259';
//           _aggId.text = 'T_20259';
//           _currencyCode.text = 'INR';
//           _emailId.text = 'test@example.com';
//         });
//       }
//
//       // Initialize SDK with default values
//       await _initializeSdk();
//     } on PlatformException catch (e) {
//       platformVersion = 'Failed to get platform version: ${e.message}';
//       if (mounted) {
//         setState(() {
//           _platformVersion = platformVersion;
//         });
//       }
//     }
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }
//
//   void showSnackBar(String message, [Color? color]) {
//     final snackBar = SnackBar(
//       content: Text(message),
//       backgroundColor: color ?? Colors.red,
//       behavior: SnackBarBehavior.floating,
//     );
//     // Find the Scaffold in the Widget tree and use it to show a SnackBar!
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
//
//   // @override
//   // void dispose() {
//   //   _amountTEC.dispose();
//   //   super.dispose();
//   // }
//
//   void closeKeypad() {
//     FocusManager.instance.primaryFocus?.unfocus();
//   }
//
//   // void _showFlushBar(String title, String message, [Color? color]) {
//   //   Flushbar(
//   //     duration: const Duration(seconds: 4),
//   //     backgroundColor: color ?? Colors.red,
//   //     flushbarPosition: FlushbarPosition.TOP,
//   //     title: title,
//   //     message: message,
//   //   ).show(context);
//   // }
//
//   void paymentResponseWidget() {}
//
//   void navigateToPaymentDetails(BuildContext context, dynamic response) {
//     try {
//       if (response == null) {
//         showSnackBar('Error: Empty payment response');
//         return;
//       }
//
//       String jsonData;
//       if (response is String) {
//         jsonData = response;
//       } else {
//         jsonData = jsonEncode(response);
//       }
//
//       final responseData = jsonDecode(jsonData);
//       final paymentDetails = PaymentDetails.fromJson(responseData);
//
//       if (mounted) {
//         // Close any open dialogs
//         Navigator.of(
//           context,
//           rootNavigator: true,
//         ).popUntil((route) => route.isFirst);
//
//         // Navigate to payment details screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 PaymentDetailsScreen(paymentDetails: paymentDetails),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         // Close any open dialogs
//         Navigator.of(
//           context,
//           rootNavigator: true,
//         ).popUntil((route) => route.isFirst);
//
//         // Show error in dialog
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Payment Response'),
//             content: SingleChildScrollView(
//               child: Text(
//                 'Error processing payment response: $e\n\nRaw response: $response',
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }
//
//   // invokeSetAppInfo() async {
//   //   String? setAppInfoResult = await _fluttersdkPlugin.setAppInfo(
//   //       envValue, _merchantId.text, _appId.text, "Flutter Sdk ");
//   //   setState(() {
//   //     if (setAppInfoResult == '0000') {
//   //       setState(() {
//   //         enableMakePayment = true;
//   //       });
//   //     }else{
//   //       showSnackBar("Login Response => $setAppInfoResult");
//   //     }
//   //     showSnackBar("Login Response => $setAppInfoResult");
//   //     debugPrint("setAppInfoResult => $setAppInfoResult");
//   //     isShow = false;
//   //   });
//   // }
//   // invokeMakePayment(String amount) async {
//   //   var orderId = 100000 + randomNumber.nextInt(900000);
//   //   String invoiceNumber = '000000$orderId';
//   //   String? paymentResponse = "";
//   //   try {
//   //     paymentResponse = await _fluttersdkPlugin.makePayment(
//   //         amount,
//   //         _merchantId.text,
//   //         invoiceNumber,
//   //         _currencyCode.text,
//   //         _emailId.text,
//   //         _secreteKey.text,
//   //         _addParam.text,
//   //         _addParam.text,
//   //         "4");
//   //   } on PlatformException {
//   //     _paymentResponse = "Failed to get response ";
//   //   }
//   //   if (!mounted) return;
//   //   setState(() {
//   //     if (paymentResponse != null) {
//   //       _paymentResponse = paymentResponse;
//   //     }
//   //     debugPrint('Payment Response _paymentResponse => $_paymentResponse');
//   //     debugPrint('Payment Response paymentResponse => $paymentResponse');
//   //     if (_paymentResponse.contains("Transaction successful")) {
//   //       //Navigator.push(context, route)
//   //       showSnackBar("Payment Response => Transaction successful");
//   //       navigateToPaymentDetails(context,_paymentResponse);
//   //       isShow = !isShow;
//   //     } else {
//   //       showSnackBar("Payment Response $_paymentResponse");
//   //
//   //       isShow = !isShow;
//   //     }
//   //   });
//   // }
// }

import 'dart:async';
import 'dart:convert'; // Add this import at the top of the file

import 'package:flutter/material.dart';
import 'package:flutter_payphi_sdk/flutter_payphi_sdk.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PayPhiSdk _payPhiSdk = PayPhiSdk();
  final _formKey = GlobalKey<FormState>();

  // Text controllers with test data
  final _merchantId = TextEditingController(text: 'T_03338');
  final _amountTEC = TextEditingController(text: '20');
  final _emailId = TextEditingController(text: 'test@example.com');
  final _secreteKey = TextEditingController(text: 'abc');
  final _currencyCode = TextEditingController(text: '356');
  final _aggId = TextEditingController(text: '');
  final _appId = TextEditingController(text: '80bc18249511f868');
  final _merchantName = TextEditingController(text: 'Test Merchant');

  // State variables
  bool _isLoading = false;
  bool _isSdkInitialized = false;
  String _sdkVersion = 'Unknown';
  StreamSubscription<dynamic>? _paymentResponseSubscription;
  String _environment = 'QA'; // or 'PROD' for production

  @override
  void initState() {
    super.initState();
    _initializeSdk();
    _setupPaymentListener();
  }

  @override
  void dispose() {
    _amountTEC.dispose();
    _merchantId.dispose();
    _emailId.dispose();
    _secreteKey.dispose();
    _currencyCode.dispose();
    _aggId.dispose();
    _appId.dispose();
    _merchantName.dispose();
    _paymentResponseSubscription?.cancel();
    _payPhiSdk.dispose();
    super.dispose();
  }

  Future<void> _initializeSdk() async {
    try {
      setState(() => _isLoading = true);
      final result = await _payPhiSdk.initialize(
        environment: _environment,
        merchantId: _merchantId.text,
        appId: _appId.text,
        merchantName: _merchantName.text,
      );

      setState(() {
        _isSdkInitialized = (result == '0000');
        if (_isSdkInitialized) {
          _showSnackBar('SDK Initialized Successfully', Colors.green);
        } else {
          _showSnackBar('SDK Initialization Failed: $result', Colors.red);
        }
      });
    } catch (e) {
      setState(() => _isSdkInitialized = false);
      _showSnackBar('SDK Initialization Error: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _setupPaymentListener() {
    _paymentResponseSubscription?.cancel();
    _paymentResponseSubscription = _payPhiSdk.paymentResponseStream.listen(
      (response) {
        if (mounted) {
          _handlePaymentResponse(response);
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() => _isLoading = false);
          _showSnackBar('Payment Error: $error', Colors.red);
        }
      },
      cancelOnError: false,
    );
  }

  void _handlePaymentResponse(dynamic response) {
    if (mounted) {
      setState(() => _isLoading = false);
    }

    try {
      Map<String, dynamic> responseMap = {};

      // Convert response to Map if it's a String
      if (response is String) {
        debugPrint('Received string response: $response');
        try {
          responseMap = _parseResponseString(response);
        } catch (e) {
          debugPrint('Error parsing response: $e');
          _showSnackBar('Error processing payment response', Colors.orange);
          return;
        }
      } else if (response is Map) {
        responseMap = Map<String, dynamic>.from(response);
      } else {
        debugPrint('Unexpected response type: ${response.runtimeType}');
        _showSnackBar('Unexpected response format', Colors.orange);
        return;
      }

      debugPrint('Processed Payment Response: $responseMap');

      // Extract all possible fields with null safety
      final status = _extractField(responseMap, [
        'responseCode',
        'txnResponseCode',
        'txnStatus',
        'resultCode',
        'status',
      ], 'unknown').toLowerCase();

      final message = _extractField(responseMap, [
        'respDescription',
        'txnRespDescription',
        'ResultMessage',
        'message',
        'statusMessage',
      ], 'No message');

      final txnId = _extractField(responseMap, [
        'invoiceNo',
        'txnID',
        'paymentID',
        'merchantTxnNo',
        'transactionId',
      ], 'N/A');

      final resultType = _extractField(responseMap, [
        'ResultType',
        'resultType',
        'paymentStatus',
      ], 'UNKNOWN').toUpperCase();

      final amount = _extractField(responseMap, ['amount', 'txnAmount'], '');
      final paymentMode = _extractField(responseMap, [
        'paymentMode',
        'paymentMethod',
      ], '');
      final paymentDateTime = _extractField(responseMap, [
        'paymentDateTime',
        'txnDate',
      ], '');
      final merchantId = _extractField(responseMap, [
        'merchantId',
        'merchantID',
      ], '');
      final customerEmail = _extractField(responseMap, [
        'customerEmailID',
        'email',
      ], '');

      // Log all extracted fields
      debugPrint('''
    Payment Response:
    Status: $status
    Message: $message
    Transaction ID: $txnId
    Result Type: $resultType
    Amount: $amount
    Payment Mode: $paymentMode
    Date/Time: $paymentDateTime
    Merchant ID: $merchantId
    Customer Email: $customerEmail
    ''');

      // Determine if the payment was successful
      final isSuccess =
          status == '0000' ||
          status == '000' ||
          status == 'success' ||
          resultType.toLowerCase() == 'success' ||
          message.toLowerCase().contains('success') ||
          resultType.toLowerCase() == 'web' ||
          resultType.toLowerCase() == 'completed';

      // Build a detailed message with available information
      final detailedMessage = StringBuffer();
      if (message.isNotEmpty) detailedMessage.writeln(message);
      if (amount.isNotEmpty) detailedMessage.writeln('Amount: $amount');
      if (paymentMode.isNotEmpty)
        detailedMessage.writeln('Payment Mode: $paymentMode');
      if (paymentDateTime.isNotEmpty)
        detailedMessage.writeln('Date/Time: $paymentDateTime');
      if (txnId != 'N/A') detailedMessage.writeln('Transaction ID: $txnId');

      _showPaymentResultDialog(
        status: isSuccess
            ? 'Success'
            : resultType.isNotEmpty
            ? resultType
            : 'Status: $status',
        message: detailedMessage.toString().trim(),
        transactionId: txnId,
      );
    } catch (e) {
      debugPrint('Error processing payment response: $e');
      _showSnackBar(
        'Error processing payment: ${e.toString().split('\n').first}',
        Colors.red,
      );
    }
  }

  // Helper method to extract a field from the response map with multiple possible keys
  String _extractField(
    Map<String, dynamic> response,
    List<String> possibleKeys,
    String defaultValue,
  ) {
    for (var key in possibleKeys) {
      if (response.containsKey(key) && response[key] != null) {
        return response[key].toString().trim();
      }
    }
    return defaultValue;
  }

  // Helper method to parse different string response formats
  Map<String, dynamic> _parseResponseString(String response) {
    try {
      // Try to parse as JSON first
      return Map<String, dynamic>.from(jsonDecode(response));
    } catch (e) {
      // If JSON parsing fails, try the key:value format
      try {
        return response
            .replaceAll('{', '')
            .replaceAll('}', '')
            .split(',')
            .map((e) => e.trim().split(':'))
            .where((e) => e.length >= 2)
            .fold<Map<String, String>>({}, (map, pair) {
              final key = pair[0].trim();
              final value = pair.sublist(1).join(':').trim();
              map[key] = value;
              return map;
            });
      } catch (e) {
        debugPrint('Failed to parse response string: $e');
        return {'error': 'Failed to parse response'};
      }
    }
  }

  Future<void> _makePayment() async {
    debugPrint('Make Payment invoked');
    if (!_formKey.currentState!.validate()) return;
    if (!_isSdkInitialized) {
      _showSnackBar('Please initialize the SDK first', Colors.orange);
      return;
    }

    try {
      setState(() => _isLoading = true);
      await _payPhiSdk.makePayment(
        amount: _amountTEC.text,
        merchantId: _merchantId.text,
        merchantTxnNo: 'TXN_${DateTime.now().millisecondsSinceEpoch}',
        currencyCode: _currencyCode.text,
        customerEmailID: _emailId.text,
        secretKey: _secreteKey.text,
        addlParam1: 'param1',
        addlParam2: 'param2',
        aggregatorID: _aggId.text,
        apiVersion: '4',
      );
      // Don't show success message here as the response will come through the stream
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint('Make Payment Error: $e');
      _showSnackBar('Payment failed: $e', Colors.red);
    }
  }

  void _showPaymentResultDialog({
    required String status,
    required String message,
    required String transactionId,
  }) {
    final isSuccess = status.toLowerCase() == 'success';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          isSuccess ? 'Payment Successful' : 'Payment Failed',
          style: TextStyle(color: isSuccess ? Colors.green : Colors.red),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSuccess) ...[
                const Text(
                  'We encountered an issue with your payment:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
              _buildInfoRow('Status', status),
              if (transactionId.isNotEmpty)
                _buildInfoRow('Transaction ID', transactionId),
              _buildInfoRow('Message', message),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          if (!isSuccess) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // _makePayment(); // Retry payment
              },
              child: const Text(''),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, [Color? color]) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PayPhi SDK Demo'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Environment Selection
                    const Text(
                      'Environment',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _environment,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: ['INT', 'QA', 'PREPROD', 'dev', 'PROD'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _environment = newValue;
                            _isSdkInitialized = false;
                          });
                          _initializeSdk();
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Merchant ID
                    TextFormField(
                      controller: _merchantId,
                      decoration: const InputDecoration(
                        labelText: 'Merchant ID',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    // App ID
                    TextFormField(
                      controller: _appId,
                      decoration: const InputDecoration(
                        labelText: 'App ID',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    // Merchant Name
                    TextFormField(
                      controller: _merchantName,
                      decoration: const InputDecoration(
                        labelText: 'Merchant Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    // Amount
                    TextFormField(
                      controller: _amountTEC,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required';
                        if (double.tryParse(value!) == null)
                          return 'Enter valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Email
                    TextFormField(
                      controller: _emailId,
                      decoration: const InputDecoration(
                        labelText: 'Customer Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required';
                        if (!value!.contains('@')) return 'Enter valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Secret Key
                    TextFormField(
                      controller: _secreteKey,
                      decoration: const InputDecoration(
                        labelText: 'Secret Key',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    // Currency Code
                    TextFormField(
                      controller: _currencyCode,
                      decoration: const InputDecoration(
                        labelText: 'Currency Code',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    // Aggregator ID
                    TextFormField(
                      controller: _aggId,
                      decoration: const InputDecoration(
                        labelText: 'Aggregator ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // SDK Status
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            _isSdkInitialized
                                ? Icons.check_circle
                                : Icons.error,
                            color: _isSdkInitialized
                                ? Colors.green
                                : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isSdkInitialized ? 'SDK Ready' : 'SDK Not Ready',
                            style: TextStyle(
                              color: _isSdkInitialized
                                  ? Colors.green
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _initializeSdk,
                            child: const Text('Reinitialize'),
                          ),
                        ],
                      ),
                    ),

                    // Make Payment Button
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isSdkInitialized && !_isLoading
                          ? _makePayment
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: _isSdkInitialized
                            ? null
                            : Colors.grey[300],
                        foregroundColor: _isSdkInitialized
                            ? null
                            : Colors.grey[600],
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Make Payment',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
