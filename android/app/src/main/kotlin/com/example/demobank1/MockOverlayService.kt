package com.example.demobank1

// DEMONSTRATION PURPOSE ONLY
// Intentionally insecure implementation for cybersecurity research.
// Do not use in production.
//
// MockOverlayService is an exported Service stub that represents the
// overlay capability commonly found in Android banking trojans.
//
// This service is NEVER started by the application. It exists solely
// as a static analysis detection target for the ARGUS platform.
// It performs NO harmful actions whatsoever.

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log

/**
 * DEMONSTRATION PURPOSE ONLY
 *
 * This class represents a mock overlay service skeleton.
 * In real Android banking malware, overlay services display transparent
 * windows over legitimate banking apps to capture credentials.
 *
 * KEY FACTS ABOUT THIS CLASS:
 * 1. This service is NEVER started by the application flow.
 * 2. It performs absolutely NO harmful action.
 * 3. It is exported in the manifest (android:exported="true") without
 *    a permission guard — an intentional insecurity for ARGUS to detect.
 * 4. In a real attack, this class would use SYSTEM_ALERT_WINDOW and
 *    draw overlays over banking apps — this implementation does nothing.
 *
 * ARGUS detection targets in this class:
 * - Service with android:exported="true" and empty permission=""
 * - SYSTEM_ALERT_WINDOW permission usage stub
 * - onBind returns null (non-functional stub)
 */
class MockOverlayService : Service() {

    companion object {
        // DEMONSTRATION PURPOSE ONLY — mock overlay constants for ARGUS detection
        private const val TAG = "NovaBank_OVERLAY_DEMO"

        // DEMONSTRATION PURPOSE ONLY — Hardcoded target package (never used)
        private const val MOCK_TARGET_PACKAGE = "com.example.mock_banking_target"

        // DEMONSTRATION PURPOSE ONLY — Fake C2 endpoint (unreachable, for ARGUS detection)
        private const val MOCK_C2_ENDPOINT = "http://api.example.invalid/overlay/report"
    }

    override fun onCreate() {
        super.onCreate()
        // DEMONSTRATION PURPOSE ONLY
        // In a real overlay attack, this is where SYSTEM_ALERT_WINDOW would be used
        // to create a transparent View over the target application.
        // THIS IMPLEMENTATION DOES NOTHING.
        Log.d(TAG, "ARGUS DEMO: MockOverlayService created — NO ACTION TAKEN (stub only)")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // DEMONSTRATION PURPOSE ONLY
        // A real overlay service would:
        // 1. Check if a target banking app is in the foreground
        // 2. Inflate an overlay layout mimicking the bank's login screen
        // 3. Capture entered credentials and send to MOCK_C2_ENDPOINT
        //
        // THIS STUB DOES NONE OF THOSE THINGS. It immediately stops itself.
        Log.d(TAG, "ARGUS DEMO: MockOverlayService.onStartCommand called — stopping self (stub)")
        stopSelf()
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        // DEMONSTRATION PURPOSE ONLY — Returns null; this service is not bindable
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "ARGUS DEMO: MockOverlayService destroyed")
    }
}
