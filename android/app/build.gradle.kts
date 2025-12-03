plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plugin harus setelah Android & Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.tugas_akhir"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // ✅ WAJIB: aktifkan desugaring + set Java 1.8 (aman untuk plugin notifikasi)
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true   // <— ini kuncinya
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.tugas_akhir"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // (opsional) jika butuh
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// ✅ Tambahkan dependencies desugaring (dan multidex opsional)
dependencies {
    // library desugaring untuk Java 8+ API di Android lama
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    // opsional: jika method count besar
    implementation("androidx.multidex:multidex:2.0.1")
}
