import os
import http.server
import socketserver


class MyHttpRequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.path = '/index.html'
        self.path = f'{os.environ.get("SCRIPTS_DIR")}/localhost{self.path}'
        self.path = self.path.replace(os.environ.get('HOME'), '')

        print('\n', self.path, '\n')
        return http.server.SimpleHTTPRequestHandler.do_GET(self)


Handler = MyHttpRequestHandler

if __name__ == "__main__":
    # port = int(os.environ.get("PORT", 3160))

    with socketserver.TCPServer(("", 3160), Handler) as httpd:
        httpd.serve_forever()
