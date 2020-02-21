#!/bin/bash

set -e

pushd ../../sdks/$SdkName/build/Android
AndroidProjectPath=$PWD
popd

debugApkPath=$AndroidProjectPath/app/build/outputs/apk/debug/app-debug.apk
releaseApkPath=$AndroidProjectPath/app/build/outputs/apk/release/app-release-unsigned.apk
testAssemblyDir="$1"

CopyTestTitleData() {
    cp -f "$WORKSPACE/JenkinsSdkSetupScripts/Creds/testTitleData.json" "$AndroidProjectPath/app/src/main/assets"
}

BuildAPK() {
    pushd "$AndroidProjectPath"

    # "assembleDebug" Builds the Debug APK
    ./gradlew assembleDebug

    # "build" Builds the Debug and Release APK's
    # ./gradlew build

    if [ ! -f "$debugApkPath" ]; then
        echo "Expected debug APK file was not created"
        exit 1
    fi
    if [ ! -f "$releaseApkPath" ]; then
        echo "Expected release APK file was not created"
        # exit 1 - This is acceptable (for now)
    fi

    popd
}

TestAPK() {
    # Prefer the debug apk for now
    if [ -f "$debugApkPath" ]; then
        appcenter test run uitest --app "PlayFabSDKTeam/PlayFabXPlatAndroid" \
        --devices "PlayFabSDKTeam/android-common" \
        --app-path "$debugApkPath"  \
        --test-series "master" \
        --locale "en_US" \
        --build-dir "$testAssemblyDir"  \
        --uitest-tools-dir "$XAMARIN_UITEST_TOOLS"
    elif [ -f "$releaseApkPath" ]; then
        appcenter test run uitest --app "PlayFabSDKTeam/PlayFabXPlatAndroid" \
        --devices "PlayFabSDKTeam/android-common" \
        --app-path "$releaseApkPath"  \
        --test-series "master" \
        --locale "en_US" \
        --build-dir "$testAssemblyDir"  \
        --uitest-tools-dir "$XAMARIN_UITEST_TOOLS"
    fi
}

DoWork() {
    CopyTestTitleData
    if [ "$TestGradleBuild" = "true" ]; then
        BuildAPK
        if [ "$TestOnAppCenter" = "true" ]; then
            TestAPK
        fi
    fi
}

DoWork
