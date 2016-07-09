const http = require('http')

function computation() {
  for (var i = 0; i < 10000; i++) {
    console.log(i)
  }
}

computation()

const server = http.createServer((req, res) => {
  computation()
  res.end("Hello World")
})

server.on('clientError', (err, socket) => {
  socket.end('HTTP/1.1 400 Bad Request\r\n\r\n')
})

server.listen(8080, () => {
  console.log('Server listening on: http://localhost:%s', 8080)
})