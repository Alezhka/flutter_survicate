import Flutter
import UIKit
import Survicate

public class SwiftFlutterSurvicatePlugin: NSObject, FlutterPlugin {
    
    private var channel: FlutterMethodChannel? = nil
    private var eventChannel: FlutterEventChannel? = nil
    
    private var messageStreamHandler: SwiftStreamHandler?
    private var survicateDelegate: FlutterSurvicateDelegate?
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlutterSurvicatePlugin()
    instance.channel = FlutterMethodChannel(name: "survicate", binaryMessenger: registrar.messenger())
    instance.eventChannel = FlutterEventChannel(name: "events", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: instance.channel!)
    instance.messageStreamHandler = SwiftStreamHandler()
    instance.eventChannel?.setStreamHandler((instance.messageStreamHandler as! FlutterStreamHandler & NSObjectProtocol))
    instance.survicateDelegate = FlutterSurvicateDelegate(instance.messageStreamHandler!)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "init":
            guard let args = call.arguments else {
              return
            }
            if let myArgs = args as? [String: Any],
                let workplaceKey = myArgs["workplaceKey"] as? String,
                let loggerEnabled = myArgs["loggerEnabled"] as? Bool {
                Survicate.shared.setDebuggable(log: loggerEnabled ? LogLevel.verbose : LogLevel.none)
                Survicate.shared.initialize()
                Survicate.shared.delegate = survicateDelegate
                Survicate.shared.setApiKey(workplaceKey)
            }
            
            result(nil)
            return
        case "reset":
            Survicate.shared.reset()
            result(nil)
            return
        case "enterScreen":
            guard let args = call.arguments else {
              return
            }
            if let myArgs = args as? [String: Any],
                let screenName = myArgs["screenName"] as? String {
                Survicate.shared.enterScreen(value: screenName)
            }
            
            result(nil)
            return
        case "leaveScreen":
            guard let args = call.arguments else {
              return
            }
            if let myArgs = args as? [String: Any],
                let screenName = myArgs["screenName"] as? String {
                Survicate.shared.leaveScreen(value: screenName)
            }
            
            result(nil)
            return
        case "invokeEvent":
            guard let args = call.arguments else {
              return
            }
            if let myArgs = args as? [String: Any],
                let eventName = myArgs["eventName"] as? String {
                Survicate.shared.invokeEvent(name: eventName)
            }
            
            result(nil)
            return
        case "setUserTrait":
            guard let args = call.arguments else {
              return
            }
            if let myArgs = args as? [String: Any],
                let key = myArgs["key"] as? String,
                let value = myArgs["value"] as? String {
                Survicate.shared.setUserTrait(UserTrait(withName: key, value: value))
            }

            result(nil)
            return
        case "setUserTraits":
            guard let args = call.arguments else {
              return
            }
            if let myArgs = args as? [String: Any],
                let traits = myArgs["traits"] as? [String: String] {
                var proofTraits: [UserTrait] = []
                for (k, v) in traits {
                    proofTraits.append(UserTrait(withName: k, value: v))
                }
                Survicate.shared.setUserTraits(traits: proofTraits)
            }
            
            result(nil)
            return
        default:
            result(FlutterMethodNotImplemented)
        }
    }

}

class SwiftStreamHandler: FlutterStreamHandler {
    
    var eventSink: FlutterEventSink?
    
    public func send(channel: String, event: String, data: [String: Any]) {
        let data: [String : Any] = [
            "channel": channel,
            "event": event,
            "body": data
        ]
        eventSink?(data)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
}

class FlutterSurvicateDelegate : SurvicateDelegate {
    
    let handler: SwiftStreamHandler
    
    init(_ handler: SwiftStreamHandler) {
        self.handler = handler
    }
    
    public func surveyDisplayed(surveyId: String) {
        let data = ["surveyId": surveyId]
        handler.send(channel: "events", event: "onSurveyDisplayed", data: data)
    }

    public func questionAnswered(surveyId: String, questionId: Int, answer: SurvicateAnswer) {
        let answer: [String: Any?] = [
            "id": answer.id,
            "ids": answer.ids,
            "type": answer.type,
            "value": answer.value
        ]
        let data: [String: Any] = [
            "surveyId": surveyId,
            "questionId": questionId,
            "answer": answer
        ]
        handler.send(channel: "events", event: "onSurveyClosed", data: data)
    }

    public func surveyCompleted(surveyId: String) {
        let data = ["surveyId": surveyId]
        handler.send(channel: "events", event: "onSurveyCompleted", data: data)
    }

    public func surveyClosed(surveyId: String) {
        let data = ["surveyId": surveyId]
        handler.send(channel: "events", event: "onSurveyClosed", data: data)
    }
    
}
