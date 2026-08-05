# Flutter-specific ProGuard rules
# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Don't warn about missing classes from the Flutter engine
-dontwarn io.flutter.embedding.**

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }
