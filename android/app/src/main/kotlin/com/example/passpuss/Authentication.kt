package com.example.passpuss

import android.app.Activity
import android.app.AlertDialog
import android.app.Application
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.view.ContextThemeWrapper
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import androidx.biometric.BiometricPrompt
import androidx.biometric.BiometricPrompt.PromptInfo
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import io.flutter.plugin.common.MethodCall
import java.util.concurrent.Executor


class AuthenticationHelper : androidx.biometric.BiometricPrompt.AuthenticationCallback, Application.ActivityLifecycleCallbacks, DefaultLifecycleObserver {
    private var lifecycle: Lifecycle?
    private var promptInfo: androidx.biometric.BiometricPrompt.PromptInfo? = null
    private val completionHandler : AuthCompletionHandler;
    private lateinit var uiThreadExecutor: UiThreadExecutor
    private val activity : FragmentActivity
    private var biometricPrompt : androidx.biometric.BiometricPrompt? = null
    private val call : MethodCall
    private var stickyAuth : Boolean
    private var activityPasued : Boolean = false
    constructor(completionHandler: AuthCompletionHandler, activity: FragmentActivity, call: MethodCall, lifecycle:Lifecycle?) : super(){
        this.completionHandler = completionHandler
        this.activity = activity
        this.call = call
        this.lifecycle = lifecycle
        uiThreadExecutor = UiThreadExecutor()
        stickyAuth = call.argument("stickyAuth")!!
        promptInfo = PromptInfo.Builder()
                .setDescription(call.argument<Any>("localizedReason") as String?)
                .setTitle((call.argument<Any>("signInTitle") as String?)!!)
                .setSubtitle(call.argument<Any>("fingerprintHint") as String?)
                .setNegativeButtonText((call.argument<Any>("cancelButton") as String?)!!)
                .setConfirmationRequired((call.argument<Any>("sensitiveTransaction") as Boolean?)!!)
                .build()
    }

    fun auth(){
        biometricPrompt = androidx.biometric.BiometricPrompt(activity, uiThreadExecutor, this)
        if (promptInfo != null) {
            biometricPrompt!!.authenticate(promptInfo!!)
        }
    }

    interface AuthCompletionHandler {
        /** Called when authentication was successful.  */
        fun onSuccess()

        /**
         * Called when authentication failed due to user. For instance, when user cancels the auth or
         * quits the app.
         */
        fun onFailure()

        /**
         * Called when authentication fails due to non-user related problems such as system errors,
         * phone not having a FP reader etc.
         *
         * @param code The error code to be returned to Flutter app.
         * @param error The description of the error.
         */
        fun onError(code: String?, error: String?)
    }
    override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
        when (errorCode) {
            BiometricPrompt.ERROR_NO_DEVICE_CREDENTIAL -> completionHandler.onError(
                    "PasscodeNotSet",
                    "Phone not secured by PIN, pattern or password, or SIM is currently locked.")
            BiometricPrompt.ERROR_NO_SPACE, BiometricPrompt.ERROR_NO_BIOMETRICS -> {
                if (call.argument("useErrorDialogs")!!) {
                    showGoToSettingsDialog()
                    return
                }
                completionHandler.onError("NotEnrolled", "No Biometrics enrolled on this device.")
            }
            BiometricPrompt.ERROR_HW_UNAVAILABLE, BiometricPrompt.ERROR_HW_NOT_PRESENT -> completionHandler.onError("NotAvailable", "Biometrics is not available on this device.")
            BiometricPrompt.ERROR_LOCKOUT -> completionHandler.onError(
                    "LockedOut",
                    "The operation was canceled because the API is locked out due to too many attempts. This occurs after 5 failed attempts, and lasts for 30 seconds.")
            BiometricPrompt.ERROR_LOCKOUT_PERMANENT -> completionHandler.onError(
                    "PermanentlyLockedOut",
                    "The operation was canceled because ERROR_LOCKOUT occurred too many times. Biometric authentication is disabled until the user unlocks with strong authentication (PIN/Pattern/Password)")
            BiometricPrompt.ERROR_CANCELED ->         // If we are doing sticky auth and the activity has been paused,
                // ignore this error. We will start listening again when resumed.
                if (activityPasued && stickyAuth) {
                    return
                } else {
                    completionHandler.onFailure()
                }
            else -> completionHandler.onFailure()
        }
        stop()
    }
    fun stopAuthentication() {
        if (biometricPrompt != null) {
            biometricPrompt!!.cancelAuthentication()
            biometricPrompt = null
        }
    }
    private fun showGoToSettingsDialog() {
        val view: View = LayoutInflater.from(activity).inflate(R.layout.go_to_setting, null, false)
        val message: TextView = view.findViewById(R.id.fingerprint_required) as TextView
        val description: TextView = view.findViewById(R.id.go_to_setting_description) as TextView
        message.setText(call.argument<Any>("fingerprintRequired") as String?)
        description.setText(call.argument<Any>("goToSettingDescription") as String?)
        val context: Context = ContextThemeWrapper(activity, R.style.AlertDialogCustom)
        val goToSettingHandler: DialogInterface.OnClickListener = DialogInterface.OnClickListener { dialog, which ->
            completionHandler.onFailure()
            stop()
            activity.startActivity(Intent(Settings.ACTION_SECURITY_SETTINGS))
        }
        val cancelHandler: DialogInterface.OnClickListener = DialogInterface.OnClickListener { dialog, which ->
            completionHandler.onFailure()
            stop()
        }

        AlertDialog.Builder(context)
                .setView(view)
                .setPositiveButton(call.argument<Any>("goToSetting") as String?, goToSettingHandler)
                .setNegativeButton(call.argument<Any>("cancelButton") as String?, cancelHandler)
                .setCancelable(false)
                .show()
    }
    private fun stop() {
        if (lifecycle != null) {
            lifecycle!!.removeObserver(this)
            return
        }
        activity.application.unregisterActivityLifecycleCallbacks(this)
    }
    override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
        completionHandler.onSuccess()
        stop()
    }

    override fun onActivityPaused(activity: Activity) {
        if (stickyAuth) {
            activityPasued = true
        }
    }

    override fun onActivityStarted(ignored: Activity) {
        if (stickyAuth) {
            activityPasued = false
            val prompt = androidx.biometric.BiometricPrompt(activity, uiThreadExecutor, this)
            // When activity is resuming, we cannot show the prompt right away. We need to post it to the
            // UI queue.
            uiThreadExecutor.handler.post { prompt.authenticate(promptInfo!!) }
        }
    }

    override fun onActivityDestroyed(activity: Activity) {
        TODO("Not yet implemented")
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
        TODO("Not yet implemented")
    }

    override fun onActivityStopped(activity: Activity) {
        if (stickyAuth) {
            activityPasued = true
        }
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        TODO("Not yet implemented")
    }

    override fun onActivityResumed(ignored: Activity) {
        // is auth sticky
        if (stickyAuth) {
            activityPasued = false
            val prompt = androidx.biometric.BiometricPrompt(activity, uiThreadExecutor, this)
            // When activity is resuming, we cannot show the prompt right away. We need to post it to the
            // UI queue.
            uiThreadExecutor.handler.post { prompt.authenticate(promptInfo!!) }
        }
    }
    override fun onPause(owner: LifecycleOwner) {
        onActivityPaused(activity)
    }

    override fun onResume(owner: LifecycleOwner) {
        onActivityResumed(activity)
    }

}
private class UiThreadExecutor : Executor {
    val handler: Handler = Handler(Looper.getMainLooper())
    override fun execute(command: Runnable) {
        handler.post(command)
    }
}