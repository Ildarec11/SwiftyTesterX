//
//  SwiftyTesterLibEntryPoint.swift
//  SwiftyTesterLib
//
//  Created by Ильдар Арсламбеков on 30.03.2024.
//

import UIKit
import Foundation

import os

final public class SwiftyTesterLibEntryPoint: NSObject {
    
    private let gestureLogger = GesturesLogger()

    public static let shared = SwiftyTesterLibEntryPoint()
    
    public func start() {
        
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        URLProtocol.registerClass(CustomURLProtocol.self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        window.addGestureRecognizer(tapGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRightGesture.direction = .right
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUpGesture.direction = .up
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeftGesture.direction = .left
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDownGesture.direction = .down
        window.addGestureRecognizer(swipeRightGesture)
        window.addGestureRecognizer(swipeUpGesture)
        window.addGestureRecognizer(swipeLeftGesture)
        window.addGestureRecognizer(swipeDownGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        window.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .ended || gesture.state == .changed {
            gestureLogger.log(gesture: gesture)
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            gestureLogger.log(gesture: gesture)
        }
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            gestureLogger.log(gesture: gesture)
        }
    }
}

extension SwiftyTesterLibEntryPoint: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class CustomURLProtocol: URLProtocol {
    private var dataTask: URLSessionDataTask?
    private var isHandled = false
    private var receivedResponse = false

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url?.absoluteString else { return false }
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard !isHandled else { return }
        isHandled = true

        if let url = request.url?.absoluteString {
            print("-- Запрос: \(url)")
        }

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        dataTask = session.dataTask(with: request)
        dataTask?.resume()
    }

    override func stopLoading() {
        dataTask?.cancel()
    }
}

extension CustomURLProtocol: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let url = request.url?.absoluteString {
            // here need to log
            GesturesLogger().log(url: url, body: json)
        }
        if !receivedResponse {
            receivedResponse = true
            client?.urlProtocol(self, didReceive: URLResponse(), cacheStoragePolicy: .notAllowed)
        }
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }
}
