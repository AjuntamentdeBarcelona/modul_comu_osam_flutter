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

    func subscribeToTopic(topic: String) async {
            // Platform channel communication must happen on the main thread.
            // Capture self weakly to satisfy Sendable requirements for the @Sendable closure.
            DispatchQueue.main.async { [weak self] in
                self?.eventSink?(["topic": topic])
            }
        }

    func unsubscribeFromTopic(topic: String) async {
            // Platform channel communication must happen on the main thread.
            // Capture self weakly to satisfy Sendable requirements for the @Sendable closure.
            DispatchQueue.main.async { [weak self] in
                self?.eventSink?(["topic": topic])
            }
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
