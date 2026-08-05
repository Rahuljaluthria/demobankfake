package com.example.demobank1

// DEMONSTRATION PURPOSE ONLY
// Intentionally insecure implementation for cybersecurity research.
// Do not use in production.
//
// MockAccessibilityServiceStub represents an AccessibilityService skeleton.
// This class is declared with android:enabled="false" in AndroidManifest.xml,
// meaning it is PERMANENTLY DISABLED and will NEVER be activated by Android.
//
// It exists solely as a static analysis detection target for the ARGUS platform.
// It reads NO screen content and performs NO harmful actions.

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.util.Log
import android.view.accessibility.AccessibilityEvent

/**
 * DEMONSTRATION PURPOSE ONLY
 *
 * This is a placeholder AccessibilityService implementation.
 * Banking malware commonly abuses the Accessibility API to:
 * - Read text from any app on the screen (credential harvesting)
 * - Perform automated clicks on behalf of the user (fraud automation)
 * - Monitor which banking app is open (targeting)
 *
 * THIS STUB:
 * - Is declared android:enabled="false" — it is NEVER activated
 * - onAccessibilityEvent() does NOTHING with event data
 * - Does NOT read, store, or transmit any accessibility information
 * - Is present purely for ARGUS to detect the pattern
 *
 * The accessibility_service_config.xml referenced in the manifest is a
 * placeholder config that must exist for the manifest to be valid XML,
 * but it configures no capabilities.
 */
class MockAccessibilityServiceStub : AccessibilityService() {

    companion object {
        // DEMONSTRATION PURPOSE ONLY
        private const val TAG = "NovaBank_A11Y_DEMO"

        // DEMONSTRATION PURPOSE ONLY — mock event types that malware typically listens to
        // Listed here for ARGUS pattern detection only; they are never registered
        private val MOCK_MALWARE_EVENT_TYPES = listOf(
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED,
            AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED,
            AccessibilityEvent.TYPE_VIEW_FOCUSED,
        )
    }

    override fun onServiceConnected() {
        // DEMONSTRATION PURPOSE ONLY
        // A real malicious accessibility service would configure itself here with:
        // serviceInfo.eventTypes = AccessibilityEvent.TYPES_ALL_MASK
        // serviceInfo.packageNames = null (monitor ALL apps)
        // serviceInfo.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
        //
        // THIS STUB DOES NOT CONFIGURE ANY CAPABILITIES.
        Log.d(TAG, "ARGUS DEMO: MockAccessibilityServiceStub.onServiceConnected() — stub only, no capabilities configured")
        super.onServiceConnected()

        // DEMONSTRATION PURPOSE ONLY — log the mock malware event types that would be monitored
        Log.d(TAG, "ARGUS DEMO: Mock target event types (not registered): $MOCK_MALWARE_EVENT_TYPES")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // DEMONSTRATION PURPOSE ONLY
        // In a real attack, this method would inspect event.source to extract text
        // from the currently focused view — capturing passwords, card numbers, etc.
        //
        // THIS IMPLEMENTATION INTENTIONALLY DOES NOTHING WITH THE EVENT.
        // The event parameter is ignored completely.
        Log.d(TAG, "ARGUS DEMO: onAccessibilityEvent called — no action taken (stub)")
    }

    override fun onInterrupt() {
        // DEMONSTRATION PURPOSE ONLY — no-op stub
        Log.d(TAG, "ARGUS DEMO: onInterrupt called — no action taken (stub)")
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "ARGUS DEMO: MockAccessibilityServiceStub destroyed")
    }
}
