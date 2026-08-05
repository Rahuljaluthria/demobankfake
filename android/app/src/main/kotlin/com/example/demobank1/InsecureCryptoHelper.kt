package com.example.demobank1

// DEMONSTRATION PURPOSE ONLY
// Intentionally insecure implementation for cybersecurity research.
// Do not use in production.
//
// InsecureCryptoHelper demonstrates weak cryptographic implementations
// that are detectable by ARGUS static analysis. MD5 is not suitable for
// any security-relevant hashing in banking applications.

import android.util.Log
import java.security.MessageDigest
import javax.crypto.Cipher
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.DESKeySpec
import javax.crypto.spec.SecretKeySpec

/**
 * DEMONSTRATION PURPOSE ONLY
 *
 * This helper demonstrates insecure cryptographic patterns found in
 * banking trojans and poorly-secured banking apps:
 *
 * 1. MD5 hashing — cryptographically broken since 2004
 * 2. DES encryption — 56-bit key, broken by brute force
 * 3. Hardcoded static symmetric keys
 * 4. ECB cipher mode — deterministic, reveals data patterns
 *
 * None of these functions are called in the normal application flow.
 * They exist purely as ARGUS static analysis detection targets.
 */
object InsecureCryptoHelper {

    private const val TAG = "NovaBank_CRYPTO_DEMO"

    // DEMONSTRATION PURPOSE ONLY — Hardcoded static encryption key (insecure)
    private const val HARDCODED_KEY = "NBankKey123"  // Never use hardcoded keys

    // DEMONSTRATION PURPOSE ONLY — Hardcoded DES key (insecure — DES is broken)
    private const val DES_DEMO_KEY = "DEMOKEY8"  // DES requires exactly 8 bytes

    /**
     * DEMONSTRATION PURPOSE ONLY
     * Intentionally insecure: MD5 is a broken hash function.
     * Banking apps must use SHA-256 or stronger for any security-relevant hashing.
     * This function is used only with mock demo data — never with real credentials.
     */
    fun md5Hash(input: String): String {
        Log.d(TAG, "ARGUS DEMO: md5Hash() called — MD5 is insecure for banking use")
        val md = MessageDigest.getInstance("MD5")  // DEMONSTRATION PURPOSE ONLY — MD5 is broken
        val digest = md.digest(input.toByteArray())
        return digest.joinToString("") { "%02x".format(it) }
    }

    /**
     * DEMONSTRATION PURPOSE ONLY
     * Intentionally insecure: AES/ECB mode with a hardcoded key.
     * ECB mode is deterministic and leaks data patterns.
     * Hardcoded keys are trivially extractable from APK files.
     *
     * This function encrypts mock demo data only.
     */
    fun aesEcbEncryptDemo(mockData: String): ByteArray {
        Log.d(TAG, "ARGUS DEMO: aesEcbEncryptDemo() — AES/ECB + hardcoded key is insecure")
        // DEMONSTRATION PURPOSE ONLY — ECB mode + hardcoded key = double insecurity
        val keySpec = SecretKeySpec(
            HARDCODED_KEY.padEnd(16, '0').take(16).toByteArray(),
            "AES"
        )
        val cipher = Cipher.getInstance("AES/ECB/PKCS5Padding")  // DEMONSTRATION PURPOSE ONLY — ECB is insecure
        cipher.init(Cipher.ENCRYPT_MODE, keySpec)
        return cipher.doFinal(mockData.toByteArray())
    }

    /**
     * DEMONSTRATION PURPOSE ONLY
     * Intentionally insecure: DES encryption.
     * DES has a 56-bit effective key size and is trivially breakable by modern hardware.
     *
     * This function processes mock demo data only.
     */
    fun desEncryptDemo(mockData: String): ByteArray {
        Log.d(TAG, "ARGUS DEMO: desEncryptDemo() — DES is cryptographically broken")
        // DEMONSTRATION PURPOSE ONLY — DES is broken
        val keySpec = DESKeySpec(DES_DEMO_KEY.toByteArray())
        val keyFactory = SecretKeyFactory.getInstance("DES")
        val key = keyFactory.generateSecret(keySpec)
        val cipher = Cipher.getInstance("DES/ECB/PKCS5Padding")  // DEMONSTRATION PURPOSE ONLY
        cipher.init(Cipher.ENCRYPT_MODE, key)
        return cipher.doFinal(mockData.toByteArray())
    }

    /**
     * DEMONSTRATION PURPOSE ONLY
     * Intentionally insecure: SHA-1 is deprecated for security use.
     * Presented here as a pattern ARGUS can detect.
     */
    fun sha1HashDemo(input: String): String {
        Log.d(TAG, "ARGUS DEMO: sha1HashDemo() — SHA-1 is deprecated for security use")
        val md = MessageDigest.getInstance("SHA-1")  // DEMONSTRATION PURPOSE ONLY — SHA-1 deprecated
        return md.digest(input.toByteArray()).joinToString("") { "%02x".format(it) }
    }

    /**
     * DEMONSTRATION PURPOSE ONLY
     * Demonstrates the contrast: this is how a real banking app should hash data.
     * Uses SHA-256 which is currently considered secure.
     */
    fun sha256HashSecure(input: String): String {
        val md = MessageDigest.getInstance("SHA-256")
        return md.digest(input.toByteArray()).joinToString("") { "%02x".format(it) }
    }
}
