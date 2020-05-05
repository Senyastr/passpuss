package com.example.passpuss

import android.content.Context
import android.content.DialogInterface
import android.hardware.biometrics.BiometricPrompt
import android.os.Build
import android.os.Bundle
import android.os.CancellationSignal
import android.os.PersistableBundle
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyPermanentlyInvalidatedException
import android.security.keystore.KeyProperties
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.IOException
import java.security.*
import java.security.cert.CertificateException
import java.util.concurrent.Executors
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.NoSuchPaddingException
import javax.crypto.SecretKey
import javax.crypto.spec.SecretKeySpec

// DON'T MIND ABOUT THIS ERROR HERE
class MainActivity: FlutterActivity() {
    var CHANNEL : String = "com.flutter.myapp/myapp"
    @RequiresApi(Build.VERSION_CODES.P)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{ call, result ->
            if (call.method == "MYMETHOD"){
                result.success("here we go, i'm invoked")
            }
        }
    }


    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
    }
}
@RequiresApi(Build.VERSION_CODES.P)
class MyCallback : BiometricPrompt.AuthenticationCallback() {

}
