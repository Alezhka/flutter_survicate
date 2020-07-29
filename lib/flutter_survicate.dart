import 'dart:async';

import 'package:flutter/services.dart';

import 'models.dart';
export 'models.dart';

class FlutterSurvicate {
  static const MethodChannel _methodChannel = const MethodChannel('survicate');
  static const EventChannel _eventChannel = const EventChannel('events');

  static Stream<SurvicateEvent> get onEvent =>
      _eventChannel.receiveBroadcastStream().map(_toSurvicateEvent);

  static Future<void> init(String workplaceKey, [bool loggerEnabled]) async {
    _methodChannel.invokeMethod('init', <String, dynamic> {
      'workplaceKey': workplaceKey,
      'loggerEnabled': loggerEnabled ?? false,
    });
  }

  static Future<void> reset() async {
    _methodChannel.invokeMethod('reset');
  }

  static Future<void> enterScreen(String screenName) async {
    _methodChannel.invokeMethod('enterScreen', <String, dynamic>{
      'screenName': screenName,
    });
  }

  static Future<void> leaveScreen(String screenName) async {
    _methodChannel.invokeMethod('leaveScreen', <String, dynamic>{
      'screenName': screenName,
    });
  }

  static Future<void> invokeEvent(String eventName) async {
    _methodChannel.invokeMethod('invokeEvent', <String, dynamic>{
      'eventName': eventName,
    });
  }

  static Future<void> setUserTrait(UserTrait traits) async {
    _methodChannel.invokeMethod('setUserTrait', <String, dynamic>{
      'key': traits.key,
      'value': traits.value,
    });
  }

  static Future<void> setUserTraits(List<UserTrait> traits) async {
    _methodChannel.invokeMethod('setUserTraits', <String, dynamic>{
      'traits': Map.fromIterable(traits, key: (i) => i.key, value: (i) => i.value),
    });
  }

  static SurvicateEvent _toSurvicateEvent(dynamic data) {
    if (data is Map) {
      final event = data['event'];
      final body = new Map<String, dynamic>.from(data['body']);
      switch(event) {
        case 'onSurveyDisplayed':
          return SurveyDisplayed(body['surveyId']);
        case 'onSurveyClosed':
          return SurveyClosed(body['surveyId']);
        case 'onSurveyCompleted':
          return SurveyCompleted(body['surveyId']);
        case 'onQuestionAnswered':
          final answer = body['answer'];
          return QuestionAnswered(body['surveyId'], body['questionId'], SurvicateAnswer(answer['type'], answer['id'], answer['ids'], answer['value']));
      }
    }
    return null;
  }
}
