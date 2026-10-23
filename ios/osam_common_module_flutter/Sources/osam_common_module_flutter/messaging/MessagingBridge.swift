//
//  MessagingBridge.swift
//  
//
//  Created by Gustavo Lorena on 26/11/25.
//
import OSAMCommon
import Flutter

class MessagingBridge: NSObject, FlutterStreamHandler, MessagingWrapper {

    private var eventSink: FlutterEventSink?
    private static let TOPIC = "topic"
    private static let ACTION = "action"
    private static let GET_TOKEN = "getToken"
    private static let SUBSCRIBE = "subscribe"
    private static let UNSUBSCRIBE = "unsubscribe"

    func subscribeToTopic(topic: String) async {
        // Platform channel communication must happen on the main thread.
        DispatchQueue.main.async { [weak self] in
            self?.eventSink?([
                                 MessagingBridge.TOPIC: topic,
                                 MessagingBridge.ACTION: MessagingBridge.SUBSCRIBE
                             ])
        }
    }

    func unsubscribeFromTopic(topic: String) async {
        // Platform channel communication must happen on the main thread.
        DispatchQueue.main.async { [weak self] in
            self?.eventSink?([
                                 MessagingBridge.TOPIC: topic,
                                 MessagingBridge.ACTION: MessagingBridge.UNSUBSCRIBE
                             ])
        }
    }

    func getToken() async -> String {
        // Asynchronously send a notification event over the EventChannel.
        // This is a "fire-and-forget" operation; the function does not wait for it to complete.
        DispatchQueue.main.async { [weak self] in
            self?.eventSink?([
                                 MessagingBridge.TOPIC: "",
                                 MessagingBridge.ACTION: MessagingBridge.GET_TOKEN
                             ])
        }

        // Immediately read the token from UserDefaults.
        // The "flutter." prefix is automatically added by Flutter's shared_preferences
        // plugin and must be included when reading the value natively.
        let token = UserDefaults.standard.string(forKey: "flutter.fcm_token")

        // Return the retrieved token, or an empty string if it was nil.
        return token ?? ""
    }
    

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
