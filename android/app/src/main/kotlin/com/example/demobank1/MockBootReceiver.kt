package com.example.demobank1

// DEMONSTRATION PURPOSE ONLY
// Intentionally insecure implementation for cybersecurity research.
// Do not use in production.
//
// MockBootReceiver listens for BOOT_COMPLETED intents.
// It is exported with no permission guard (insecure).
// In real banking malware, boot receivers are used to ensure persistence —
// the malware re-starts its overlay/accessibility service after every device reboot.
//
// THIS RECEIVER DOES ABSOLUTELY NOTHING ON RECEIPT OF THE BROADCAST.
// It is a non-functional stub for ARGUS static analysis detection only.

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * DEMONSTRATION PURPOSE ONLY
 *
 * Boot persistence receiver stub.
 * Banking malware uses this pattern to:
 * 1. Restart overlay services after device reboot
 * 2. Re-establish C2 connections
 * 3. Re-enable accessibility service monitoring
 *
 * THIS STUB DOES NONE OF THOSE THINGS.
 * onReceive() logs a debug message and returns immediately.
 *
 * ARGUS detection targets:
 * - BroadcastReceiver with android:exported="true" (no permission guard)
 * - Registers for android.intent.action.BOOT_COMPLETED
 */
class MockBootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        // DEMONSTRATION PURPOSE ONLY
        // A real persistence receiver would start MockOverlayService here:
        //   context.startService(Intent(context, MockOverlayService::class.java))
        //
        // THIS IMPLEMENTATION DOES NOTHING — for ARGUS detection only.
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            Log.d(
                "NovaBank_BOOT_DEMO",
                "ARGUS DEMO: MockBootReceiver.onReceive() — BOOT_COMPLETED received, NO ACTION TAKEN (stub)"
            )
        }
    }
}
