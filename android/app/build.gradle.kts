plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    // id("com.google.firebase:firebase-analytics")
    // id("com.google.firebase:firebase-crashlytics")

}

android {
    namespace = "com.iwip.intplatform"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.iwip.intplatform"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            keyAlias = "intplatform"
            keyPassword = "123456"
            storeFile = file("intplatform.keystore")
            storePassword = "123456"
        }
        // release {
        //     keyAlias = "intplatform"
        //     keyPassword = "123456"
        //     storeFile = file('intplatform.keystore')
        //     storePassword = "123456"
        // }
    }

    buildTypes {
        val mySignConfig = signingConfigs.getByName("release")

        release {
            // zipAlignEnabled = false
            // minifyEnabled = false// 是否混淆
            // shrinkResources = false// 是否去除无效的资源文件
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = mySignConfig
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    // implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
    // implementation(platform("com.google.firebase:firebase-bom:33.1.2"))
    // implementation("com.google.firebase:firebase-analytics")
}