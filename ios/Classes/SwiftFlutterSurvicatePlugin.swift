import Flutter
import UIKit
import Survicate

public class SwiftFlutterSurvicatePlugin: NSObject, FlutterPlugin, SurvicateDelegate {
    
    private var channel: FlutterMethodChannel? = nil
    private var eventChannel: FlutterEventChannel? = nil
    
    private var messageStreamHandler: SwiftStreamHandler?
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlutterSurvicatePlugin()
    instance.channel = FlutterMethodChannel(name: "survicate", binaryMessenger: registrar.messenger())
    instance.eventChannel = FlutterEventChannel(name: "events", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: instance.channel!)
    instance.messageStreamHandler = SwiftStreamHandler()
    instance.eventChannel?.setStreamHandler(instance.messageStreamHandler as! FlutterStreamHandler & NSObjectProtocol)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "init":
            guard let args = call.arguments else {
              return
            }
            print("init")
            if let myArgs = args as? [String: Any],
                let workplaceKey = myArgs["workplaceKey"] as? String,
                let loggerEnabled = myArgs["loggerEnabled"] as? Bool {
                Survicate.shared.setDebuggable(log: loggerEnabled ? LogLevel.verbose : LogLevel.none)
                Survicate.shared.initialize()
                Survicate.shared.delegate = self
                Survicate.shared.setApiKey(workplaceKey)
                print("workplaceKey: " + workplaceKey)
                print("init complete")
            }
            
            result(nil)
            break
        case "reset":
            print("reset")
            Survicate.shared.reset()
            result(nil)
            break
        case "enterScreen":
            guard let args = call.arguments else {
              return
            }
            if let myArgs = args as? [String: Any],
                let screenName = myArgs["screenName"] as? String {
                Survicate.shared.enterScreen(value: screenName)
            }
            
            result(nil)
            break
        case "leaveScreen":
            guard let args = call.arguments else {
              return
            }
            if let myArgs = args as? [String: Any],
                let screenName = myArgs["screenName"] as? String {
                Survicate.shared.leaveScreen(value: screenName)
            }
            
            result(nil)
            break
        case "invokeEvent":
            guard let args = call.arguments else {
              return
            }
            if let myArgs = args as? [String: Any],
                let eventName = myArgs["eventName"] as? String {
                Survicate.shared.invokeEvent(name: eventName)
            }
            
            result(nil)
            break
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
            break
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
            break
        default:
            result(FlutterMethodNotImplemented)
        }
        result(FlutterMethodNotImplemented)
    }
    
    public func surveyDisplayed(surveyId: String) {
        let data = ["surveyId": surveyId]
        messageStreamHandler?.send(channel: "events", event: "onSurveyDisplayed", data: data)
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
        messageStreamHandler?.send(channel: "events", event: "onSurveyClosed", data: data)
    }

    public func surveyCompleted(surveyId: String) {
        let data = ["surveyId": surveyId]
        messageStreamHandler?.send(channel: "events", event: "onSurveyCompleted", data: data)
    }

    public func surveyClosed(surveyId: String) {
        let data = ["surveyId": surveyId]
        messageStreamHandler?.send(channel: "events", event: "onSurveyClosed", data: data)
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

}
