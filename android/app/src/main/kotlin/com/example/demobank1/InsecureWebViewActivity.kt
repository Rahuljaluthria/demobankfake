package com.example.demobank1

// DEMONSTRATION PURPOSE ONLY
// Intentionally insecure implementation for cybersecurity research.
// Do not use in production.
//
// InsecureWebViewActivity demonstrates a WebView configuration with multiple
// insecure settings enabled. This activity is:
// - Exported without permission restrictions (android:exported="true")
// - Never launched by the normal application user interface
// - A static analysis detection target for the ARGUS platform

import android.annotation.SuppressLint
import android.os.Bundle
import android.util.Log
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.app.Activity

/**
 * DEMONSTRATION PURPOSE ONLY
 *
 * This Activity contains an intentionally insecure WebView configuration.
 * Banking trojans commonly use WebViews to:
 * - Display phishing pages that mimic real bank login screens
 * - Execute JavaScript to steal form data
 * - Access local files via file:// URLs
 *
 * INSECURE PATTERNS IN THIS CLASS (ARGUS detection targets):
 * 1. setJavaScriptEnabled(true) — enables JS execution in the WebView
 * 2. setAllowFileAccess(true) — allows file:// URL access
 * 3. setAllowFileAccessFromFileURLs(true) — cross-origin file access
 * 4. setAllowUniversalAccessFromFileURLs(true) — universal file access
 * 5. setDomStorageEnabled(true) — enables local storage
 * 6. Loading from HTTP (cleartext) endpoint: http://api.example.invalid/
 * 7. Exported without permission guard
 *
 * THIS ACTIVITY IS NEVER STARTED BY THE APPLICATION FLOW.
 * It does not display over other apps and performs no phishing.
 */
class InsecureWebViewActivity : Activity() {

    // DEMONSTRATION PURPOSE ONLY — Insecure HTTP endpoint (example.invalid is unreachable)
    private val MOCK_INSECURE_URL = "http://api.example.invalid/nova-bank/login"

    // DEMONSTRATION PURPOSE ONLY — Hardcoded fake auth token
    private val MOCK_HARDCODED_AUTH_TOKEN = "Bearer demo_token_argus_not_real_12345"

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // DEMONSTRATION PURPOSE ONLY
        Log.d("NovaBank_WEBVIEW_DEMO", "InsecureWebViewActivity created — ARGUS detection target")
        Log.d("NovaBank_WEBVIEW_DEMO", "Hardcoded token: $MOCK_HARDCODED_AUTH_TOKEN")

        val webView = WebView(this)
        setContentView(webView)

        val settings: WebSettings = webView.settings

        // DEMONSTRATION PURPOSE ONLY — Intentionally insecure: JS enabled
        @SuppressLint("SetJavaScriptEnabled")
        settings.javaScriptEnabled = true  // DEMONSTRATION PURPOSE ONLY — insecure in banking context

        // DEMONSTRATION PURPOSE ONLY — Intentionally insecure: file access enabled
        settings.allowFileAccess = true  // DEMONSTRATION PURPOSE ONLY — allows file:// access

        // DEMONSTRATION PURPOSE ONLY — Intentionally insecure: cross-origin file access
        @Suppress("DEPRECATION")
        settings.allowFileAccessFromFileURLs = true  // DEMONSTRATION PURPOSE ONLY — deprecated and insecure

        // DEMONSTRATION PURPOSE ONLY — Intentionally insecure: universal file access
        @Suppress("DEPRECATION")
        settings.allowUniversalAccessFromFileURLs = true  // DEMONSTRATION PURPOSE ONLY — highly insecure

        // DEMONSTRATION PURPOSE ONLY — DOM storage enabled
        settings.domStorageEnabled = true

        // DEMONSTRATION PURPOSE ONLY — Mixed content (HTTPS page loading HTTP resources)
        @Suppress("DEPRECATION")
        settings.mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW  // DEMONSTRATION PURPOSE ONLY

        // DEMONSTRATION PURPOSE ONLY — Intentionally loading an HTTP (non-HTTPS) URL
        // api.example.invalid is an RFC 6761 reserved domain that will never resolve
        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView?, url: String?) {
                Log.d("NovaBank_WEBVIEW_DEMO", "ARGUS DEMO: Page loaded: $url")
            }
        }

        // DEMONSTRATION PURPOSE ONLY — This URL will never connect (example.invalid is unreachable)
        webView.loadUrl(MOCK_INSECURE_URL)

        Log.d("NovaBank_WEBVIEW_DEMO", "ARGUS DEMO: Loading insecure URL: $MOCK_INSECURE_URL")
    }
}
