# flutter_survicate

<a href="https://pub.dev/packages/flutter_survicate"><img src="https://img.shields.io/badge/pub-v0.0.1+2-blue" alt="Pub"></a>
---

Survicate Flutter plugin.


## Get started

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

## Init library
```
FlutterSurvicate.init("YOUR_WORKPLACE_KEY", true);
```

## Explore methods
```
FlutterSurvicate.onEvent.listen((event) {});
FlutterSurvicate.enterScreen('screen');
FlutterSurvicate.leaveScreen('screen');
FlutterSurvicate.invokeEvent('survey_event');
FlutterSurvicate.reset();
FlutterSurvicate.setUserTrait(UserTrait.email('abc@some.xyz'));
FlutterSurvicate.setUserTraits([UserTrait.email('abc@some.xyz'), UserTrait.userId('1234')]);
```
