import Flutter
import UIKit
import CommonCrypto
import customersdk            // vendored framework

// MARK: - Listeners ----------------------------------------------------------

public final class SampleAppListener: AppInitializationListener {
  private let callback: (String?) -> Void
  public init(callback: @escaping (String?) -> Void) { self.callback = callback }
  public func onSuccess(status: String?) { callback(status) }
  public func onFailure(errorCode: String?) { callback(nil) }
}

public final class SamplePaymentListener: PayPhiSdk.IAppPaymentResponseListenerEx {
  private let completion: (_ resultCode: Int, _ data: [String: Any]?) -> Void
  public init(completion: @escaping (_ resultCode: Int, _ data: [String: Any]?) -> Void) {
    self.completion = completion
  }
  public func onPaymentResponse(
    resultCode: Int,
    data: [String : Any]?,
    additionalInfo: [String : String]?
  ) {
    completion(resultCode, data)
  }
  public func onPaymentResponse1(resultCode: Int, data: [String : Any]?) {
    // Older callback – ignore.
  }
}

// MARK: - Plugin --------------------------------------------------------------

@objc(FlutterPayPhiSdkPlugin)
public final class FlutterPayPhiSdkPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

  // Channels
  private var methodChannel: FlutterMethodChannel!
  private var eventChannel: FlutterEventChannel!

  // Streaming sink
  private var eventSink: FlutterEventSink?

  // Pending init result (setAppInfo)
  private var pendingInitResult: FlutterResult?

  // Cached args
  private var cachedEnv: String?
  private var cachedMerchantName: String?

  // Keep strong refs to listeners so they don't dealloc before callback
  private var initListener: SampleAppListener?
  private var paymentListener: SamplePaymentListener?

  // MARK: - Registration
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = FlutterPayPhiSdkPlugin()

    // Match Android channel names
    instance.methodChannel = FlutterMethodChannel(
      name: "customersdk",
      binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(instance, channel: instance.methodChannel)

    instance.eventChannel = FlutterEventChannel(
      name: "payment_response",
      binaryMessenger: registrar.messenger()
    )
    instance.eventChannel.setStreamHandler(instance)
  }

  // MARK: - Method Call Handling
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {

    case "getPlatformVersion":
      result("iOS \(UIDevice.current.systemVersion)")

    case "setAppInfo":
      guard
        let args = call.arguments as? [String: Any]
      else {
        result(FlutterError(code: "ARG_ERROR", message: "Missing arguments", details: nil))
        return
      }
      handleSetAppInfo(args: args, result: result)

    case "makePayment":
      guard
        let args = call.arguments as? [String: Any]
      else {
        result(FlutterError(code: "ARG_ERROR", message: "Missing arguments", details: nil))
        return
      }
      handleMakePayment(args: args)
      // IMPORTANT: do not call result(...) here – Android streams via EventChannel only.
      // Mirror that contract. Send payment result(s) via eventSink.
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - setAppInfo (init SDK)
  private func handleSetAppInfo(args: [String: Any], result: @escaping FlutterResult) {
    guard
      let mid = args["merchantId"] as? String,
      let appId = args["appId"] as? String,
      let env = args["environment"] as? String
    else {
      result(FlutterError(code: "ARG_ERROR", message: "merchantId/appId/environment required", details: nil))
      return
    }

    let merchantName = (args["merchantName"] as? String) ?? "PayPhi Demo (Flutter)"

    cachedEnv = env
    cachedMerchantName = merchantName
    pendingInitResult = result

    Application.shared.setEnv(type: env)
    Application.shared.setMerchantName(name: merchantName)

    initListener = SampleAppListener { [weak self] status in
      guard let self = self else { return }
      let statusStr = status ?? ""
      if statusStr == "0000" {
        self.pendingInitResult?("0000")
      } else {
        self.pendingInitResult?(FlutterError(
          code: statusStr.isEmpty ? "INIT_FAIL" : statusStr,
          message: "SDK initialization failed",
          details: nil
        ))
      }
      self.pendingInitResult = nil
    }

    Application.shared.setAppInfo(
      mid: mid,
      appId: appId,
      listener: initListener!
    )
  }

  // MARK: - makePayment
  private func handleMakePayment(args: [String: Any]) {
    // Android expects these args; mirror that:
    guard
      let amount = args["amount"] as? String,
      let merchantId = args["merchantId"] as? String,
      let merchantTxnNo = args["merchantTxnNo"] as? String,
      let currencyCode = args["currencyCode"] as? String,
      let customerEmailID = args["customerEmailID"] as? String,
      let secretKey = args["secretKey"] as? String
    else {
      sendEventError(code: "ARG_ERROR", message: "Missing required payment fields.")
      return
    }

    // Optional extras
    let addlParam1 = args["addlParam1"] as? String
    let addlParam2 = args["addlParam2"] as? String
    let aggregatorID = args["aggregatorID"] as? String
    let apiVersion = args["apiVersion"] as? String
    let allowDisablePaymentMode = args["allowDisablePaymentMode"] as? String
    let customerID = args["CustomerID"] as? String
    let paymentType = args["paymentType"] as? String
    let vpa = args["vpa"] as? String

    // Format amount -> "%.2f"
    let formattedAmount = formatAmount(amount)

    // Generate SecureToken like Android
    let tokenInput = "\(formattedAmount)\(currencyCode)\(merchantId)\(merchantTxnNo)"
    let secureToken = hmacSHA256(message: tokenInput, key: secretKey)

    // Build paymentData dictionary that SDK expects (mirror the native sample)
    var paymentData: [String: Any] = [
      "Amount": formattedAmount,
      "MerchantID": merchantId,
      "MerchantTxnNo": merchantTxnNo,
      "CurrencyCode": currencyCode,
      "CustomerEmailID": customerEmailID,
      "SecureToken": secureToken
    ]
    if let allow = allowDisablePaymentMode { paymentData["allowDisablePaymentMode"] = allow }
    if let cust = customerID { paymentData["CustomerID"] = cust }
    if let p1 = addlParam1 { paymentData["addlParam1"] = p1 }
    if let p2 = addlParam2 { paymentData["addlParam2"] = p2 }
    if let payType = paymentType { paymentData["PaymentType"] = payType }
    if let vpa = vpa { paymentData["vpa"] = vpa }
    if let agg = aggregatorID { paymentData["aggregatorID"] = agg }
    if let api = apiVersion {
      paymentData["apiVersion"] = api
      print("apiVersion set to: \(api)")
    }

    // Capture callbacks from SDK
    paymentListener = SamplePaymentListener { [weak self] resultCode, data in
      guard let self = self else { return }

      // Stitch in resultCode so Flutter receives it
      var payload = data ?? [:]
      payload["resultCode"] = resultCode

      // Stream JSON‑serializable map
      self.eventSink?(payload)
    }

   guard let rootVC = UIApplication.pp_topMostViewController() else {
  sendEventError(code: "NO_VIEW", message: "No visible view controller to start payment.")
  return
}


    PayPhiSdk.makePayment(
      context: rootVC,
      paymentData: paymentData,
      display: PayPhiSdk.DIALOG,
      listenerEx: paymentListener!
    )
  }

  // MARK: - Stream Handler
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }

  // MARK: - Helpers ----------------------------------------------------------

  private func sendEventError(code: String, message: String) {
    let payload: [String: Any] = [
      "error": true,
      "code": code,
      "message": message
    ]
    eventSink?(payload)
  }

  private func formatAmount(_ raw: String) -> String {
    if let f = Float(raw) {
      return String(format: "%.2f", f)
    }
    return raw
  }

  private func hmacSHA256(message: String, key: String) -> String {
    guard let keyData = key.data(using: .utf8),
          let msgData = message.data(using: .utf8) else { return "" }

    var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    keyData.withUnsafeBytes { keyPtr in
      msgData.withUnsafeBytes { msgPtr in
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256),
               keyPtr.baseAddress,
               keyData.count,
               msgPtr.baseAddress,
               msgData.count,
               &digest)
      }
    }
    return digest.map { String(format: "%02hhx", $0) }.joined()
  }
}
