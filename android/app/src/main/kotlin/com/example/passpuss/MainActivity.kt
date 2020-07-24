package com.example.passpuss

import android.content.pm.PackageManager
import android.hardware.biometrics.BiometricPrompt
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.concurrent.atomic.AtomicBoolean

// DON'T MIND ABOUT THIS ERROR HERE
class MainActivity: FlutterFragmentActivity() {
    private val channel: MethodChannel? = null
    private var authenticationHelper: AuthenticationHelper? = null
    private val authInProgress: AtomicBoolean = AtomicBoolean(false)
    var CHANNEL_NAME : String = "com.flutter.myapp/myapp"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME).setMethodCallHandler{ call, result ->
            if (call.method.equals("authenticateWithBiometrics")) {
                if (authInProgress.get()) {
                    // Apps should not invoke another authentication request while one is in progress,
                    // so we classify this as an error condition. If we ever find a legitimate use case for
                    // this, we can try to cancel the ongoing auth and start a new one but for now, not worth
                    // the complexity.
                    result.error("auth_in_progress", "Authentication in progress", null)
                    return@setMethodCallHandler
                }

                authInProgress.set(true)
                authenticationHelper = AuthenticationHelper(
                        object : AuthenticationHelper.AuthCompletionHandler {

                            override fun onSuccess() {
                                if (authInProgress.compareAndSet(true, false)) {
                                    result.success(true)
                                }
                            }


                            override fun onFailure() {
                                if (authInProgress.compareAndSet(true, false)) {
                                    result.success(false)
                                }
                            }


                            override fun onError(code: String?, error: String?) {
                                if (authInProgress.compareAndSet(true, false)) {
                                    result.error(code, error, null)
                                }
                            }
                        }, this, call, lifecycle)
                authenticationHelper!!.auth()
            } else if (call.method.equals("getAvailableBiometrics")) {
                try {
                    if (this.isFinishing) {
                        result.error("no_activity", "local_auth plugin requires a foreground activity", null)
                        return@setMethodCallHandler
                    }
                    val biometrics: ArrayList<String> = ArrayList<String>()
                    val packageManager: PackageManager = this.packageManager
                    if (Build.VERSION.SDK_INT >= 23) {
                        if (packageManager.hasSystemFeature(PackageManager.FEATURE_FINGERPRINT)) {
                            biometrics.add("fingerprint")
                        }
                    }
                    if (Build.VERSION.SDK_INT >= 29) {
                        if (packageManager.hasSystemFeature("android.hardware.biometrics.face")) {
                            biometrics.add("face")
                        }
                        if (packageManager.hasSystemFeature("android.hardware.biometrics.iris")) {
                            biometrics.add("iris")
                        }
                    }
                    result.success(biometrics)
                } catch (e: Exception) {
                    result.error("no_biometrics_available", e.message, null)
                }
            } else if (call.method == "stopAuthentication") {
                stopAuthentication(result)
            } else {
                result.notImplemented()
            }
        }
    }
    private fun stopAuthentication(result: MethodChannel.Result) {
        try {
            if (authenticationHelper != null && authInProgress.get()) {
                authenticationHelper!!.stopAuthentication()
                authenticationHelper = null
                result.success(true)
                return
            }
            result.success(false)
        } catch (e: java.lang.Exception) {
            result.success(false)
        }
    }


    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
    }
}
@RequiresApi(Build.VERSION_CODES.P)
class MyCallback : BiometricPrompt.AuthenticationCallback() {

}
