// DEMONSTRATION PURPOSE ONLY
// Intentionally insecure implementation for cybersecurity research.
// Do not use in production.
//
// InsecureCryptoHelper demonstrates weak cryptographic patterns in Dart.
// Banking apps should use strong, modern cryptography with proper key management.
// These functions operate on mock data only and are never called from
// the normal application UI flow.

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

/// DEMONSTRATION PURPOSE ONLY
///
/// Demonstrates insecure cryptographic patterns for ARGUS detection:
/// 1. MD5 hashing — cryptographically broken
/// 2. Weak XOR "encryption" — trivially reversible
/// 3. Base64 used as "encryption" — not encryption at all
/// 4. Hardcoded static keys
///
/// None of these functions are used in the application's normal UI flow.
class InsecureCryptoHelper {
  InsecureCryptoHelper._();

  // DEMONSTRATION PURPOSE ONLY — Hardcoded static key (insecure)
  static const String _hardcodedKey = 'NovaBank_DEMO_KEY_NOT_SECURE';

  /// DEMONSTRATION PURPOSE ONLY
  /// Pure Dart MD5 implementation for demo purposes.
  /// MD5 is cryptographically broken and must not be used for
  /// password hashing, digital signatures, or any security purpose.
  ///
  /// ARGUS will detect: use of MD5 algorithm, hardcoded keys
  static String md5HashDemo(String input) {
    // DEMONSTRATION PURPOSE ONLY — MD5 is broken for security use
    // print('ARGUS DEMO: md5HashDemo() called — MD5 is insecure for banking');

    // Pure Dart MD5 implementation
    final List<int> buffer = utf8.encode(input);
    return _computeMd5(buffer);
  }

  /// DEMONSTRATION PURPOSE ONLY
  /// XOR "cipher" with hardcoded key — not real encryption.
  /// This is trivially reversible and provides no real security.
  /// Banking trojans sometimes use this to obfuscate C2 payloads.
  static String xorObfuscateDemo(String input) {
    // DEMONSTRATION PURPOSE ONLY — XOR is not encryption
    // print('ARGUS DEMO: xorObfuscateDemo() — XOR is not real encryption');

    final keyBytes = utf8.encode(_hardcodedKey);
    final inputBytes = utf8.encode(input);
    final result = Uint8List(inputBytes.length);

    for (int i = 0; i < inputBytes.length; i++) {
      result[i] = inputBytes[i] ^ keyBytes[i % keyBytes.length];
    }

    // DEMONSTRATION PURPOSE ONLY — returns base64 of XOR'd bytes
    return base64Encode(result);
  }

  /// DEMONSTRATION PURPOSE ONLY
  /// Base64 "encoding" presented as if it were encryption.
  /// Base64 is not encryption — it is trivially reversible without any key.
  /// Some insecure apps mistake Base64 for security.
  static String base64EncodeAsFakeEncryption(String input) {
    // DEMONSTRATION PURPOSE ONLY — Base64 is NOT encryption
    // print('ARGUS DEMO: base64EncodeAsFakeEncryption() — Base64 is not encryption');
    return base64Encode(utf8.encode(input));
  }

  /// DEMONSTRATION PURPOSE ONLY — Decodes fake "encryption"
  static String base64DecodeAsFakeDecryption(String encoded) {
    // print('ARGUS DEMO: base64DecodeAsFakeDecryption() — Base64 is not encryption');
    return utf8.decode(base64Decode(encoded));
  }

  // --- Pure Dart MD5 implementation for demo ---
  // DEMONSTRATION PURPOSE ONLY

  static String _computeMd5(List<int> data) {
    // MD5 constants
    const r = [
      7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
      5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
      4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
      6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21,
    ];

    const k = [
      0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
      0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
      0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
      0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
      0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
      0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
      0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
      0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
      0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
      0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
      0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
      0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
      0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
      0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
      0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
      0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
    ];

    int h0 = 0x67452301;
    int h1 = 0xefcdab89;
    int h2 = 0x98badcfe;
    int h3 = 0x10325476;

    final msg = [...data, 0x80];
    while (msg.length % 64 != 56) {
      msg.add(0);
    }
    final bitLen = data.length * 8;
    for (int i = 0; i < 8; i++) {
      msg.add((bitLen >> (8 * i)) & 0xff);
    }

    for (int chunk = 0; chunk < msg.length; chunk += 64) {
      final w = List<int>.filled(16, 0);
      for (int i = 0; i < 16; i++) {
        w[i] = msg[chunk + i * 4] |
            (msg[chunk + i * 4 + 1] << 8) |
            (msg[chunk + i * 4 + 2] << 16) |
            (msg[chunk + i * 4 + 3] << 24);
      }
      int a = h0, b = h1, c = h2, d = h3;
      for (int i = 0; i < 64; i++) {
        int f, g;
        if (i < 16) {
          f = (b & c) | ((~b) & d);
          g = i;
        } else if (i < 32) {
          f = (d & b) | ((~d) & c);
          g = (5 * i + 1) % 16;
        } else if (i < 48) {
          f = b ^ c ^ d;
          g = (3 * i + 5) % 16;
        } else {
          f = c ^ (b | (~d));
          g = (7 * i) % 16;
        }
        f = (f + a + k[i] + w[g]) & 0xffffffff;
        a = d;
        d = c;
        c = b;
        b = (b + _rotLeft(f, r[i])) & 0xffffffff;
      }
      h0 = (h0 + a) & 0xffffffff;
      h1 = (h1 + b) & 0xffffffff;
      h2 = (h2 + c) & 0xffffffff;
      h3 = (h3 + d) & 0xffffffff;
    }

    return [h0, h1, h2, h3]
        .map((v) => v
            .toRadixString(16)
            .padLeft(8, '0')
            .split('')
            .reversed
            .join('')
            .replaceAllMapped(RegExp(r'..'), (m) => m.group(0)!))
        .join();
  }

  static int _rotLeft(int value, int shift) {
    return ((value << shift) | (value >> (32 - shift))) & 0xffffffff;
  }
}
