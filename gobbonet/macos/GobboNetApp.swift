import AppKit
import Darwin
import Foundation
import Network
import WebKit

final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, WKNavigationDelegate {
    private var window: NSWindow!
    private var webView: WKWebView!
    private var backend: Process?
    private var backendOutput: Pipe?
    private var startedBackend = false
    private var loadedChat = false
    private var healthTimer: Timer?
    private var terminationSignalSource: DispatchSourceSignal?

    private var resourcesRoot: URL {
        Bundle.main.resourceURL!.appendingPathComponent("GobboNet", isDirectory: true)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        installTerminationSignalHandlers()
        createWindow()
        startBackendIfNeeded()
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        stopBackend()
        return .terminateNow
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApp.terminate(nil)
        return false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let title = webView.title ?? ""
        window.title = title.isEmpty ? "GobboNet" : title
    }

    private func createWindow() {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1280, height: 820),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "GobboNet"
        window.minSize = NSSize(width: 760, height: 520)
        window.center()
        window.contentView = webView
        window.delegate = self
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func installTerminationSignalHandlers() {
        signal(SIGTERM, SIG_IGN)
        signal(SIGINT, SIG_IGN)
        let source = DispatchSource.makeSignalSource(signal: SIGTERM, queue: .main)
        source.setEventHandler { [weak self] in
            self?.stopBackend()
            NSApp.terminate(nil)
        }
        source.resume()
        terminationSignalSource = source
    }

    private func startBackendIfNeeded() {
        if portIsOpen() {
            loadChatWhenReady()
            return
        }

        let launcher = resourcesRoot.appendingPathComponent("macos/run.sh")
        guard FileManager.default.isExecutableFile(atPath: launcher.path) else {
            showError("GobboNet launcher is missing or not executable:\n\(launcher.path)")
            return
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = [launcher.path]
        process.currentDirectoryURL = resourcesRoot
        var environment = ProcessInfo.processInfo.environment
        environment["GOBBONET_NO_BROWSER"] = "1"
        process.environment = environment

        let output = Pipe()
        process.standardOutput = output
        process.standardError = output
        backendOutput = output
        backend = process
        startedBackend = true

        output.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            guard !data.isEmpty, let text = String(data: data, encoding: .utf8) else { return }
            DispatchQueue.main.async {
                self?.handleBackendOutput(text)
            }
        }

        do {
            try process.run()
        } catch {
            showError("Could not start GobboNet:\n\(error.localizedDescription)")
            return
        }

        healthTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            self?.loadChatWhenReady()
        }
    }

    private func handleBackendOutput(_ text: String) {
        guard let range = text.range(of: "http://127.0.0.1:") else { return }
        let suffix = text[range.upperBound...]
        let port = suffix.prefix(while: { $0.isNumber })
        guard !port.isEmpty else { return }
        let urlString = "http://127.0.0.1:\(port)/"
        if !loadedChat, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }

    private func loadChatWhenReady() {
        guard !loadedChat, portIsOpen(), let url = URL(string: "http://127.0.0.1:9066/chat.html") else { return }
        loadedChat = true
        healthTimer?.invalidate()
        healthTimer = nil
        webView.load(URLRequest(url: url))
    }

    private func portIsOpen() -> Bool {
        let connection = NWConnection(host: NWEndpoint.Host("127.0.0.1"), port: 9066, using: .tcp)
        let semaphore = DispatchSemaphore(value: 0)
        var open = false
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                open = true
                semaphore.signal()
            case .failed, .cancelled:
                semaphore.signal()
            default:
                break
            }
        }
        connection.start(queue: DispatchQueue.global(qos: .userInitiated))
        _ = semaphore.wait(timeout: .now() + 0.35)
        connection.cancel()
        return open
    }

    private func stopBackend() {
        healthTimer?.invalidate()
        healthTimer = nil
        backendOutput?.fileHandleForReading.readabilityHandler = nil
        guard startedBackend, let process = backend, process.isRunning else { return }

        // run.sh traps SIGTERM and stops the Go server it started. The child
        // process is intentionally untouched when another instance owned port 9066.
        process.terminate()
        process.waitUntilExit()
        backend = nil
        backendOutput = nil
    }

    private func showError(_ message: String) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = "GobboNet could not start"
        alert.informativeText = message
        alert.addButton(withTitle: "Quit")
        alert.runModal()
        NSApp.terminate(nil)
    }
}

let application = NSApplication.shared
let delegate = AppDelegate()
application.delegate = delegate
application.run()
