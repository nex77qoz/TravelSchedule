import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let darkMode: Bool

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView(frame: .zero)
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // Загружаем HTML вручную
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  var html = String(data: data, encoding: .utf8) else {
                return
            }

            // 🎯 Извлекаем только нужную часть
            if let article = extractArticleBlock(from: html) {
                html = darkMode
                    ? wrapWithDarkStyledHTML(content: article)
                    : wrapWithLightHTML(content: article)
            } else {
                html = darkMode
                    ? "<body style='background:#000; color:#fff;'>Не удалось загрузить документ</body>"
                    : "<body>Не удалось загрузить документ</body>"
            }

            DispatchQueue.main.async {
                webView.loadHTMLString(html, baseURL: url)
            }
        }.resume()
    }

    // 📦 Извлекаем <article class="doc-c-article">...</article>
    private func extractArticleBlock(from html: String) -> String? {
        guard let startRange = html.range(of: "<article role=\"article\" aria-labelledby=\"ariaid-title1\" class=\"doc-c-article\""),
              let endRange = html.range(of: "</article>", range: startRange.upperBound..<html.endIndex) else {
            return nil
        }

        let articleStart = startRange.lowerBound
        let articleEnd = html.range(of: "</article>", range: endRange.lowerBound..<html.endIndex)?.upperBound ?? endRange.upperBound
        return String(html[articleStart..<articleEnd])
    }

    // 🖤 Тёмная тема
    private func wrapWithDarkStyledHTML(content: String) -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                html {
                    background-color: #000;
                }
                body {
                    background-color: #000;
                    color: #fff;
                    padding: 16px;
                    font-family: -apple-system, system-ui, sans-serif;
                    box-sizing: border-box;
                }
                a {
                    color: #6fa8ff;
                }
                h1, h2, h3, h4, h5, h6 {
                    color: #fff;
                }
            </style>
        </head>
        <body>
            \(content)
        </body>
        </html>
        """
    }

    // 🤍 Светлая тема
    private func wrapWithLightHTML(content: String) -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                html {
                    background-color: #fff;
                }
                body {
                    background-color: #fff;
                    color: #000;
                    padding: 16px;
                    font-family: -apple-system, system-ui, sans-serif;
                    box-sizing: border-box;
                }
                a {
                    color: #0066cc;
                }
                h1, h2, h3, h4, h5, h6 {
                    color: #000;
                }
            </style>
        </head>
        <body>
            \(content)
        </body>
        </html>
        """
    }
}
