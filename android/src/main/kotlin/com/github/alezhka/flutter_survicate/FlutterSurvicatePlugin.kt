package com.github.alezhka.flutter_survicate

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.survicate.surveys.Survicate
import com.survicate.surveys.SurvicateAnswer
import com.survicate.surveys.SurvicateEventListener
import com.survicate.surveys.traits.UserTrait

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FlutterSurvicatePlugin */
class FlutterSurvicatePlugin: FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var methodChannel : MethodChannel
    private lateinit var eventChannel : EventChannel
    private var context: Context? = null

    private val messageStreamHandler = MessageStreamHandler()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      context = flutterPluginBinding.applicationContext
      methodChannel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "survicate")
      methodChannel.setMethodCallHandler(this)
      eventChannel = EventChannel(flutterPluginBinding.flutterEngine.dartExecutor, "events")
      eventChannel.setStreamHandler(messageStreamHandler)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
      methodChannel.setMethodCallHandler(null)
      eventChannel.setStreamHandler(null)
      context = null
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
      when (call.method) {
        "init" -> {
          val loggerEnabled: Boolean = call.argument("loggerEnabled")!!
          val workplaceKey: String = call.argument("workplaceKey")!!
          Survicate.init(context!!, loggerEnabled)
          Survicate.changeWorkspaceKey(workplaceKey)
          Survicate.setEventListener(object: SurvicateEventListener() {

            override fun onSurveyDisplayed(surveyId: String) {
              val data = mapOf("surveyId" to surveyId)
              messageStreamHandler.send("events", "onSurveyDisplayed", data)
            }

            override fun onQuestionAnswered(surveyId: String, questionId: Long, answer: SurvicateAnswer) {
              val data = mapOf(
                      "surveyId" to surveyId,
                      "questionId" to questionId,
                      "answer" to mapOf(
                              "id" to answer.id,
                              "ids" to answer.ids,
                              "type" to answer.type,
                              "value" to answer.value
                      )
              )
              messageStreamHandler.send("events", "onSurveyClosed", data)
            }

            override fun onSurveyClosed(surveyId: String) {
              val data = mapOf("surveyId" to surveyId)
              messageStreamHandler.send("events", "onSurveyClosed", data)
            }

            override fun onSurveyCompleted(surveyId: String) {
              val data = mapOf("surveyId" to surveyId)
              messageStreamHandler.send("events", "onSurveyCompleted", data)
            }

          })
          result.success(null)
        }
        "reset" -> {
          Survicate.reset()
          result.success(null)
        }
        "enterScreen" -> {
          val screenName: String = call.argument("screenName")!!
          Survicate.enterScreen(screenName)
          result.success(null)
        }
        "leaveScreen" -> {
          val screenName: String = call.argument("screenName")!!
          Survicate.leaveScreen(screenName)
          result.success(null)
        }
        "invokeEvent" -> {
          val eventName: String = call.argument("eventName")!!
          Survicate.invokeEvent(eventName)
          result.success(null)
        }
        "setUserTrait" -> {
          val key: String = call.argument("key")!!
          val value: String = call.argument("value")!!
          Survicate.setUserTrait(UserTrait(key, value))
          result.success(null)
        }
        "setUserTraits" -> {
          val map: Map<String, String> = call.argument("traits")!!
          val traits = map.map { UserTrait(it.key, it.value) }
          Survicate.setUserTraits(traits)
          result.success(null)
        }
        else -> {
          result.notImplemented()
        }
      }
    }

    class MessageStreamHandler : EventChannel.StreamHandler {

      private var eventSink: EventChannel.EventSink? = null

      override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
      }

      fun send(channel: String, event: String, data: Map<String, Any>) {
        val data = mapOf(
                "channel" to channel,
                "event" to event,
                "body" to data
        )
        Handler(Looper.getMainLooper()).post {
          eventSink?.success(data)
        }
      }

      override fun onCancel(p0: Any?) {
        eventSink = null
      }
    }
}
