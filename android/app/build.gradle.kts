plugins {
    id("com.android.application")
    kotlin("android") // Menggunakan helper kotlin()
    id("dev.flutter.flutter-gradle-plugin")
}

// --- PERBAIKAN: SINTAKS KOTLIN MURNI ---
// Mengganti 'def' (Groovy) dengan 'val' (Kotlin)
val localProperties = java.util.Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    // Mengganti 'withReader' (Groovy) dengan sintaks Kotlin
    localPropertiesFile.reader(java.nio.charset.Charset.forName("UTF-8")).use { reader ->
        localProperties.load(reader)
    }
}
// ------------------------------------

// Mengganti delegasi properti dengan 'getProperty' yang lebih aman
val flutterVersionCode: String? = localProperties.getProperty("flutter.versionCode")
val flutterVersionName: String? = localProperties.getProperty("flutter.versionName")

android {
    // Ganti 'com.example.ta_teori' jika nama paket Anda berbeda
    namespace = "com.example.ta_teori" 
    compileSdk = 34 // Versi Anda mungkin berbeda
    ndkVersion = flutter.ndkVersion

    // Ini adalah perbaikan untuk 'flutter_local_notifications'
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        // Ganti 'com.example.ta_teori' jika nama paket Anda berbeda
        applicationId = "com.example.ta_teori"
        minSdk = flutter.minSdkVersion // Versi Anda mungkin berbeda
        targetSdk = 34 // Versi Anda mungkin berbeda
        
        // --- PERBAIKAN: Penanganan Null ---
        versionCode = (flutterVersionCode ?: "1").toInt()
        versionName = flutterVersionName ?: "1.0"
        // ------------------------------------
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // --- PERBAIKAN: Referensi 'kotlin_version' ---
    // Menggunakan helper kotlin() untuk mengatasi 'Unresolved reference: kotlin_version'
    implementation(kotlin("stdlib-jdk7")) 
    // ------------------------------------------
    
    // Ini adalah perbaikan untuk 'flutter_local_notifications'
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
