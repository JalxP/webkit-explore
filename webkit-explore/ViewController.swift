//
//  ViewController.swift
//  webkit-explore
//
//  Created by João Aleixo on 28/02/2022.
//

import WebKit

class ViewController: UIViewController {

    var webView: WKWebView!
    
    // MARK: - Life cycle
    override func loadView() {
        guard let config = loadConfiguration() else {
            return
        }
        webView = WKWebView(frame: .zero, configuration: config)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let htmlPath = Bundle.main.url(forResource: "page", withExtension: "html") else {
            return
        }
        
        webView.loadFileURL( htmlPath, allowingReadAccessTo: htmlPath)
    }

    
    private func loadConfiguration() -> WKWebViewConfiguration? {
        guard
            let scriptPath = Bundle.main.path(forResource: "script", ofType: "js"),
            let scriptSource = try? String(contentsOfFile: scriptPath)
        else { return nil }
        
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()

        let userScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
//        userContentController.add(self, name: "gbMessageHandler")
        userContentController.addScriptMessageHandler(self, contentWorld: .page, name: "gbMessageHandlerWithReply")
        userContentController.addUserScript(userScript)
        config.userContentController = userContentController
        
        return config
    }
}

// MARK: - WKNavigationDelegate

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let messageString = message.body as? String else {
            return
        }
        print("Message received: \(messageString)")
    }
}

// MARK: - WKUserContentController

extension ViewController: WKScriptMessageHandlerWithReply {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage, replyHandler: @escaping (Any?, String?) -> Void) {

        if message.name == "gbMessageHandlerWithReply" {
            if let messageString = message.body as? String {
                print("Message received: \(messageString)")
                replyHandler("Hello, from native!", nil)
            }
            return
        }
    }
}
