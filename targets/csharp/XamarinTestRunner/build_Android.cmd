set CSProj=XamarinTestRunner\XamarinTestRunner.Android\XamarinTestRunner.Android.csproj
nuget restore %CSProj%
msbuild %CSProj% -t:Restore
msbuild %CSProj% ^
    -t:SignAndroidPackage ^
    -p:Configuration=Debug ^
    -p:EmbedAssembliesIntoApk=true ^
    -p:AndroidSdkDirectory=%ANDROID_HOME%
