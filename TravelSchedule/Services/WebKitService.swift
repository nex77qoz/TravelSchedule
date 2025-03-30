import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView(frame: .zero)
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  var html = String(data: data, encoding: .utf8) else {
                return
            }

            if let article = extractArticleBlock(from: html) {
                html = wrapWithDarkStyledHTML(content: article)
            } else {
                html = "<body style='background:#000; color:#fff; font-family:system-ui;'>Не удалось загрузить документ</body>"
            }

            DispatchQueue.main.async {
                webView.loadHTMLString(html, baseURL: url)
            }
        }.resume()
    }

    private func extractArticleBlock(from html: String) -> String? {
        guard let startRange = html.range(of: "<article role=\"article\" aria-labelledby=\"ariaid-title1\" class=\"doc-c-article\""),
              let endRange = html.range(of: "</article>", range: startRange.upperBound..<html.endIndex) else {
            return nil
        }

        let articleStart = startRange.lowerBound
        let articleEnd = html.range(of: "</article>", range: endRange.lowerBound..<html.endIndex)?.upperBound ?? endRange.upperBound
        return String(html[articleStart..<articleEnd])
    }

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
}
