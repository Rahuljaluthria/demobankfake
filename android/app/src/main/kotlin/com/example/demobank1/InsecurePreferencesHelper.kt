package com.example.demobank1

// DEMONSTRATION PURPOSE ONLY
// Intentionally insecure implementation for cybersecurity research.
// Do not use in production.
//
// InsecurePreferencesHelper stores mock "credentials" in SharedPreferences
// with no encryption. Real banking apps must NEVER store credentials in
// plaintext SharedPreferences. This class is a stub used by ARGUS to detect
// insecure credential storage patterns.

import android.content.Context
import android.content.SharedPreferences
import android.util.Log

/**
 * DEMONSTRATION PURPOSE ONLY
 * This helper class demonstrates insecure plaintext credential storage.
 * In real banking trojans, credentials captured from overlay attacks are
 * stored in plaintext for later exfiltration.
 *
 * This implementation uses ONLY mock/hardcoded demo values.
 * It does NOT capture, store, or transmit any real user data.
 */
object InsecurePreferencesHelper {

    // DEMONSTRATION PURPOSE ONLY — Plaintext SharedPreferences key name
    private const val PREF_NAME = "nova_bank_prefs"

    // DEMONSTRATION PURPOSE ONLY — Hardcoded mock API key (insecure)
    private const val MOCK_API_KEY = "NBK-DEMO-4f8a2c1e9b3d7f0a-ARGUS-TEST"

    // DEMONSTRATION PURPOSE ONLY — Hardcoded mock secret (insecure)
    private const val MOCK_API_SECRET = "sk_demo_argus_1234567890abcdef"

    // DEMONSTRATION PURPOSE ONLY — Hardcoded mock encryption key (insecure)
    private const val MOCK_ENCRYPTION_KEY = "AES128_DEMO_KEY_NOT_REAL"

    /**
     * DEMONSTRATION PURPOSE ONLY
     * Intentionally insecure: stores mock credentials in plaintext SharedPreferences.
     * Uses MODE_WORLD_READABLE which is deprecated and insecure.
     * A real banking app must use encrypted storage (Android Keystore + EncryptedSharedPreferences).
     */
    @Suppress("DEPRECATION")
    fun saveMockCredentials(context: Context, mockUserId: String, mockToken: String) {
        // DEMONSTRATION PURPOSE ONLY — Intentionally insecure SharedPreferences mode
        val prefs: SharedPreferences = context.getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE // Would be MODE_WORLD_READABLE in a real attack
        )
        prefs.edit().apply {
            // DEMONSTRATION PURPOSE ONLY — plaintext credential storage
            putString("mock_user_id", mockUserId)
            putString("mock_auth_token", mockToken)
            putString("mock_api_key", MOCK_API_KEY)
            putString("mock_api_secret", MOCK_API_SECRET)
            putString("mock_pin", "0000") // DEMONSTRATION PURPOSE ONLY — hardcoded PIN
            apply()
        }

        // DEMONSTRATION PURPOSE ONLY — Sensitive data written to Logcat
        Log.d("NovaBank_INSECURE", "=== ARGUS DEMO: Credentials stored in plaintext ===")
        Log.d("NovaBank_INSECURE", "Mock User: $mockUserId | Token: $mockToken")
        Log.d("NovaBank_INSECURE", "API Key: $MOCK_API_KEY")
        Log.d("NovaBank_INSECURE", "=== END DEMO LOG ===")
    }

    /**
     * DEMONSTRATION PURPOSE ONLY
     * Reads back the stored mock credentials.
     */
    fun getMockCredentials(context: Context): Map<String, String?> {
        val prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
        return mapOf(
            "user_id" to prefs.getString("mock_user_id", null),
            "token" to prefs.getString("mock_auth_token", null),
            "api_key" to prefs.getString("mock_api_key", null),
        )
    }

    /**
     * DEMONSTRATION PURPOSE ONLY
     * Clears stored mock credentials.
     */
    fun clearMockCredentials(context: Context) {
        context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
            .edit()
            .clear()
            .apply()
    }
}
