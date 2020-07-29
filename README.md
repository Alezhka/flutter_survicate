# flutter_survicate

Survicate Flutter plugin.

## 1. Add share

```
flutter_survicate:
    git:
      url: https://github.com/Alezhka/flutter_survicate.git
```

## 2. Setup platforms

#### Android

In AndroidManifest.xml add:

```
<meta-data
    android:name="com.survicate.surveys.workspaceKey"
    android:value="" />
```

#### IOS

In Info.plist add:

```
<key>Survicate</key>
<dict>
    <key>WorkspaceKey</key>
    <string></string>
</dict>
```

## 3. Explore methods
```
FlutterSurvicate.init("YOUR_WORKPLACE_KEY", true);
FlutterSurvicate.onEvent.listen((event) {});
FlutterSurvicate.enterScreen('screen');
FlutterSurvicate.leaveScreen('screen');
FlutterSurvicate.invokeEvent('survey_event');
FlutterSurvicate.reset();
FlutterSurvicate.setUserTrait(UserTrait.email('abc@some.xyz'));
FlutterSurvicate.setUserTraits([UserTrait.email('abc@some.xyz'), UserTrait.userId('1234')]);
```
