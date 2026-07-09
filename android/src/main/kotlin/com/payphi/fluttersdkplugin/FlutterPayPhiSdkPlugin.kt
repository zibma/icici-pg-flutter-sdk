package com.payphi.fluttersdkplugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import com.payphi.customersdk.utils.HmacUtility
import com.payphi.customersdk.views.Application
import com.payphi.customersdk.views.PayPhiSdk
import com.payphi.customersdk.views.PaymentOptionsActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONException
import org.json.JSONObject
import java.text.DecimalFormat
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

/**
 * FlutterPayPhiSdkPlugin
 */
class FlutterPayPhiSdkPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private val TAG: String = "FlutterPayPhiSdkPlugin"
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null

    private var context: Context? = null
    private var activity: Activity? = null
    private var env: String? = null
    private var merchantName: String? = ""
    private var merchantId: String? = null
    private var appId: String? = null
    private var amount: String? = null
    private val emailId: String? = null
    private val allowDisablePaymentMode: String? = null
    private var secureToken: String? = null
    private var currencyCode: String? = null
    private var addParam1: String? = null
    private var addParam2: String? = null
    private val paymentType: String? = null
    private val vpa: String? = null
    private var merchantTxnNo: String? = null
    private var invoiceNo: String? = null
    private var customerEmailID: String? = null
    private var aggregatorID: String? = null
    private var apiVersion: String? = null

    // Remove the hasReplied flag because we're using an EventChannel for streaming responses.
    private val resultMap = HashMap<String, String>()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "customersdk")
        methodChannel!!.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "payment_response")
        eventChannel!!.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "setAppInfo" -> {
                Log.d("setAppInfo", "Called: ")
                if (call.arguments != null && call.hasArgument("environment") && call.hasArgument("merchantId") && call.hasArgument(
                        "appId"
                    )
                ) {
                    merchantId = call.argument("merchantId")
                    appId = call.argument("appId")
                    env = call.argument("environment")
                    Log.d(
                        "setAppInfoData",
                        "merchantId: $merchantId, appId: $appId, environment: $env"
                    )

                    if (call.hasArgument("merchantName")) {
                        merchantName = call.argument("merchantName")
                    }
                    val application = Application
                    env?.let { application.setEnv(it) }
                    application.setAppInfo(
                        merchantId!!,
                        appId!!,
                        context!!,
                        object : Application.IAppInitializationListener {
                            override fun onSuccess(status: String?) {
                                resultMap["statusCode"] = status.toString()
                                application.setMerchantName(merchantName!!, context!!)
                                result.success(status)
                            }

                            override fun onFailure(errorCode: String?) {
                                resultMap["statusCode"] = errorCode ?: ""
                                when (errorCode) {
                                    "201" -> result.error(
                                        errorCode, "Invalid app credentials", resultMap.toString()
                                    )

                                    "504" -> result.error(
                                        errorCode, "Connection error", resultMap.toString()
                                    )

                                    "205" -> result.error(
                                        errorCode, "Payments not enabled", resultMap.toString()
                                    )

                                    "101" -> result.error(
                                        errorCode,
                                        "Internal error",
                                        "$errorCode, internal error while fetching the payment options"
                                    )

                                    else -> errorCode?.let {
                                        result.error(
                                            it, "Generic error", resultMap.toString()
                                        )
                                    }
                                }
                            }
                        })
                } else {
                    resultMap["statusCode"] = ""
                    result.error("", "Mandatory fields are missing", resultMap.toString())
                }
                resultMap.clear()
            }

            "makePayment" -> {
                if (call.arguments != null && call.hasArgument("amount") && call.hasArgument("merchantId") && call.hasArgument(
                        "merchantTxnNo"
                    ) && call.hasArgument("currencyCode") && call.hasArgument("customerEmailID") && call.hasArgument(
                        "secretKey"
                    )
                ) {
                    amount = call.argument("amount")
                    merchantId = call.argument("merchantId")
                    merchantTxnNo = call.argument("merchantTxnNo")
                    currencyCode = call.argument("currencyCode")
                    customerEmailID = call.argument("customerEmailID")
                    addParam1 = call.argument("addlParam1")
                    addParam2 = call.argument("addlParam2")
                    aggregatorID = call.argument("aggregatorID")
                    apiVersion = call.argument("apiVersion")
                    invoiceNo = call.argument("merchantTxnNo")

                    secureToken = getSecureToken(call.argument("secretKey"))

                    // Create a bundle with all the payment parameters
                    val paymentParams = Bundle().apply {
                        putString("Amount", amount)
                        putString("MerchantID", merchantId)
                        putString("MerchantTxnNo", merchantTxnNo)
                        putString("CurrencyCode", currencyCode)
                        putString("CustomerEmailID", customerEmailID)
                        putString("SecureToken", secureToken)
                        putString("invoiceNo", invoiceNo)
                        if (call.hasArgument("allowDisablePaymentMode")) {
                            putString("allowDisablePaymentMode", allowDisablePaymentMode)
                        }
                        if (call.hasArgument("CustomerID")) {
                            putString("CustomerID", "50000426")
                        }
                        if (call.hasArgument("addlParam1")) {
                            putString("addlParam1", addParam1)
                        }
                        if (call.hasArgument("addlParam2")) {
                            putString("addlParam2", addParam2)
                        }
                        if (call.hasArgument("paymentType")) {
                            putString("PaymentType", paymentType)
                        }
                        if (call.hasArgument("vpa")) {
                            putString("vpa", vpa)
                        }
                        if (call.hasArgument("aggregatorID")) {
                            putString("aggregatorID", aggregatorID)
                        }
                        if (call.hasArgument("apiVersion")) {
                            putString("apiVersion", apiVersion)
                            Log.d(TAG, "apiVersion set to: $apiVersion")
                        }
                    }

                    Log.d(
                        TAG,
                        "makePayment() called with amount: $amount, merchantId: $merchantId, merchantTxnNo: $merchantTxnNo, addParam1: $addParam1, addParam2: $addParam2, aggregatorID: $aggregatorID, apiVersion: $apiVersion"
                    )

                    // Call the payment SDK. Instead of sending a single response via result.success(), we stream responses through eventSink.
                    // Ensure the activity starts in the same task
                    val responseListener = object : PayPhiSdk.IAppPaymentResponseListenerEx {
                        override fun onPaymentResponse(
                            resultCode: Int, data: Intent?, additionalInfo: Map<String?, String?>?
                        ) {
                            val bundleData = data?.extras
                            if (bundleData != null) {
                                for (key in bundleData.keySet()) {
                                    resultMap[key] = bundleData.getString(key).toString()
                                }
                            }
                            val bundleToJsonResult = bundleData?.let { bundleToJson(it) }
                            Log.d(TAG, "onPaymentResponse: bundleToJsonResult $bundleToJsonResult")
                            // Stream every response through the event channel.
                            eventSink?.success(bundleToJsonResult.toString())
                        }

                        override fun onPaymentResponse1(resultCode: Int, data: Intent?) {
                            Log.d(TAG, "onPaymentResponse1: resultCode => $resultCode")
                        }
                    }

                    // Start the payment flow using PayPhiSdk
                    try {
                        // Create an intent for the payment activity using application context
                        val intent = Intent(
                            context?.applicationContext, PaymentOptionsActivity::class.java
                        ).apply {
                            // Add all payment parameters to the intent
                            putExtras(paymentParams)
                            // Ensure the activity is started in the same task
                            addFlags(
                                Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS or Intent.FLAG_ACTIVITY_NO_HISTORY
                            )
                        }

                        // Start the payment flow using the SDK
                        PayPhiSdk.makePayment(
                            context!!, intent, PayPhiSdk.DIALOG, responseListener
                        )
                    } catch (e: Exception) {
                        Log.e(TAG, "Error starting payment: ${e.message}", e)
                        eventSink?.error("PAYMENT_ERROR", e.message, null)
                    }
                }
                // For makePayment, we do not use result.success() here because responses are sent via the event channel.
                resultMap.clear()
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        eventChannel?.setStreamHandler(null)
    }

    // EventChannel.StreamHandler implementations
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    private fun getSecureToken(secretKey: String?): String? {
        val df = DecimalFormat()
        df.minimumFractionDigits = 2
        val f = amount?.toFloat()
        df.format(f)
        amount = String.format("%.2f", f)
        val value = amount + currencyCode + merchantId + merchantTxnNo
        println("TokenString==$value")
        return secretKey?.let { generateHMAC(value, it) }
    }

    private fun generateHMAC(message: String, secretKey: String): String? {
        return try {
            val sha256_HMAC = Mac.getInstance("HmacSHA256")
            val secret_key = SecretKeySpec(secretKey.toByteArray(), "HmacSHA256")
            sha256_HMAC.init(secret_key)
            val hashedBytes = sha256_HMAC.doFinal(message.toByteArray())
            HmacUtility.bytesToHex(hashedBytes)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    fun bundleToJson(bundle: Bundle): JSONObject {
        val json = JSONObject()
        for (key in bundle.keySet()) {
            try {
                json.put(key, JSONObject.wrap(bundle.get(key)))
            } catch (e: JSONException) {
                // Handle exception if needed
            }
        }
        return json
    }
}
