import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let controller = WKUserContentController()

        // CSS для light/dark темы
        let lightDarkCSS = """
        :root { color-scheme: light dark; }
        body {
            padding-left: 16px !important;
            padding-right: 16px !important;
            box-sizing: border-box;
        }
        """
        if let base64 = lightDarkCSS.data(using: .utf8)?.base64EncodedString() {
            let cssInjection = """
            javascript:(function() {
                var parent = document.getElementsByTagName('head').item(0);
                var style = document.createElement('style');
                style.type = 'text/css';
                style.innerHTML = window.atob('\(base64)');
                parent.appendChild(style);
            })()
            """
            let cssScript = WKUserScript(source: cssInjection, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
            controller.addUserScript(cssScript)
        }

        // Скрипт для показа только нужного блока
        let filterScript = WKUserScript(source: """
        javascript:(function() {
            document.body.querySelectorAll('body > *').forEach(el => {
                if (!el.classList.contains('document') && !el.classList.contains('content__document') && !el.classList.contains('i-bem')) {
                    el.style.display = 'none';
                }
            });
            let docBlock = document.querySelector('.document.content__document.i-bem');
            if (docBlock) {
                document.body.innerHTML = '';
                document.body.appendChild(docBlock);
            }
        })()
        """, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        controller.addUserScript(filterScript)

        config.userContentController = controller
        return WKWebView(frame: .zero, configuration: config)
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
